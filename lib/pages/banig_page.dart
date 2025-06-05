import 'package:flutter/material.dart';

class BanigPage extends StatelessWidget {
  const BanigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About the Banig'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/banig.jpeg',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'The Famous “Banig” in Basey, Samar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),

            // Description
            const Text(
              'A Banig is a traditional handwoven mat commonly used in the Philippines and parts of East Asia for sleeping and sitting. '
              'While it may look like fabric, it is technically not a textile. Banig is made from dried leaves of plants such as buri, pandan, or tikog—depending on the region.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 25),

            // Feature tiles
            _buildFeatureTile(
              Icons.category,
              'Materials',
              'Banig is traditionally woven from natural plant leaves—buri in Sulu, pandan in some regions, and tikog in Basey, Samar. These leaves are dried, dyed, and cut into strips.',
            ),
            _buildFeatureTile(
              Icons.palette,
              'Design & Colors',
              'Banigs range from simple to highly decorative. Those from Basey, Samar are known for their intricate, colorful patterns dyed in vibrant shades.',
            ),
            _buildFeatureTile(
              Icons.transform,
              'Beyond Sleeping Mats',
              'Today, Banig is no longer just for sleeping. It is turned into bags, placemats, pillows, wall panels, and decorative pieces due to increasing demand.',
            ),
            _buildFeatureTile(
              Icons.history_edu,
              'Cultural Relevance',
              'Banig reflects Filipino craftsmanship and culture. The mat holds historical value and is still made using traditional techniques passed down through generations.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
