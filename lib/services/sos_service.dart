/* 
 * SOS Service for GBV Support App
 * Handles GPS acquisition and Emergency SMS 
 */
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';

class SOSService {
  final Telephony telephony = Telephony.instance;

  Future<void> sendEmergencySOS(String contactNumber) async {
    // 1. Get current location (Samsung A24 GPS)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String message = "EMERGENCY SOS: I need help. My location: "
        "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

    // 2. Send SMS via GSM network
    await telephony.sendSms(
      to: contactNumber,
      message: message,
    );
  }
}
