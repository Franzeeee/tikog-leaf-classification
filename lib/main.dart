import 'package:flutter/material.dart';
import 'pages/splash_page.dart'; // Import the splash screen
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/detect_page.dart';
import 'pages/banig_page.dart';
import 'main_screen.dart'; // Move this widget to a separate file

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Bottom Nav Demo',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Start here
    );
  }
}
