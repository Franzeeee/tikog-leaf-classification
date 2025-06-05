import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    var scaffold2 = Scaffold(
      appBar: AppBar(title: const Text('About the Owner'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Developer Image
            Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/user.png',
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Developer Name
            const Center(
              child: Text(
                'Las Johansen B. Caluza',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Profession
            const Center(
              child: Text(
                'Data Analyst | Machine Learning Practitioner | Network Security Enthusiast | IT Educator | Software Developer',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 25),

            // Biography
            const Text(
              'Hello! I am John Doe, an Associate Professor at Leyte Normal University, specializing in Machine Learning, Data Analytics, Network Security, IT Education, and Software Development. He holds a Ph.D. in Technology Management and serves as Co-Editor-in-Chief of the Journal of Education and Society.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15),
            const Text(
              'I am also an active researcher and educator, recognized for his contributions to academic innovation and community ICT development. His work bridges technology and education, empowering both students and professionals in the digital age.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 25),

            const Text(
              'Contact Me:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 15),

            // Contact Info with Material Icons
            Row(
              children: const [
                Icon(Icons.email, color: Colors.deepOrange),
                SizedBox(width: 10),
                Text(
                  'lasjohansencaluza@gmail.com',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.language, color: Colors.deepOrange),
                SizedBox(width: 10),
                Text('www.johndoe.dev', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.code, color: Colors.deepOrange),
                SizedBox(width: 10),
                Text('github.com/johndoe', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.person, color: Colors.deepOrange),
                SizedBox(width: 10),
                Text('linkedin.com/in/johndoe', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.alternate_email, color: Colors.deepOrange),
                SizedBox(width: 10),
                Text('@johndoe_dev', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
    var scaffold = scaffold2;
    return scaffold;
  }
}
