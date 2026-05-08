import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/report_model.dart';
import '../data/report_repository.dart';
import '../../../core/security/database_service.dart'; // From Chapter 2.9

class ReportNotifier extends StateNotifier<bool> {
  final ReportRepository _repo;
  final DatabaseService _db = DatabaseService();

  ReportNotifier(this._repo) : super(false);

  Future<bool> submitReport(String type, String details) async {
    state = true; // Start loading (Chapter 2.2 placeholder)[cite: 15]

    final report = ReportModel(
      id: const Uuid().v4(),
      type: type,
      details: details,
      dateTime: DateTime.now(),
    );

    try {
      // 1. Attempt Distributed Communication (Chapter 4.1)
      final success = await _repo.submitReport(report);

      if (!success) {
        throw Exception("Server Unreachable");
      }

      return true;
    } catch (e) {
      // 2. Problem Solving: Save to SQLite if internet is unstable (Chapter 2.9)
      await _db.insertReport({
        'description': details,
        'timestamp': report.dateTime.toIso8601String(),
        'status': 'pending',
      });
      return false;
    } finally {
      state = false;
    }
  }
}

final reportProvider = StateNotifierProvider<ReportNotifier, bool>((ref) {
  return ReportNotifier(ReportRepository());
});
