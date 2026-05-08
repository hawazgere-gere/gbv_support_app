/* 
 * ─────────────────────────────────────────────────────────────
 * 🛡️ SETTINGS & PRIVACY CENTER
 * -------------------------------------------------------------
 * PURPOSE:
 * Manages user privacy, emergency contacts, security,
 * discreet protection features, local storage settings,
 * and application personalization.
 *
 * FEATURES:
 * ✔ Secure local storage
 * ✔ Emergency contact management
 * ✔ Discreet mode
 * ✔ Panic wipe protection
 * ✔ Responsive professional UI
 * ✔ Clean modular architecture
 * ✔ Privacy-centered design
 * ✔ Improved visual hierarchy
 * ✔ Better spacing and readability
 * ✔ Expanded support functionality
 * ─────────────────────────────────────────────────────────────
 */

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ─────────────────────────────────────────────────────────────
  // 🔐 SECURE STORAGE
  // ─────────────────────────────────────────────────────────────
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // ─────────────────────────────────────────────────────────────
  // 📝 CONTROLLERS
  // ─────────────────────────────────────────────────────────────
  final TextEditingController _contactController = TextEditingController();

  final TextEditingController _secondaryContactController =
      TextEditingController();

  // ─────────────────────────────────────────────────────────────
  // ⚙️ SETTINGS STATE
  // ─────────────────────────────────────────────────────────────
  bool _isDiscreetMode = false;
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkProtectionMode = false;

  // Theme Colors
  static const Color primaryBrown = Color(0xFF8D6E63);
  static const Color darkBrown = Color(0xFF5D4037);

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _contactController.dispose();
    _secondaryContactController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // 📥 LOAD SAVED DATA
  // ─────────────────────────────────────────────────────────────
  Future<void> _loadSavedData() async {
    String? primary = await _storage.read(key: 'emergency_contact_1');

    String? secondary = await _storage.read(key: 'emergency_contact_2');

    if (mounted) {
      setState(() {
        _contactController.text = primary ?? "";
        _secondaryContactController.text = secondary ?? "";
      });
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 💾 SAVE CONTACTS
  // ─────────────────────────────────────────────────────────────
  Future<void> _saveContacts() async {
    await _storage.write(
      key: 'emergency_contact_1',
      value: _contactController.text.trim(),
    );

    await _storage.write(
      key: 'emergency_contact_2',
      value: _secondaryContactController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          content: const Text(
            "Emergency contacts updated successfully.",
          ),
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 🏗️ MAIN UI
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F3),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryBrown,
        foregroundColor: Colors.white,
        title: const Text(
          "Settings & Privacy",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            // ───────────────── HEADER CARD ─────────────────
            _buildProfileBanner(),

            const SizedBox(height: 28),

            // ───────────────── SECURITY ─────────────────
            _buildSectionHeader(
              "SECURITY & PRIVACY",
              Icons.security_rounded,
            ),

            const SizedBox(height: 12),

            _buildSecurityCard(),

            const SizedBox(height: 28),

            // ───────────────── EMERGENCY CONTACTS ─────────────────
            _buildSectionHeader(
              "EMERGENCY CONTACTS",
              Icons.contact_phone_rounded,
            ),

            const SizedBox(height: 12),

            _buildEmergencyContactsCard(),

            const SizedBox(height: 28),

            // ───────────────── APP PREFERENCES ─────────────────
            _buildSectionHeader(
              "APPLICATION SETTINGS",
              Icons.settings_rounded,
            ),

            const SizedBox(height: 12),

            _buildPreferencesCard(),

            const SizedBox(height: 28),

            // ───────────────── HELP & SUPPORT ─────────────────
            _buildSectionHeader(
              "HELP & SUPPORT",
              Icons.support_agent_rounded,
            ),

            const SizedBox(height: 12),

            _buildSupportCard(),

            const SizedBox(height: 28),

            // ───────────────── DANGER ZONE ─────────────────
            _buildSectionHeader(
              "DANGER ZONE",
              Icons.warning_amber_rounded,
            ),

            const SizedBox(height: 12),

            _buildDangerZone(),

            const SizedBox(height: 30),

            // ───────────────── APP VERSION ─────────────────
            const Center(
              child: Text(
                "GBV Support App • Version 1.0.0",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 👤 PROFILE HEADER
  // ─────────────────────────────────────────────────────────────
  Widget _buildProfileBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryBrown,
            Colors.brown.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.shield_outlined,
              color: primaryBrown,
              size: 32,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Protected Session",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Your information is encrypted and securely stored.",
                  style: TextStyle(
                    color: Colors.white70,
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

  // ─────────────────────────────────────────────────────────────
  // 🏷️ SECTION HEADER
  // ─────────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: primaryBrown),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: primaryBrown,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 🔐 SECURITY CARD
  // ─────────────────────────────────────────────────────────────
  Widget _buildSecurityCard() {
    return _buildCardContainer(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.lock_reset_rounded,
              color: primaryBrown,
            ),
            title: const Text("Change Secret PIN"),
            subtitle: const Text(
              "Update your secure access PIN",
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, '/register');
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            value: _isDiscreetMode,
            activeColor: primaryBrown,
            secondary: const Icon(Icons.visibility_off_rounded),
            title: const Text("Discreet Mode"),
            subtitle: const Text(
              "Hide sensitive content quickly",
            ),
            onChanged: (value) {
              setState(() => _isDiscreetMode = value);
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            value: _darkProtectionMode,
            activeColor: primaryBrown,
            secondary: const Icon(Icons.dark_mode_rounded),
            title: const Text("Protection Theme"),
            subtitle: const Text(
              "Enable calm low-visibility appearance",
            ),
            onChanged: (value) {
              setState(() => _darkProtectionMode = value);
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ☎️ EMERGENCY CONTACTS
  // ─────────────────────────────────────────────────────────────
  Widget _buildEmergencyContactsCard() {
    return _buildCardContainer(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: _contactController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration(
                "Primary SOS Number",
                Icons.phone_rounded,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _secondaryContactController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration(
                "Secondary Emergency Contact",
                Icons.contact_phone_rounded,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBrown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _saveContacts,
                icon: const Icon(Icons.save_rounded),
                label: const Text(
                  "Save Contacts",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ⚙️ APP PREFERENCES
  // ─────────────────────────────────────────────────────────────
  Widget _buildPreferencesCard() {
    return _buildCardContainer(
      child: Column(
        children: [
          SwitchListTile(
            value: _notificationsEnabled,
            activeColor: primaryBrown,
            secondary: const Icon(Icons.notifications_active_rounded),
            title: const Text("Emergency Notifications"),
            subtitle: const Text(
              "Receive alerts and updates",
            ),
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            value: _locationEnabled,
            activeColor: primaryBrown,
            secondary: const Icon(Icons.location_on_rounded),
            title: const Text("Location Sharing"),
            subtitle: const Text(
              "Share location during SOS emergencies",
            ),
            onChanged: (value) {
              setState(() => _locationEnabled = value);
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 🆘 SUPPORT CARD
  // ─────────────────────────────────────────────────────────────
  Widget _buildSupportCard() {
    return _buildCardContainer(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.help_outline_rounded),
            title: const Text("Help Center"),
            subtitle: const Text(
              "Learn how to use the application",
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showInfoDialog(
                "Help Center",
                "This application helps users report GBV incidents, trigger SOS emergencies, access support services, and manage emergency safety settings.",
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.phone_in_talk_rounded),
            title: const Text("Emergency Hotline"),
            subtitle: const Text(
              "24/7 support service",
            ),
            trailing: const Text(
              "952",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryBrown,
              ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text("About Application"),
            subtitle: const Text(
              "Version and platform information",
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showInfoDialog(
                "About",
                "GBV Support App Version 1.0.0\n\nDesigned to provide emergency protection, support, and safety tools for vulnerable individuals.",
              );
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 🚨 DANGER ZONE
  // ─────────────────────────────────────────────────────────────
  Widget _buildDangerZone() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.red.shade300,
        ),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.delete_forever_rounded,
          color: Colors.red,
        ),
        title: const Text(
          "Wipe All Data",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          "Delete contacts, PIN, and secure data",
        ),
        onTap: _showWipeConfirmation,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 📦 CARD CONTAINER
  // ─────────────────────────────────────────────────────────────
  Widget _buildCardContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 📝 INPUT DECORATION
  // ─────────────────────────────────────────────────────────────
  InputDecoration _inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: primaryBrown,
          width: 1.8,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ℹ️ INFO DIALOG
  // ─────────────────────────────────────────────────────────────
  void _showInfoDialog(String title, String content) {
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
            color: darkBrown,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(height: 1.5),
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

  // ─────────────────────────────────────────────────────────────
  // ⚠️ WIPE CONFIRMATION
  // ─────────────────────────────────────────────────────────────
  void _showWipeConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          "Confirm Data Wipe",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "This action will permanently delete your saved contacts, PIN, and local secure data. This cannot be undone.",
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await _storage.deleteAll();

              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/welcome',
                  (route) => false,
                );
              }
            },
            child: const Text("WIPE DATA"),
          ),
        ],
      ),
    );
  }
}
