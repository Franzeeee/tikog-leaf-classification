# Tikog Leaf Classification

Tikog Leaf Classification is a Flutter mobile application that uses **TensorFlow Lite (TFLite)** to classify Tikog leaves, a key material in the traditional weaving craft of Samar, Philippines.

The app helps farmers, artisans, and buyers determine if a Tikog leaf is **standard** (good for weaving) or **substandard** (not ideal), using machine learning and image processing.

## Features

- **TFLite-Based Classification**
  - Uses a custom-trained TFLite model with **sigmoid activation**.
  - Binary output: `0` for substandard, `1` for standard leaves.

- **Dual Image Input Modes**
  - **Image Upload or Camera Capture**: Pick from gallery or take a photo.
  - **Live Detection**: Real-time classification using device camera.

- **Offline-Ready**
  - App functions entirely offline once the model is bundled or downloaded.

## About Tikog

Tikog is a grass-like plant found in the marshy areas of Samar, Philippines. Its leaves are traditionally dried, dyed, and handwoven into mats (locally called *banig*), bags, and other products. Ensuring high-quality leaves supports local craftsmanship and preserves cultural heritage.

## Model Details

- **Format**: TensorFlow Lite (.tflite)
- **Activation**: Sigmoid
- **Input Shape**: RGB image resized (e.g., 224x224)
- **Preprocessing**: Normalization (pixel values scaled to 0–1)
- **Output**: Single float between 0 and 1 (thresholded at 0.5)

## Tech Stack

- Flutter
- TensorFlow Lite
- Camera and Image Picker Plugins
- Dart + TFLite plugin
- Image preprocessing with Dart

## How to Use

1. Launch the app.
2. Choose one of the input modes:
   - Upload a Tikog leaf image.
   - Take a photo.
   - Enable live detection mode.
3. The model will output the result:
   - **Standard**: Suitable for weaving.
   - **Substandard**: Not suitable.

## Installation

### Prerequisites

- Flutter SDK installed
- Android/iOS device or emulator
- A working camera on the device

### Steps

```bash
git clone https://github.com/your-repo/tikog-leaf-classification.git
cd tikog-leaf-classification
flutter pub get
flutter run
```


## Resources

- [Flutter Docs](https://docs.flutter.dev)
- [TensorFlow Lite for Flutter](https://www.tensorflow.org/lite/flutter)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

## License

This project is licensed under the [MIT License](LICENSE).

