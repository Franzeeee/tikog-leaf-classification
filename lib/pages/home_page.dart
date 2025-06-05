import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/live_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tikog Classification',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Welcome Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: const Color.fromARGB(255, 27, 93, 30), // Green tone
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "👋 Welcome to the Tikog Leaf Classifier App!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "This app helps determine whether Tikog leaves are STANDARD or SUBSTANDARD using AI-based image classification.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Get Started Section
              const Text(
                'Get Started',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Placeholder
                    Container(
                      height: 240,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          144,
                          49,
                          49,
                          49,
                        ), // moved color here
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/tikog/tikog-home.jpg',
                          ), // fixed path
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Tikog Background Image",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),

                    // Dark overlay
                    Container(
                      height: 240,
                      color: Colors.black.withOpacity(0.5),
                    ),

                    // Content
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "🌿 Ready to get started?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Our AI model will help determine whether the leaf is Standard or Substandard, ensuring quality for every weave.",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFF2E7D32,
                                ), // match green
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LivePage(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize:
                                    MainAxisSize
                                        .min, // so the button wraps the content
                                children: const [
                                  Icon(Icons.camera_alt, color: Colors.white),
                                  SizedBox(
                                    width: 8,
                                  ), // space between icon and text
                                  Text(
                                    "Start Live Detection",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Tikog Info
              const Text(
                'About Tikog',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),

              Card(
                color: const Color.fromARGB(
                  255,
                  209,
                  232,
                  207,
                ), // Soft light yellow with 70% opacity
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Color.fromARGB(248, 7, 112, 4), // Border color
                    width: 1, // Border width
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 240,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            144,
                            49,
                            49,
                            49,
                          ), // moved color here
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/tikog/tikog-weaving.jpg',
                            ), // fixed path
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          "What is Tikog?",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Tikog is a wild grass used to make Banig. Quality control is important to ensure strong and beautiful weaves.",
                        style: TextStyle(color: Colors.black87),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
