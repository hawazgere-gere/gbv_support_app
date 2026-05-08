/* 
 * 📝 Textbook Ref: Chapter 1.8 (Lifecycle) & Chapter 3.7 (Permissions)
 * Main entry point: Initializes Riverpod, requests permissions, and manages
 * the Android/iOS Application Lifecycle.
 */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'core/utils/logger.dart';
import 'app.dart'; // Ensure this contains your "class MyApp extends StatelessWidget..."

void main() async {
  // 1. Required for native hardware interaction (Chapter 1.3)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. 🛡️ PERMISSION GUARD: Runtime permission model (Chapter 3.7)
  // Essential for the Samsung A24 to allow SMS and GPS
  await _requestInitialPermissions();

  // 3. Launch with ProviderScope for Riverpod and Lifecycle Manager
  runApp(
    const ProviderScope(
      child: MyAppLifecycleManager(),
    ),
  );
}

/// Requests necessary permissions for the system to function (Chapter 3.7)
Future<void> _requestInitialPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera, // Multimedia Input (Chapter 5.2.1)
    Permission.microphone, // Audio Capture (Chapter 5.2.2)
    Permission.locationWhenInUse, // GPS Data (Chapter 4.4)
    Permission.notification, // Mobile Services (Chapter 1.6)
    Permission.sms, // SOS Emergency Alert (Chapter 4.3)
  ].request();

  statuses.forEach((permission, status) {
    Logger.log('Permission $permission status: $status');
  });
}

/* 
 * 🔄 LIFECYCLE OBSERVER: This addresses Textbook Chapter 1.8
 * It handles transitions between Resumed, Inactive, and Paused states.
 */
class MyAppLifecycleManager extends StatefulWidget {
  const MyAppLifecycleManager({super.key});

  @override
  State<MyAppLifecycleManager> createState() => _MyAppLifecycleManagerState();
}

class _MyAppLifecycleManagerState extends State<MyAppLifecycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Registering the observer to listen to system events
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Unregistering to prevent memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Mapping Flutter states to Textbook Lifecycle states
    switch (state) {
      case AppLifecycleState.resumed:
        Logger.log('Lifecycle: RESUMED - App is active and visible.');
        break;
      case AppLifecycleState.inactive:
        Logger.log('Lifecycle: INACTIVE - Transitioning state.');
        break;
      case AppLifecycleState.paused:
        Logger.log('Lifecycle: PAUSED - Saving resources.');
        break;
      case AppLifecycleState.detached:
        Logger.log('Lifecycle: DETACHED - Cleaning up.');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This points to your MyApp class defined in app.dart
    return const MyApp();
  }
}
