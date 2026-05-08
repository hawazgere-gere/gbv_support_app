import 'report_model.dart';
import '../../../core/security/encryption_service.dart';

class ReportRepository {
  final EncryptionService _encryptionService = EncryptionService();

  // ✅ Mock local storage (In-memory for testing)
  final List<Map<String, dynamic>> _localReports = [];

  // 🛡️ Changed return type from Future<void> to Future<bool>
  Future<bool> submitReport(ReportModel report) async {
    try {
      // Stage 1: Security - Encrypting data before persistence (Ch. 2.11)
      final encrypted = _encryptionService.encryptText(report.details);

      final data = {
        ...report.toJson(),
        'details': encrypted,
        'synced': false // Track if this reached the Django backend
      };

      // Stage 2: Storage logic (Ch. 2.9)
      _localReports.add(data);

      // Log for the VS Code terminal (Debug Layer)
      print("🛡️ Repository: Report encrypted and saved: $data");

      // Return true to tell the Provider the process was successful
      return true;
    } catch (e) {
      print("❌ Repository Error: $e");
      return false;
    }
  }

  List<Map<String, dynamic>> getReports() {
    return _localReports;
  }
}
