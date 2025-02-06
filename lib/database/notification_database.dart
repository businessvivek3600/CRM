import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotificationDatabase {
  static final NotificationDatabase instance = NotificationDatabase._init();
  static Database? _database;

  NotificationDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notifications.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT,
        image TEXT,
        payload TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertNotification(Map<String, dynamic> notification) async {
    final db = await instance.database;
    return await db.insert('notifications', notification);
  }

  Future<List<Map<String, dynamic>>> getAllNotifications() async {
    final db = await instance.database;
    return await db.query('notifications', orderBy: 'timestamp DESC');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
