/* * 🛡️ GBV SUPPORT SYSTEM — CORE ARCHITECTURE (v2.0)
 * -------------------------------------------------------------
 * UPDATES: 
 * 1. High-Fidelity UX: Modernized Drawer & BottomNav styling.
 * 2. Navigation Firewall: Integrated PopScope with state recovery.
 * 3. Premium UI: Advanced iconography and custom theme depth.
 * -------------------------------------------------------------
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/welcome/presentation/welcome_screen.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/reporting/presentation/report_screen.dart';
import 'features/sos/presentation/sos_screen.dart';
import 'features/resources/presentation/map_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/dashboard/presentation/home_tab.dart';
import 'features/auth/presentation/auth_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafePath GBV Support',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto', // Professional, readable font
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8D6E63),
          primary: const Color(0xFF8D6E63),
          secondary: const Color(0xFF5D4037),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 2,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF5D4037),
        ),
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const MainDashboard(),
        '/report': (context) => const ReportScreen(),
        '/sos': (context) => const SosScreen(),
      },
    );
  }
}

class MainDashboard extends ConsumerStatefulWidget {
  const MainDashboard({super.key});
  @override
  ConsumerState<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends ConsumerState<MainDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeTab(onSwitchTab: (int index) {}),
    const ReportScreen(),
    const SosScreen(),
    const MapScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Instead of closing, return to the Home Tab for better safety
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        extendBody: true, // Allows content to flow behind the bottom bar
        appBar: AppBar(
          title: Text(
            _getAppBarTitle().toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () {}, // Future notification hub
            ),
          ],
        ),
        drawer: _buildAppDrawer(context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: IndexedStack(index: _currentIndex, children: _screens),
        ),

        // 🚨 MODERN SOS BUTTON (High Priority Action)
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AnimatedScale(
          scale: _currentIndex == 2 ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: FloatingActionButton.large(
            onPressed: () => setState(() => _currentIndex = 2),
            backgroundColor: Colors.redAccent.shade700,
            elevation: 8,
            shape: const CircleBorder(),
            child: const Icon(Icons.emergency_share_rounded,
                size: 36, color: Colors.white),
          ),
        ),

        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 70,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, Icons.dashboard_rounded, "Home"),
              _buildNavItem(1, Icons.assignment_turned_in_rounded, "Report"),
              const SizedBox(width: 40), // Space for SOS button
              _buildNavItem(3, Icons.map_rounded, "Map"),
              _buildNavItem(4, Icons.settings_suggest_rounded, "Settings"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF8D6E63) : Colors.grey.shade400,
            size: 28,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color:
                  isSelected ? const Color(0xFF8D6E63) : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    const titles = [
      "Dashboard",
      "File Report",
      "Emergency Hub",
      "Resource Map",
      "Settings"
    ];
    return titles[_currentIndex];
  }

  /* 
 * 🏗️ MODERNIZED PREMIUM DRAWER 
 * Clean UI, improved spacing, accessibility, and UX flow.
 */
  Widget _buildAppDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Column(
        children: [
          _buildDrawerHeader(),

          // MAIN CONTENT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                const SizedBox(height: 8),
                _drawerItem(
                  Icons.health_and_safety_outlined,
                  'Safety Protocol',
                  'Guidelines for personal protection',
                  () => _showSimpleDialog(
                    context,
                    "Safety Tips",
                    "• Keep your phone charged.\n"
                        "• Reports are encrypted automatically.\n"
                        "• Use SOS in immediate danger.",
                  ),
                ),
                _drawerItem(
                  Icons.folder_copy_outlined,
                  'Case Archives',
                  'View your submitted reports',
                  () => setState(() => _currentIndex = 1),
                ),
                _drawerItem(
                  Icons.balance_outlined,
                  'Legal Resources',
                  'Understand your rights & support laws',
                  () {
                    _showSimpleDialog(
                      context,
                      "Legal Resources",
                      "Access national and local GBV legal support information here.",
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Divider(thickness: 0.4),
                ),
                _drawerItem(
                  Icons.support_agent_outlined,
                  'Human Support',
                  'Connect with trained specialists',
                  () {
                    _showSimpleDialog(
                      context,
                      "Human Support",
                      "You can reach trained support staff through the help center or emergency contact channels.",
                    );
                  },
                ),
                _drawerItem(
                  Icons.verified_user_outlined,
                  'Security Audit',
                  'System status: Protected',
                  () => setState(() => _currentIndex = 4),
                ),
              ],
            ),
          ),

          // LOG OUT SECTION (FIXED)
          _buildLogoutSection(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF8D6E63),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(Icons.verified_user_rounded,
                size: 40, color: Color(0xFF8D6E63)),
          ),
          const SizedBox(height: 15),
          const Text("Verified User",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Text("End-to-End Encrypted Session",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _drawerItem(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: const Color(0xFF8D6E63).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: const Color(0xFF8D6E63)),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.grey)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _buildLogoutSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black12, width: 0.6),
        ),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.logout_rounded,
          color: Colors.redAccent,
        ),
        title: const Text(
          "Log out",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: const Text(
          "End current session securely",
          style: TextStyle(fontSize: 12),
        ),
        onTap: () {
          // secure logout logic
          ref.read(authProvider.notifier).logout();

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        },
      ),
    );
  }

  void _showSimpleDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFF8D6E63)),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Understood",
                  style: TextStyle(color: Color(0xFF8D6E63)))),
        ],
      ),
    );
  }
}
