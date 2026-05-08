/* Top Comment: Home Tab Hub - Provides a professional Grid UI for resource access */
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🛡️ WELCOME SECTION
          const Text(
            "Welcome Back,",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const Text(
            "You are in a safe space.",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 20),

          // 🛡️ EMERGENCY BANNER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.red),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Need immediate help? Use the red button below to trigger an SOS.",
                    style: TextStyle(color: Colors.red.shade900, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 🛡️ FEATURE GRID (The "Professional" part)
          const Text(
            "Resources & Support",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildMenuCard(
                context,
                "File Report",
                Icons.assignment_late,
                Colors.orange,
              ),
              _buildMenuCard(
                context,
                "Find Shelter",
                Icons.home_work,
                Colors.blue,
              ),
              _buildMenuCard(context, "Legal Aid", Icons.gavel, Colors.teal),
              _buildMenuCard(
                context,
                "Counseling",
                Icons.favorite,
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Future navigation logic
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
