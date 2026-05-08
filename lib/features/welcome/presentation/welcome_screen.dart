import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFDF7F5), // Soft Peach
              Color(0xFFEFEBE9), // Warm Taupe
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // 🛡️ GUARDIAN EMBLEM
                _buildHeroIcon(),

                const SizedBox(height: 40),

                const Text(
                  'SAFE SPACE',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: Color(0xFF4E342E),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Support • Protection • Privacy',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1.5,
                    color: Colors.brown,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(flex: 1),

                const Text(
                  'Access your secure support network or trigger an immediate emergency alert.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 48),

                // 🔐 MAIN ENTRY POINT
                _buildPrimaryButton(
                  context,
                  label: 'SECURE LOGIN',
                  icon: Icons.lock_open_rounded,
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                ),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),

      // 🚨 EMERGENCY TRIGGER (Direct to SOS, not Dashboard)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          // ⚠️ IMPORTANT: Route to '/sos' instead of '/dashboard'
          onPressed: () => Navigator.pushNamed(context, '/sos'),
          backgroundColor: const Color(0xFFD32F2F),
          elevation: 10,
          label: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'EMERGENCY SOS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
          icon: const Icon(Icons.emergency_share, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHeroIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.brown.withOpacity(0.1), width: 2),
          ),
        ),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.shield_moon_outlined,
            size: 60,
            color: Color(0xFF8D6E63),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4E342E),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }
}
