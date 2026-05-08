import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart'; // Ch. 1.6 Service Integration

class SosRepository {
  final Telephony _telephony = Telephony.instance;

  Future<Position> getLocation() async {
    // Stage: Data Acquisition (Chapter 5.2.3 Sensors)
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high, // Accurate for MIT standards
    );
  }

  Future<void> sendSOS({
    required List<String> guardianContacts,
    required Position position,
  }) async {
    // Constructing the Google Maps link for the Distributed System (Ch. 4.1)
    String mapUrl =
        "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
    String message = "EMERGENCY: I need help. My current location: $mapUrl";

    for (String contact in guardianContacts) {
      // Utilizing system services for emergency communication[cite: 11]
      await _telephony.sendSms(to: contact, message: message);
    }
  }
}
