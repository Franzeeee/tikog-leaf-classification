// main_screen.dart
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/detect_page.dart';
import 'pages/banig_page.dart';
import 'pages/about_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    DetectPage(),
    BanigPage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 7, 121, 30),
        unselectedItemColor: const Color.fromARGB(255, 148, 168, 148),
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: "Detect",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bed_outlined),
            label: "Banig",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: "About",
          ),
        ],
      ),
    );
  }
}
