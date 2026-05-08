import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    // Stage 1: Get the path for the database file (Chapter 2.7)[cite: 19]
    String path = join(await getDatabasesPath(), 'gbv_support.db');

    // Stage 2: Create the structured schema (Chapter 2.9)[cite: 20]
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE reports(id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT, timestamp TEXT, status TEXT)",
        );
      },
    );
  }

  // CRUD Operations as per Chapter 2.6 logic[cite: 19]
  Future<void> insertReport(Map<String, dynamic> report) async {
    final db = await database;
    await db.insert(
      'reports',
      report,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getOfflineReports() async {
    final db = await database;
    return await db.query('reports', where: "status = 'pending'");
  }
}
