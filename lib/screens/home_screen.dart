import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gbv_support_app/features/dashboard/presentation/home_tab.dart';
import '../services/sos_service.dart';
import 'home_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final SOSService _sosService = SOSService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String emergencyContact = "+251912345678";
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadEmergencyContact();
  }

  Future<void> _loadEmergencyContact() async {
    final saved = await _storage.read(key: 'emergency_contact_1');

    if (saved != null && saved.isNotEmpty) {
      setState(() {
        emergencyContact = saved;
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _sendSOS() async {
    setState(() => _isSending = true);

    try {
      await _sosService.sendEmergencySOS(emergencyContact);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("Emergency sent to $emergencyContact"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to send emergency alert"),
        ),
      );
    }

    if (mounted) {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildSOSBoard(),
      HomeTab(onSwitchTab: (i) {}),
    ];

    return WillPopScope(
      onWillPop: () async {
        // ✅ FIX: Prevent returning to login
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }

        // Optional: prevent app exit or allow exit
        return false; // change to true if you want exit behavior
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F5F2),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF5D4037),
          title: Text(
            _currentIndex == 0 ? "Emergency Center" : "Support Resources",
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        drawer: _buildNavigationDrawer(),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: pages[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.emergency_rounded),
              label: "Emergency",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: "Resources",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSOSBoard() {
    return Center(
      child: GestureDetector(
        onLongPress: _isSending ? null : _sendSOS,
        child: Container(
          height: 200,
          width: 200,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: Center(
            child: _isSending
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "SOS",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationDrawer() {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Text("Menu"),
          ),

          ListTile(
            title: const Text("Reports"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/report');
            },
          ),

          ListTile(
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),

          const Spacer(),

          // 🔥 FIXED LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false, // ❌ clears entire stack
              );
            },
          ),
        ],
      ),
    );
  }
}
