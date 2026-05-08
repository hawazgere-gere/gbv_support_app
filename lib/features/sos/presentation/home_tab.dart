/* 
 * ─────────────────────────────────────────────────────────────
 * 🛡️ HOME TAB — SAFE DASHBOARD EXPERIENCE
 * -------------------------------------------------------------
 * PURPOSE:
 * Provides users with quick access to emergency tools,
 * reporting systems, counseling resources, shelters,
 * legal support, and educational safety information.
 */

import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  // 🌍 Primary Theme Colors
  static const Color primaryBrown = Color(0xFF5D4037);
  static const Color lightBackground = Color(0xFFF8F5F2);

  @override
  Widget build(BuildContext context) {
    // 📱 Responsive screen width
    final width = MediaQuery.of(context).size.width;

    return Container(
      color: lightBackground,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ───────────────── HEADER SECTION ─────────────────
              const Text(
                "Welcome Back,",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "You are in a safe space.",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryBrown,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Your privacy, safety, and support matter here.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // ───────────────── EMERGENCY ALERT BANNER ─────────────────
              _buildEmergencyBanner(),

              const SizedBox(height: 28),

              // ───────────────── QUICK STATISTICS ─────────────────
              _buildQuickStats(),

              const SizedBox(height: 30),

              // ───────────────── SECTION TITLE ─────────────────
              const Text(
                "Resources & Support",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: primaryBrown,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Access trusted tools and support services.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 18),

              // ───────────────── RESPONSIVE GRID ─────────────────
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: width > 700 ? 3 : 2,
                childAspectRatio: 1.05,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context: context,
                    title: "File Report",
                    subtitle: "Submit secure incident reports",
                    icon: Icons.assignment_late_rounded,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pushNamed(context, '/report');
                    },
                  ),
                  _buildMenuCard(
                    context: context,
                    title: "Find Shelter",
                    subtitle: "Locate safe shelters nearby",
                    icon: Icons.home_work_rounded,
                    color: Colors.blue,
                    onTap: () {
                      _showResourceDialog(
                        context,
                        "Shelter Support",
                        "• Mekelle Women Protection Center\n"
                            "• Emergency Safe Houses\n"
                            "• Temporary Child Protection Centers\n\n"
                            "Visit the Map section to view nearby support centers and shelter locations.",
                      );
                    },
                  ),
                  _buildMenuCard(
                    context: context,
                    title: "Legal Aid",
                    subtitle: "Get free legal guidance",
                    icon: Icons.gavel_rounded,
                    color: Colors.teal,
                    onTap: () {
                      _showResourceDialog(
                        context,
                        "Legal Assistance",
                        "Free legal consultation services are available through:\n\n"
                            "• Regional Justice Bureau\n"
                            "• Women & Children Affairs Office\n"
                            "• Community Legal Volunteers\n\n"
                            "Emergency legal support is available during working hours.",
                      );
                    },
                  ),
                  _buildMenuCard(
                    context: context,
                    title: "Counseling",
                    subtitle: "24/7 emotional support",
                    icon: Icons.favorite_rounded,
                    color: Colors.purple,
                    onTap: () {
                      _showResourceDialog(
                        context,
                        "Counseling Services",
                        "Professional counselors are available for emotional and psychological support.\n\n"
                            "📞 Hotline: 952\n"
                            "🕒 Available: 24/7\n"
                            "🔒 Completely confidential",
                      );
                    },
                  ),
                  _buildMenuCard(
                    context: context,
                    title: "Safety Tips",
                    subtitle: "Learn protective measures",
                    icon: Icons.shield_outlined,
                    color: Colors.green,
                    onTap: () {
                      _showResourceDialog(
                        context,
                        "Safety Tips",
                        "• Keep emergency contacts nearby\n"
                            "• Share your location with trusted people\n"
                            "• Avoid isolated unsafe areas\n"
                            "• Keep your phone charged\n"
                            "• Use the SOS feature during danger",
                      );
                    },
                  ),
                  _buildMenuCard(
                    context: context,
                    title: "Emergency Help",
                    subtitle: "Important hotline numbers",
                    icon: Icons.call_rounded,
                    color: Colors.red,
                    onTap: () {
                      _showResourceDialog(
                        context,
                        "Emergency Contacts",
                        "🚓 Police: 991\n"
                            "🚑 Ambulance: 907\n"
                            "📞 Counseling Hotline: 952\n"
                            "🛡️ Women Protection Office: Local regional office",
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ───────────────── MOTIVATIONAL CARD ─────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.brown.shade50,
                      Colors.orange.shade50,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: primaryBrown,
                      size: 34,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "You are valuable, strong, and deserving of safety.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                        color: primaryBrown,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 🚨 EMERGENCY INFORMATION BANNER
  // ─────────────────────────────────────────────────────────────
  Widget _buildEmergencyBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "Need immediate help? Hold the SOS emergency button to send your emergency alert and current location.",
              style: TextStyle(
                color: Colors.red.shade900,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 📊 QUICK INFO CARDS
  // ─────────────────────────────────────────────────────────────
  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.security,
            title: "Secure",
            subtitle: "Encrypted Reports",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.location_on,
            title: "Nearby",
            subtitle: "Help Centers",
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryBrown, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryBrown,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 🧩 MENU CARD COMPONENT
  // ─────────────────────────────────────────────────────────────
  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.12),
                child: Icon(icon, color: color, size: 26),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 📦 RESOURCE DIALOG
  // ─────────────────────────────────────────────────────────────
  void _showResourceDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryBrown,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(color: primaryBrown),
            ),
          ),
        ],
      ),
    );
  }
}
