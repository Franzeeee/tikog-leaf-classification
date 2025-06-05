import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;

class LivePage extends StatefulWidget {
  const LivePage({Key? key}) : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  bool _isProcessingFrame = false;
  late Interpreter _interpreter;
  String _predictionLabel = "";
  Timer? _frameTimer;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    loadModel();
    _initializeCamera();
  }

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/model/FModel701sigmoid200.tflite',
      options: InterpreterOptions()..threads = 4,
    );
  }

  Future<void> _initializeCamera() async {
    await Permission.camera.request();

    if (await Permission.camera.isGranted) {
      cameras = await availableCameras();

      if (cameras != null && cameras!.isNotEmpty) {
        _controller = CameraController(
          cameras![0],
          ResolutionPreset.low,
          imageFormatGroup: ImageFormatGroup.yuv420,
        );
        await _controller!.initialize();

        if (!mounted) return;

        _controller!.startImageStream((CameraImage image) async {
          if (_isDisposed || _isProcessingFrame) return;

          _isProcessingFrame = true;

          _frameTimer ??= Timer(const Duration(milliseconds: 300), () async {
            if (_isDisposed) return;

            try {
              final floatData = await _processCameraImageInIsolate(image);

              if (floatData.isNotEmpty && !_isDisposed) {
                var input = List.generate(
                  1,
                  (_) => List.generate(
                    224,
                    (y) => List.generate(
                      224,
                      (x) => List.generate(
                        3,
                        (c) => floatData[(y * 224 + x) * 3 + c],
                      ),
                    ),
                  ),
                );

                var output = List.filled(1, 0.0).reshape([1, 1]);

                _interpreter.run(input, output);

                if (!_isDisposed) {
                  setState(() {
                    _predictionLabel =
                        output[0][0] > 0.5
                            ? "Standard Quality (${(output[0][0] * 100).toStringAsFixed(1)}%)"
                            : "Substandard Quality (${(output[0][0] * 100).toStringAsFixed(1)}%)";
                  });

                  debugPrint("Model output: $_predictionLabel");
                }
              }
            } catch (e) {
              debugPrint("Frame error: $e");
            } finally {
              _isProcessingFrame = false;
              _frameTimer = null;
            }
          });

          if (_frameTimer!.isActive == false) {
            _frameTimer = null;
          }
        });

        if (!_isDisposed) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Camera permission denied")),
        );
      }
    }
  }

  Future<Float32List> _processCameraImageInIsolate(CameraImage image) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(_imageProcessingIsolate, [
      image.planes,
      image.width,
      image.height,
      receivePort.sendPort,
    ]);

    final result = await receivePort.first;
    if (_isDisposed) return Float32List(0);
    return result as Float32List;
  }

  static void _imageProcessingIsolate(List<dynamic> args) {
    final List<Plane> planes = args[0];
    final int width = args[1];
    final int height = args[2];
    final SendPort sendPort = args[3];

    try {
      final img.Image imgData = _convertYUV420toImage(planes, width, height);
      final img.Image resized = img.copyResize(
        imgData,
        width: 224,
        height: 224,
      );

      final pixels = resized.getBytes(order: img.ChannelOrder.rgb);
      final floatBuffer = Float32List(224 * 224 * 3);

      for (int i = 0; i < pixels.length; i++) {
        floatBuffer[i] = (pixels[i] - 127.5) / 127.5;
      }

      sendPort.send(floatBuffer);
    } catch (e) {
      debugPrint("Isolate error: $e");
      sendPort.send(Float32List(0));
    }
  }

  static img.Image _convertYUV420toImage(
    List<Plane> planes,
    int width,
    int height,
  ) {
    final int uvRowStride = planes[1].bytesPerRow;
    final int uvPixelStride = planes[1].bytesPerPixel ?? 1;

    final img.Image image = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
        final int yp = planes[0].bytes[y * planes[0].bytesPerRow + x];
        final int up = planes[1].bytes[uvIndex];
        final int vp = planes[2].bytes[uvIndex];

        final int r = (yp + 1.370705 * (vp - 128)).clamp(0, 255).toInt();
        final int g =
            (yp - 0.337633 * (up - 128) - 0.698001 * (vp - 128))
                .clamp(0, 255)
                .toInt();
        final int b = (yp + 1.732446 * (up - 128)).clamp(0, 255).toInt();

        image.setPixelRgb(x, y, r, g, b);
      }
    }

    return image;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _frameTimer?.cancel();
    _controller?.stopImageStream();
    _controller?.dispose();
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
          _isCameraInitialized
              ? Stack(
                children: [
                  Center(child: CameraPreview(_controller!)),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: SafeArea(
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _predictionLabel.isEmpty
                              ? "Analyzing..."
                              : _predictionLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.redAccent,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}

extension ListReshape<T> on List<T> {
  List reshape(List<int> dims) {
    if (dims.isEmpty) return this;
    int total = dims.reduce((a, b) => a * b);
    if (length != total) {
      throw Exception(
        "List length (${length}) does not match the product of dims ($total)",
      );
    }
    return _reshapeHelper(this, dims, 0);
  }

  List _reshapeHelper(List list, List<int> dims, int dim) {
    int size = dims[dim];
    if (dim == dims.length - 1) {
      return list.sublist(0, size);
    }

    List result = [];
    int chunkSize = dims.sublist(dim + 1).reduce((a, b) => a * b);
    for (int i = 0; i < size; i++) {
      result.add(
        _reshapeHelper(
          list.sublist(i * chunkSize, (i + 1) * chunkSize),
          dims,
          dim + 1,
        ),
      );
    }
    return result;
  }
}
