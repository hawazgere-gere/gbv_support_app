import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _position;
  bool _loading = false;

  String _locationStatus = "Location not detected";

  final List<Map<String, dynamic>> helpCenters = [
    {
      "name": "Ayder Referral Hospital",
      "distance": "2.4 km",
      "type": "Medical",
      "icon": Icons.local_hospital,
      "color": Colors.red,
      "description": "24/7 emergency medical support and survivor treatment."
    },
    {
      "name": "Mekelle One-Stop Center",
      "distance": "3.1 km",
      "type": "Legal",
      "icon": Icons.gavel,
      "color": Colors.blue,
      "description": "Legal protection, police coordination, and case support."
    },
    {
      "name": "Adigrat Safe House",
      "distance": "120 km",
      "type": "Shelter",
      "icon": Icons.home_work,
      "color": Colors.orange,
      "description": "Temporary secure shelter for vulnerable individuals."
    },
    {
      "name": "Women Counseling Center",
      "distance": "4.6 km",
      "type": "Counseling",
      "icon": Icons.favorite,
      "color": Colors.purple,
      "description": "Emotional recovery, therapy, and psychological support."
    },
  ];

  Future<void> _locate() async {
    setState(() {
      _loading = true;
      _locationStatus = "Detecting location...";
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _updateStatus("GPS is disabled");
        _show("Enable location services");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _updateStatus("Permission denied");
        _show("Location permission denied");
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _updateStatus("Permission blocked permanently");
        _show("Enable permission in settings");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _position = position;
        _loading = false;
        _locationStatus = "Lat: ${position.latitude.toStringAsFixed(4)} | "
            "Lng: ${position.longitude.toStringAsFixed(4)}";
      });

      _show("Location detected");
    } catch (e) {
      _updateStatus("Location failed");
      _show("Error detecting location");
    }
  }

  void _updateStatus(String text) {
    setState(() {
      _loading = false;
      _locationStatus = text;
    });
  }

  void _show(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  void _showCenter(Map<String, dynamic> center) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(center['name']),
        content: Text(
          "${center['description']}\n\n"
          "Type: ${center['type']}\n"
          "Distance: ${center['distance']}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3F1),

      // HEADER
      appBar: AppBar(
        title: const Text("Help Resources"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          _buildTitle(),
          const SizedBox(height: 8),
          Expanded(child: _buildList()),
          _buildEmergencyButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Color(0xFF8D6E63),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.public, color: Colors.white, size: 40),
          const SizedBox(height: 8),
          const Text(
            "Nearby Support Centers",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // LOCATION BOX (FIXED UX)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.my_location, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _locationStatus,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _locate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.brown,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: const Text("Locate"),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Available Centers",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    if (helpCenters.isEmpty) {
      return const Center(child: Text("No centers available"));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: helpCenters.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final c = helpCenters[i];

        return InkWell(
          onTap: () => _showCenter(c),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (c['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(c['icon'], color: c['color']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        c['type'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  c['distance'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmergencyButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              _show("Emergency feature activated soon");
            },
            icon: const Icon(Icons.call),
            label: const Text("Emergency Support"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(14),
            ),
          ),
        ),
      ),
    );
  }
}
git commit -m "Initial commit without large files"
git branch -M main
git remote add origin https://github.com/hawazgere-gere/gbv_support_app.git
git push -f origin main