import 'dart:convert';
import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finote_local.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT UNIQUE NOT NULL,
        profile_image TEXT,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  /// Menyimpan gambar profil ke database
  /// [userId] - Firebase UID pengguna
  /// [imageBytes] - Bytes gambar yang akan disimpan
  Future<void> saveProfileImage(String userId, Uint8List imageBytes) async {
    final db = await database;
    final base64Image = base64Encode(imageBytes);
    final now = DateTime.now().toIso8601String();

    await db.insert(
      'user_profile',
      {
        'user_id': userId,
        'profile_image': base64Image,
        'updated_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Mengambil gambar profil dari database
  /// [userId] - Firebase UID pengguna
  /// Returns: Uint8List jika ada, null jika tidak ada
  Future<Uint8List?> getProfileImage(String userId) async {
    final db = await database;

    final result = await db.query(
      'user_profile',
      columns: ['profile_image'],
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty && result.first['profile_image'] != null) {
      final base64Image = result.first['profile_image'] as String;
      return base64Decode(base64Image);
    }
    return null;
  }

  /// Menghapus gambar profil dari database
  /// [userId] - Firebase UID pengguna
  Future<void> deleteProfileImage(String userId) async {
    final db = await database;

    await db.delete(
      'user_profile',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Menutup database connection
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
