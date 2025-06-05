import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:isolate';
import 'live_page.dart';

class DetectPage extends StatefulWidget {
  const DetectPage({super.key});

  @override
  _DetectPageState createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> {
  int detectionType =
      0; // 0 For Nothing, 1 For Image Classification, 2 For Live Detection

  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _result = "";
  int _imageHeight = 0;
  int _imageWidth = 0;
  bool _isModelLoading = false;
  bool _isDetecting = false;
  Interpreter? _interpreter;
  double _confidenceLevel = 0; // Static confidence level for demo

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  Future<void> _loadModel() async {
    setState(() => _isModelLoading = true);
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/model/FModel701sigmoid200.tflite',
        options: InterpreterOptions()..threads = 4,
      );
      debugPrint("Model loaded successfully");
    } catch (e) {
      debugPrint("Error loading model: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to load model")));
    }
    setState(() => _isModelLoading = false);
  }

  Future<void> _classifyImage(File image) async {
    if (_isDetecting || _interpreter == null) return;

    setState(() {
      _isDetecting = true;
      _confidenceLevel = 0;
      _result = "Detecting...";
    });

    try {
      final decodedImage = await decodeImageFromList(await image.readAsBytes());
      _imageWidth = decodedImage.width;
      _imageHeight = decodedImage.height;

      // Process image in background isolate
      final inputBuffer = await _processImageInBackground(image);

      // Prepare output tensor (adjust size based on your model)
      final outputBuffer = Float32List(1); // For binary classification

      _interpreter!.run(inputBuffer.buffer, outputBuffer.buffer);

      // Interpret results (assuming sigmoid output)
      final score = outputBuffer[0];
      debugPrint("Prediction score: $score");

      setState(() {
        if (score > 0.5) {
          _confidenceLevel = score * 100;
        } else {
          _confidenceLevel = (1 - score) * 100;
        }
      });

      setState(() {
        _result = score > 0.5 ? "Standard Quality" : "Substandard Quality";
      });
    } catch (e) {
      debugPrint("Error classifying image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Classification failed: ${e.toString()}")),
      );
    } finally {
      setState(() => _isDetecting = false);
    }
  }

  Future<Float32List> _processImageInBackground(File imageFile) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_imageProcessingIsolate, [
      imageFile.path,
      receivePort.sendPort,
    ]);

    return await receivePort.first as Float32List;
  }

  static void _imageProcessingIsolate(List<dynamic> args) async {
    final imagePath = args[0] as String;
    final sendPort = args[1] as SendPort;

    try {
      final imageFile = File(imagePath);
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes)!;
      final resized = img.copyResize(image, width: 224, height: 224);

      // Get RGB bytes and normalize to [-1, 1]
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

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Take a Picture'),
                  leading: const Icon(Icons.camera_alt),
                  onTap: () async {
                    Navigator.pop(context);
                    final photo = await _picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (photo != null) {
                      final imageFile = File(photo.path);
                      setState(() => _image = imageFile);
                      await _classifyImage(imageFile);
                    }
                  },
                ),
                ListTile(
                  title: const Text('Pick from Gallery'),
                  leading: const Icon(Icons.image),
                  onTap: () async {
                    Navigator.pop(context);
                    final photo = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (photo != null) {
                      final imageFile = File(photo.path);
                      setState(() => _image = imageFile);
                      await _classifyImage(imageFile);
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  Color getConfidenceColor(double confidence) {
    double value = (confidence / 100).clamp(0.0, 1.0);

    if (value < 0.5) {
      // From Red to Orange (0% to 50%)
      return Color.lerp(Colors.red, Colors.orange, value * 2)!;
    } else {
      // From Orange to Green (50% to 100%)
      return Color.lerp(Colors.orange, Colors.green, (value - 0.5) * 2)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tikog Leaf Detection")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.55,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const ui.Color.fromARGB(29, 101, 101, 101),
                ),
                child:
                    _isModelLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _image == null
                        ? Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueGrey, // Border color
                              width: 1.5, // Border width
                            ),
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // Optional: rounded corners
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.blueGrey,
                                size: 16,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "No Image Selected",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                        )
                        : Image.file(_image!, fit: BoxFit.contain),
              ),
              const SizedBox(height: 20),
              if (_result.isNotEmpty) ...[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detection Result: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _result,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color:
                                _result == "Standard Quality"
                                    ? Colors.green
                                    : _result == "Detecting..."
                                    ? const ui.Color.fromARGB(255, 0, 55, 255)
                                    : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Confidence Level: ${_confidenceLevel.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 16,
                            color: const ui.Color.fromARGB(255, 94, 94, 94),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _confidenceLevel / 100,
                            minHeight: 10,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              getConfidenceColor(_confidenceLevel),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ] else ...[
                const SizedBox(height: 20),
                Text(
                  "Select detection type",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        detectionType = 1;
                      });
                      _showImageSourceDialog();
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Take a Photo"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // customize as needed
                      ),
                    ),
                  ),
                  if (_image == null || detectionType == 0)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LivePage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.live_tv),
                      label: const Text("Live"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // customize as needed
                        ),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _image = null;
                          _result = "";
                          detectionType = 0;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Clear"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // customize as needed
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
