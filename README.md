---

# 🌿 Tikog Leaf Classification

A Flutter-based mobile app that uses **TensorFlow Lite (TFLite)** to classify Tikog leaves—an essential raw material used in traditional mat weaving in **Samar, Philippines**.

This app aims to assist farmers, artisans, and buyers in identifying **standard** and **substandard** Tikog leaves using image processing and machine learning.

✨ Features

* 🔍 **Leaf Classification using TFLite**

  * Utilizes a trained TFLite model with **sigmoid activation** to classify Tikog leaves.
  * Determines if a leaf is **standard** (suitable for weaving) or **substandard** (unsuitable).

* 📷 **Dual Classification Modes**

  * **Image Upload / Camera Capture**: Users can upload an image or take a photo of a Tikog leaf for classification.
  * **Live Detection**: Real-time classification using the camera feed.

* ⚙️ **Offline Capability**

  * Runs fully offline once the model is downloaded.

 🛠 Tech Stack

* **Flutter**
* **TensorFlow Lite (TFLite)**
* **Camera / Image Picker Plugin**
* **Image Preprocessing Utilities**

📸 Usage

1. Choose between:

   * 📁 **Upload an Image** of a Tikog leaf.
   * 📷 **Take a Photo** directly from the app.
   * 🎥 **Live Detection** using your device’s camera.
2. The model processes the image and returns:

   * ✅ **Standard** — suitable for weaving.
   * ❌ **Substandard** — not ideal for craftsmanship use.

🌾 About Tikog

Tikog is a unique grass-like plant found in marshy areas of Samar. Its leaves are dried, dyed, and handwoven by local artisans into beautiful handicrafts such as mats (**banig**), bags, and wallets. Ensuring the quality of Tikog leaves helps preserve the cultural heritage and improves product quality.

🧠 Model Details

* **Model Type**: TFLite
* **Activation**: Sigmoid
* **Output**: Binary classification (0 = Substandard, 1 = Standard)
* **Input Format**: RGB image resized to match model input (e.g., 224x224)
* **Preprocessing**: Normalization (0-1 scaling)

🧪 Getting Started

# Prerequisites

* Flutter SDK installed
* Device/emulator with a camera

# Installation

```bash
git clone https://github.com/your-repo/tikog-leaf-classification.git
cd tikog-leaf-classification
flutter pub get
flutter run
```

 📚 Resources

* [Flutter: Write your first app](https://docs.flutter.dev/get-started/codelab)
* [TensorFlow Lite for Flutter](https://www.tensorflow.org/lite/flutter)
* [Flutter Cookbook](https://docs.flutter.dev/cookbook)

---
