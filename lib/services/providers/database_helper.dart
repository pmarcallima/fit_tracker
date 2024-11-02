
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import '../models/statistics.dart';
import '../models/friends.dart';
import '../models/friend_user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, 'fit_tracker.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        birthDate DATE,
        password TEXT NOT NULL,
        firstName TEXT,
        lastName TEXT,
        profilePicture BLOB
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS workouts (
        id INTEGER NOT NULL,
        name TEXT,
        workoutPicture BLOB,
        userId INTEGER NOT NULL,
        PRIMARY KEY (id, userId),
        FOREIGN KEY (userId) REFERENCES users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercises (
        id INTEGER NOT NULL,
        name TEXT,
        description TEXT,
        workoutId INTEGER NOT NULL,
        PRIMARY KEY (id, workoutId),
        FOREIGN KEY (workoutId) REFERENCES workouts(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS statistics (
        lastWorkout DATE,
        totalWorkouts INTEGER,
        currentStreak INTEGER,
        biggestStreak INTEGER,
        totalFriends INTEGER,
        userId INTEGER PRIMARY KEY,
        FOREIGN KEY (userId) REFERENCES users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS friends (
        idfriends INTEGER PRIMARY KEY
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS friends_has_users (
        friends_idfriends INTEGER NOT NULL,
        users_id INTEGER NOT NULL,
        PRIMARY KEY (friends_idfriends, users_id),
        FOREIGN KEY (friends_idfriends) REFERENCES friends(idfriends),
        FOREIGN KEY (users_id) REFERENCES users(id)
      );
    ''');
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  // Método para recuperar todos os usuários
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        email: maps[i]['email'],
        birthDate: maps[i]['birthDate'],
        password: maps[i]['password'],
        firstName: maps[i]['firstName'],
        lastName: maps[i]['lastName'],
        profilePicture: maps[i]['profilePicture'],
      );
    });
  }

  Future<int> insertWorkout(Workout workout) async {
    final db = await database;
    return await db.insert('workouts', workout.toMap());
  }

  Future<int> insertExercise(Exercise exercise) async {
    final db = await database;
    return await db.insert('exercises', exercise.toMap());
  }

  Future<int> insertStatistic(Statistic statistic) async {
    final db = await database;
    return await db.insert('statistics', statistic.toMap());
  }

  Future<int> insertFriend(Friend friend) async {
    final db = await database;
    return await db.insert('friends', friend.toMap());
  }

  Future<int> insertFriendUser(FriendUser friendUser) async {
    final db = await database;
    return await db.insert('friends_has_users', friendUser.toMap());
  }
}
