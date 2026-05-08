import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required Null Function(int index) onSwitchTab});

  static const Color primaryBrown = Color(0xFF8D6E63);
  static const Color darkBrown = Color(0xFF5D4037);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 24),
            _buildEmergencyStatusCard(),
            const SizedBox(height: 28),
            const Text(
              "Main Services",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: width < 700 ? 2 : 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.95,
              children: [
                _buildServiceCard(
                  context,
                  title: "Secure Report",
                  subtitle:
                      "Create and submit protected incident reports safely.",
                  icon: Icons.assignment_outlined,
                  color: Colors.orange,
                  onTap: () => Navigator.pushNamed(context, '/report'),
                ),
                _buildServiceCard(
                  context,
                  title: "Emergency SOS",
                  subtitle:
                      "Send an urgent alert with your saved contact details.",
                  icon: Icons.emergency_outlined,
                  color: Colors.red,
                  onTap: () => Navigator.pushNamed(context, '/sos'),
                ),
                _buildServiceCard(
                  context,
                  title: "Help Centers",
                  subtitle: "Locate medical, legal, and support institutions.",
                  icon: Icons.location_on_outlined,
                  color: Colors.blue,
                  onTap: () => Navigator.pushNamed(context, '/map'),
                ),
                _buildServiceCard(
                  context,
                  title: "Privacy Settings",
                  subtitle: "Manage contacts, protection, and app preferences.",
                  icon: Icons.lock_outline,
                  color: Colors.teal,
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              "Support Services",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),
            const SizedBox(height: 14),
            _buildSupportCard(
              icon: Icons.local_hospital_outlined,
              color: Colors.red,
              title: "Medical Assistance",
              content:
                  "Access emergency healthcare services, treatment centers, and referral hospitals for urgent physical support and recovery.",
            ),
            const SizedBox(height: 14),
            _buildSupportCard(
              icon: Icons.gavel_outlined,
              color: Colors.indigo,
              title: "Legal Protection",
              content:
                  "Receive legal guidance, reporting assistance, and support for protection procedures from responsible authorities.",
            ),
            const SizedBox(height: 14),
            _buildSupportCard(
              icon: Icons.favorite_outline,
              color: Colors.purple,
              title: "Psychological Counseling",
              content:
                  "Emotional recovery and trauma support services are available through counseling and survivor assistance programs.",
            ),
            const SizedBox(height: 14),
            _buildSupportCard(
              icon: Icons.home_work_outlined,
              color: Colors.green,
              title: "Shelter & Safe Housing",
              content:
                  "Temporary safe shelters and protected housing support can help survivors remain secure during emergency situations.",
            ),
            const SizedBox(height: 32),
            const Text(
              "Safety Guidance",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),
            const SizedBox(height: 14),
            _buildSafetyTip(
              icon: Icons.phone_android_outlined,
              title: "Keep Your Phone Accessible",
              text:
                  "Maintain battery charge and mobile access for emergency communication and SOS activation.",
            ),
            const SizedBox(height: 12),
            _buildSafetyTip(
              icon: Icons.location_searching_outlined,
              title: "Enable Location Services",
              text:
                  "Location access improves emergency response and helps identify nearby support centers quickly.",
            ),
            const SizedBox(height: 12),
            _buildSafetyTip(
              icon: Icons.people_outline,
              title: "Share Trusted Contacts",
              text:
                  "Store reliable emergency contacts inside the application settings for rapid communication.",
            ),
            const SizedBox(height: 28),
            _buildEmergencyNotice(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            primaryBrown,
            darkBrown,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Safe Space",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "A secure environment designed to support emergency response, protected reporting, and survivor assistance services.",
            style: TextStyle(
              color: Colors.white70,
              height: 1.6,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 18,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  "Protected Session Active",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.red.shade100,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.red.shade700,
            size: 30,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Emergency Access",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red.shade900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Use the SOS feature immediately if you are in danger or need urgent support assistance.",
                  style: TextStyle(
                    color: Colors.red.shade800,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.12),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: darkBrown,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  height: 1.4,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCard({
    required IconData icon,
    required Color color,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: darkBrown,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(
                    height: 1.5,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTip({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: primaryBrown,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkBrown,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: TextStyle(
                    height: 1.5,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFFFF3E0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.deepOrange,
              ),
              SizedBox(width: 10),
              Text(
                "Important Notice",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "This application is designed to support emergency response and survivor assistance workflows. For immediate danger situations, prioritize emergency SOS activation and contact trusted authorities.",
            style: TextStyle(
              color: Colors.grey.shade800,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
