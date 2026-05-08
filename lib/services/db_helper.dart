/* 
 * SQLite Helper for local data persistence
 * Part of the Data Acquisition layer 
 */
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  _initDB() async {
    String path = join(await getDatabasesPath(), 'gbv_reports.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE reports (
          id TEXT PRIMARY KEY,
          description TEXT,
          timestamp TEXT,
          status TEXT -- 'pending' or 'synced'
        )
      ''');
    });
  }
}
