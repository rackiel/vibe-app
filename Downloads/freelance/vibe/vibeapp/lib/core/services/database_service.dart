import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_progress.dart';
import '../models/achievement.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'vibe_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // User Progress Table
    await db.execute('''
      CREATE TABLE user_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        activity_type TEXT NOT NULL,
        activity_id TEXT NOT NULL,
        progress INTEGER NOT NULL,
        time_spent INTEGER NOT NULL,
        completed_at INTEGER NOT NULL,
        metadata TEXT,
        UNIQUE(user_id, activity_type, activity_id)
      )
    ''');

    // Achievements Table
    await db.execute('''
      CREATE TABLE achievements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        icon_path TEXT NOT NULL,
        category TEXT NOT NULL,
        points INTEGER NOT NULL,
        is_unlocked INTEGER NOT NULL DEFAULT 0,
        unlocked_at INTEGER,
        requirements TEXT
      )
    ''');

    // User Settings Table
    await db.execute('''
      CREATE TABLE user_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        setting_key TEXT NOT NULL,
        setting_value TEXT NOT NULL,
        UNIQUE(user_id, setting_key)
      )
    ''');

    // Insert default achievements
    await _insertDefaultAchievements(db);
  }

  Future<void> _insertDefaultAchievements(Database db) async {
    final achievements = [
      {
        'title': 'First Steps',
        'description': 'Complete your first gesture training',
        'icon_path': 'assets/icons/first_steps.png',
        'category': 'gesture',
        'points': 10,
        'requirements': '{"gesture_count": 1}',
      },
      {
        'title': 'Game Master',
        'description': 'Complete 5 games',
        'icon_path': 'assets/icons/game_master.png',
        'category': 'game',
        'points': 50,
        'requirements': '{"game_count": 5}',
      },
      {
        'title': 'Story Explorer',
        'description': 'Read 3 stories',
        'icon_path': 'assets/icons/story_explorer.png',
        'category': 'story',
        'points': 30,
        'requirements': '{"story_count": 3}',
      },
      {
        'title': 'Dedicated Learner',
        'description': 'Spend 1 hour learning',
        'icon_path': 'assets/icons/dedicated.png',
        'category': 'time',
        'points': 100,
        'requirements': '{"total_time": 3600}',
      },
      {
        'title': 'Streak Master',
        'description': 'Use the app for 7 consecutive days',
        'icon_path': 'assets/icons/streak.png',
        'category': 'streak',
        'points': 200,
        'requirements': '{"consecutive_days": 7}',
      },
    ];

    for (final achievement in achievements) {
      await db.insert('achievements', achievement);
    }
  }

  // User Progress Methods
  Future<int> insertUserProgress(UserProgress progress) async {
    final db = await database;
    return await db.insert(
      'user_progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<UserProgress>> getUserProgress(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_progress',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'completed_at DESC',
    );
    return List.generate(maps.length, (i) => UserProgress.fromMap(maps[i]));
  }

  Future<UserProgress?> getUserProgressByActivity(
    String userId,
    String activityType,
    String activityId,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_progress',
      where: 'user_id = ? AND activity_type = ? AND activity_id = ?',
      whereArgs: [userId, activityType, activityId],
    );
    if (maps.isNotEmpty) {
      return UserProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUserProgress(UserProgress progress) async {
    final db = await database;
    return await db.update(
      'user_progress',
      progress.toMap(),
      where: 'id = ?',
      whereArgs: [progress.id],
    );
  }

  // Achievement Methods
  Future<List<Achievement>> getAllAchievements() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('achievements');
    return List.generate(maps.length, (i) => Achievement.fromMap(maps[i]));
  }

  Future<List<Achievement>> getUnlockedAchievements() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'achievements',
      where: 'is_unlocked = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Achievement.fromMap(maps[i]));
  }

  Future<int> unlockAchievement(int achievementId) async {
    final db = await database;
    return await db.update(
      'achievements',
      {
        'is_unlocked': 1,
        'unlocked_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [achievementId],
    );
  }

  // User Settings Methods
  Future<void> setUserSetting(String userId, String key, String value) async {
    final db = await database;
    await db.insert(
      'user_settings',
      {
        'user_id': userId,
        'setting_key': key,
        'setting_value': value,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getUserSetting(String userId, String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_settings',
      where: 'user_id = ? AND setting_key = ?',
      whereArgs: [userId, key],
    );
    if (maps.isNotEmpty) {
      return maps.first['setting_value'];
    }
    return null;
  }

  // Statistics Methods
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final db = await database;
    
    // Total time spent
    final timeResult = await db.rawQuery(
      'SELECT SUM(time_spent) as total_time FROM user_progress WHERE user_id = ?',
      [userId],
    );
    final totalTime = timeResult.first['total_time'] as int? ?? 0;

    // Activities completed
    final activitiesResult = await db.rawQuery(
      'SELECT activity_type, COUNT(*) as count FROM user_progress WHERE user_id = ? GROUP BY activity_type',
      [userId],
    );
    final activities = Map<String, int>.fromEntries(
      activitiesResult.map((e) => MapEntry(e['activity_type'] as String, e['count'] as int)),
    );

    // Achievements unlocked
    final achievementsResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM achievements WHERE is_unlocked = 1',
    );
    final achievementsUnlocked = achievementsResult.first['count'] as int? ?? 0;

    return {
      'totalTime': totalTime,
      'activities': activities,
      'achievementsUnlocked': achievementsUnlocked,
    };
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
