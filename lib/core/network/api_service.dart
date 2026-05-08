import 'dart:convert';
import 'package:http/http.dart'
    as http; // Error 1: Ensure http is in pubspec.yaml
// Error 2: Fixed the relative import path based on your image structure
import '../security/encryption_service.dart';

class ApiService {
  // 🌐 Use your actual computer IP (e.g., 192.168.1.5) so the Samsung A24 connects
  static const String baseUrl = 'http://192.168.1.XX:8000/api';

  final EncryptionService _encryption = EncryptionService();

  // POST method for submitting reports (Chapter 4.1.2)
  Future<bool> submitReport(Map<String, dynamic> reportData) async {
    final url = Uri.parse('$baseUrl/reports/');

    try {
      // 🛡️ Stage 2: Data Encryption (Chapter 3.9)
      final encryptedBody = json.encode({
        'data': _encryption.encryptText(json.encode(reportData)),
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: encryptedBody,
      );

      // 📝 Stage 3: Lifecycle Response Handling (Chapter 1.8)
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      // Problem Solving: Return false to trigger SQLite fallback
      return false;
    }
  }
}
