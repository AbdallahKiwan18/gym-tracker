import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_seed.dart';
import '../../data/models/workout_log.dart';
import '../../data/models/workout_set.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gym_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Exercises table
    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        name_ar TEXT NOT NULL,
        category TEXT NOT NULL,
        muscle_group TEXT NOT NULL,
        muscle_group_ar TEXT NOT NULL,
        video_url TEXT NOT NULL,
        emoji TEXT NOT NULL
      )
    ''');

    // Workout logs table
    await db.execute('''
      CREATE TABLE workout_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exercise_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        week_of_month INTEGER NOT NULL,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL,
        FOREIGN KEY (exercise_id) REFERENCES exercises (id)
      )
    ''');

    // Workout sets table
    await db.execute('''
      CREATE TABLE workout_sets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        log_id INTEGER NOT NULL,
        set_number INTEGER NOT NULL,
        reps INTEGER NOT NULL,
        weight REAL NOT NULL,
        FOREIGN KEY (log_id) REFERENCES workout_logs (id) ON DELETE CASCADE
      )
    ''');

    // Seed exercises
    for (final exercise in ExerciseSeed.allExercises) {
      await db.insert('exercises', exercise.toMap());
    }
  }

  // ═══════════════════════════════════════════
  // EXERCISES
  // ═══════════════════════════════════════════

  Future<List<Exercise>> getAllExercises() async {
    final db = await database;
    final maps = await db.query('exercises');
    return maps.map((m) => Exercise.fromMap(m)).toList();
  }

  Future<List<Exercise>> getExercisesByCategory(String category) async {
    final db = await database;
    final maps = await db.query(
      'exercises',
      where: 'category = ?',
      whereArgs: [category],
    );
    return maps.map((m) => Exercise.fromMap(m)).toList();
  }

  Future<Exercise?> getExerciseById(int id) async {
    final db = await database;
    final maps = await db.query(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Exercise.fromMap(maps.first);
  }

  // ═══════════════════════════════════════════
  // WORKOUT LOGS
  // ═══════════════════════════════════════════

  Future<int> insertWorkoutLog(WorkoutLog log) async {
    final db = await database;
    final logId = await db.insert('workout_logs', log.toMap());

    // Insert sets
    for (final set in log.sets) {
      await db.insert('workout_sets', {
        'log_id': logId,
        'set_number': set.setNumber,
        'reps': set.reps,
        'weight': set.weight,
      });
    }

    return logId;
  }

  Future<void> updateWorkoutLog(WorkoutLog log) async {
    final db = await database;
    await db.update(
      'workout_logs',
      log.toMap(),
      where: 'id = ?',
      whereArgs: [log.id],
    );

    // Delete old sets and insert new ones
    await db.delete('workout_sets', where: 'log_id = ?', whereArgs: [log.id]);
    for (final set in log.sets) {
      await db.insert('workout_sets', {
        'log_id': log.id,
        'set_number': set.setNumber,
        'reps': set.reps,
        'weight': set.weight,
      });
    }
  }

  Future<void> deleteWorkoutLog(int logId) async {
    final db = await database;
    await db.delete('workout_sets', where: 'log_id = ?', whereArgs: [logId]);
    await db.delete('workout_logs', where: 'id = ?', whereArgs: [logId]);
  }

  Future<List<WorkoutLog>> getLogsForExercise(int exerciseId) async {
    final db = await database;
    final logMaps = await db.rawQuery('''
      SELECT wl.*, e.name as exercise_name, e.name_ar as exercise_name_ar, e.category as exercise_category
      FROM workout_logs wl
      JOIN exercises e ON wl.exercise_id = e.id
      WHERE wl.exercise_id = ?
      ORDER BY wl.date DESC
    ''', [exerciseId]);

    List<WorkoutLog> logs = [];
    for (final logMap in logMaps) {
      final setMaps = await db.query(
        'workout_sets',
        where: 'log_id = ?',
        whereArgs: [logMap['id']],
        orderBy: 'set_number ASC',
      );
      final sets = setMaps.map((m) => WorkoutSet.fromMap(m)).toList();
      logs.add(WorkoutLog.fromMap(logMap, sets: sets));
    }

    return logs;
  }

  Future<WorkoutLog?> getLastLogForExercise(int exerciseId) async {
    final db = await database;
    final logMaps = await db.rawQuery('''
      SELECT wl.*, e.name as exercise_name, e.name_ar as exercise_name_ar, e.category as exercise_category
      FROM workout_logs wl
      JOIN exercises e ON wl.exercise_id = e.id
      WHERE wl.exercise_id = ?
      ORDER BY wl.date DESC
      LIMIT 1
    ''', [exerciseId]);

    if (logMaps.isEmpty) return null;

    final setMaps = await db.query(
      'workout_sets',
      where: 'log_id = ?',
      whereArgs: [logMaps.first['id']],
      orderBy: 'set_number ASC',
    );
    final sets = setMaps.map((m) => WorkoutSet.fromMap(m)).toList();
    return WorkoutLog.fromMap(logMaps.first, sets: sets);
  }

  /// Get logs for a specific exercise in a specific month/year grouped by week
  Future<Map<int, WorkoutLog>> getMonthlyLogs(
    int exerciseId,
    int month,
    int year,
  ) async {
    final db = await database;
    final logMaps = await db.rawQuery('''
      SELECT wl.*, e.name as exercise_name, e.name_ar as exercise_name_ar, e.category as exercise_category
      FROM workout_logs wl
      JOIN exercises e ON wl.exercise_id = e.id
      WHERE wl.exercise_id = ? AND wl.month = ? AND wl.year = ?
      ORDER BY wl.week_of_month ASC
    ''', [exerciseId, month, year]);

    Map<int, WorkoutLog> weeklyLogs = {};
    for (final logMap in logMaps) {
      final setMaps = await db.query(
        'workout_sets',
        where: 'log_id = ?',
        whereArgs: [logMap['id']],
        orderBy: 'set_number ASC',
      );
      final sets = setMaps.map((m) => WorkoutSet.fromMap(m)).toList();
      final log = WorkoutLog.fromMap(logMap, sets: sets);
      weeklyLogs[log.weekOfMonth] = log;
    }

    return weeklyLogs;
  }

  /// Get the most recent log date for each category
  Future<Map<String, DateTime?>> getLastWorkoutPerCategory() async {
    final db = await database;
    final results = await db.rawQuery('''
      SELECT e.category, MAX(wl.date) as last_date
      FROM workout_logs wl
      JOIN exercises e ON wl.exercise_id = e.id
      GROUP BY e.category
    ''');

    Map<String, DateTime?> lastDates = {};
    for (final row in results) {
      final category = row['category'] as String;
      final dateStr = row['last_date'] as String?;
      lastDates[category] = dateStr != null ? DateTime.parse(dateStr) : null;
    }
    return lastDates;
  }

  /// Get total workouts count per category
  Future<Map<String, int>> getWorkoutCountPerCategory() async {
    final db = await database;
    final results = await db.rawQuery('''
      SELECT e.category, COUNT(DISTINCT wl.id) as count
      FROM workout_logs wl
      JOIN exercises e ON wl.exercise_id = e.id
      GROUP BY e.category
    ''');

    Map<String, int> counts = {};
    for (final row in results) {
      counts[row['category'] as String] = row['count'] as int;
    }
    return counts;
  }

  /// Get all exercises that have logs (for progress dropdown)
  Future<List<Exercise>> getExercisesWithLogs() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT DISTINCT e.*
      FROM exercises e
      JOIN workout_logs wl ON e.id = wl.exercise_id
      ORDER BY e.category, e.name
    ''');
    return maps.map((m) => Exercise.fromMap(m)).toList();
  }
}
