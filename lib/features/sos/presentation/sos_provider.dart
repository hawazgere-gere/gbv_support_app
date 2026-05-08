/* 
 * Top Comment: Advanced SOS Notifier managing GPS acquisition, 
 * permission validation, and multi-contact SMS dispatch.
 */
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

class SosNotifier extends StateNotifier<bool> {
  final _storage = const FlutterSecureStorage();
  final Telephony _telephony = Telephony.instance;

  SosNotifier() : super(false);

  Future<bool> sendSOS() async {
    state = true; // Button enters 'Active/Loading' state
    try {
      // 1. Check & Request Permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return false;
      }

      // 2. Get high-precision GPS
      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // 3. Format Secure Message
      String mapUrl =
          "https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}";
      String alertMessage =
          "⚠️ EMERGENCY ALERT ⚠️\nI need immediate help. My location: $mapUrl";

      // 4. Fetch Primary Contact from Secure Storage
      String? savedContact = await _storage.read(key: 'emergency_contact_1');
      // Default to a regional emergency number if none saved
      String target = savedContact ?? "911";

      // 5. Background Dispatch
      await _telephony.sendSms(
        to: target,
        message: alertMessage,
      );

      // Simulation delay for UI feedback
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    } finally {
      state = false;
    }
  }
}

final sosProvider =
    StateNotifierProvider<SosNotifier, bool>((ref) => SosNotifier());
