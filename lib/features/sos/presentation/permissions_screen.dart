/* Top Comment: Permission handling logic to ensure all emergency sensors are active */
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  // Map to track the status of each permission
  Map<Permission, bool> _statuses = {
    Permission.camera: false,
    Permission.microphone: false,
    Permission.sms: false,
    Permission.location: false,
    Permission.notification: false,
  };

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    for (var permission in _statuses.keys) {
      var status = await permission.status;
      setState(() => _statuses[permission] = status.isGranted);
    }
  }

  Future<void> _requestAll() async {
    // This triggers the system dialogs you saw in your screenshots
    Map<Permission, PermissionStatus> results = await [
      Permission.camera,
      Permission.microphone,
      Permission.sms,
      Permission.location,
      Permission.notification,
    ].request();

    _checkPermissions(); // Refresh UI

    if (results.values.every((status) => status.isGranted)) {
      if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      _showRequirementDialog();
    }
  }

  void _showRequirementDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Permission requirement"),
        content: const Text("In order to use the SOS features, all listed permissions must be enabled."),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Ok"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Permissions Status"), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: _statuses.keys.map((p) => SwitchListTile(
                title: Text(p.toString().split('.').last.toUpperCase()),
                subtitle: Text("Used to send alerts via ${p.toString().split('.').last}"),
                value: _statuses[p]!,
                activeColor: Colors.red,
                onChanged: (_) async {
                  await p.request();
                  _checkPermissions();
                },
              )).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: _requestAll,
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}