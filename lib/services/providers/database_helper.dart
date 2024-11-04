import 'dart:async';
import 'dart:io';
import 'package:fit_tracker/utils/global_context.dart';
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
    print("Database path: $path");
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
      id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Define id as auto-increment
      name TEXT,
      workoutPicture BLOB,
      userId INTEGER NOT NULL,
      FOREIGN KEY (userId) REFERENCES users(id)
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS exercises (
      id INTEGER NOT NULL,
      name TEXT,
      description TEXT,
      image BLOB,
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
  
  // Inserindo o usuário
  int userId = await db.insert('users', user.toMap());

  // Criando e inserindo as estatísticas do usuário
  Statistic statistic = Statistic(
    lastWorkout: DateTime(1900), // Ou uma data específica se necessário
    totalWorkouts: 0,
    currentStreak: 0,
    biggestStreak: 0,
    totalFriends: 0,
    userId: userId, // ID do usuário recém inserido
  );

  await insertStatistics(statistic); // Inserindo as estatísticas

  return userId; // Retorne o ID do usuário inserido
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

  Future<User?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return User(
      id: maps[0]['id'],
      email: maps[0]['email'],
      birthDate: maps[0]['birthDate'],
      password: maps[0]['password'],
      firstName: maps[0]['firstName'],
      lastName: maps[0]['lastName'],
      profilePicture: maps[0]['profilePicture'],
    );
  }
 Future<Statistic> getStatisticsByUserId(int userId) async {
    final db = await database; // Obtenha sua instância de banco de dados

    // Consulta as estatísticas com base no ID do usuário
    final statsMaps = await db.query(
      'statistics',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (statsMaps.isNotEmpty) {
      return Statistic.fromMap(statsMaps.first);
    } else {
      throw Exception('Estatísticas não encontradas para o usuário ID $userId');
    }
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) {
      return null;
    }

    return User(
      id: maps[0]['id'],
      email: maps[0]['email'],
      birthDate: maps[0]['birthDate'],
      password: maps[0]['password'],
      firstName: maps[0]['firstName'],
      lastName: maps[0]['lastName'],
      profilePicture: maps[0]['profilePicture'],
    );
  }

  Future<int> insertWorkout(Workout workout) async {
    final db = await database;
    return await db.insert('workouts', workout.toMap());
  }

  // Método para recuperar todos os treinos de um usuário específico
  Future<List<Workout>> getAllWorkoutsByUserId(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workouts',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Workout(
        id: maps[i]['id'],
        name: maps[i]['name'],
        workoutPicture: maps[i]['workoutPicture'],
        userId: maps[i]['userId'],
      );
    });
  }

  // Método para recuperar todos os exercícios de um treino específico
  Future<List<Exercise>> getAllExercisesByWorkoutId(int workoutId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercises',
      where: 'workoutId = ?',
      whereArgs: [workoutId],
    );

    return List.generate(maps.length, (i) {
      return Exercise(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        workoutId: maps[i]['workoutId'],
      );
    });
  }

  Future<int> deleteWorkout(int workoutId, int userId) async {
    final db = await database;
    return await db.delete(
      'workouts',
      where: 'id = ? AND userId = ?',
      whereArgs: [workoutId, userId],
    );
  }

  Future<int> updateWorkout(Workout workout) async {
    final db = await database;

    return await db.update(
      'workouts',
      workout.toMap(), // Supondo que exista um método para converter o Workout em um Map
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  Future<int> insertExercise(Exercise exercise) async {
    final db = await database;
    return await db.insert('exercises', exercise.toMap());
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await database;
    return await db.update(
      'exercises',
      exercise.toMap(), // Converte o exercício atualizado para um mapa
      where: 'id = ? AND workoutId = ?', // Condição para identificar o exercício
      whereArgs: [exercise.id, exercise.workoutId], // Argumentos para a condição
    );
  }

  Future<int> deleteExercise(int exerciseId, int workoutId) async {
    final db = await database;
    return await db.delete(
      'exercises',
      where: 'id = ? AND workoutId = ?',
      whereArgs: [exerciseId, workoutId],
    );
  }

  Future<int> insertStatistics(Statistic statistic) async {
    final db = await database;
    return await db.insert('statistics', statistic.toMap());
  }

  Future<int> insertFriend(Friend friend) async {
    final db = await database;
    return await db.insert('friends', friend.toMap());
  }

Future<void> addAllFriendsExceptLoggedUser() async {
  final db = await database;
  final loggedUserId = GlobalContext.userId; // Supondo que userId seja um int e não nullable.

  if (loggedUserId != null) {
    // 1. Buscar todos os usuários do banco de dados
    final List<Map<String, dynamic>> allUsers = await db.rawQuery('SELECT * FROM users');

    for (var user in allUsers) {
      int friendUserId = user['id']; // Supondo que 'id' é o campo que identifica o usuário

      // 2. Filtrar o usuário logado
      if (friendUserId != loggedUserId) {
        FriendUser friendUser = FriendUser(
          friendId: friendUserId,
          userId: loggedUserId,
        );

        print('User ID: $loggedUserId');
        print('Friend User ID: $friendUserId');

        // Verificar se o amigo já foi adicionado
        final existingFriend = await db.rawQuery('''
          SELECT * FROM friends_has_users
          WHERE friends_idfriends = ? AND users_id = ?
        ''', [friendUserId, loggedUserId]);

        // Imprimir o resultado da consulta
        print('Existing Friend: $existingFriend');

        if (existingFriend.isEmpty) {
          // Inserindo o relacionamento na tabela `friends_has_users`
          await insertFriendUser(friendUser);
          print('Added friend: $friendUserId');

          // Atualizando as estatísticas
          Statistic s = await getStatisticsByUserId(loggedUserId);

          Statistic updatedStatistic = Statistic(
            lastWorkout: s.lastWorkout,
            totalWorkouts: s.totalWorkouts,
            currentStreak: s.currentStreak,
            biggestStreak: s.biggestStreak,
            totalFriends: s.totalFriends + 1, // Incrementa totalFriends
            userId: s.userId,
          );

          // Salve as estatísticas atualizadas, se necessário
          await updateStatistics(updatedStatistic); // Certifique-se de ter essa função implementada
        }
      }
    }
  } else {
    print('User not logged in.');
  }
}
Future<void> addFriend(int friendUserId) async {
  final db = await database;
  final loggedUserId = GlobalContext.userId; // Supondo que userId seja um int e não nullable.

  if (loggedUserId != null) {
    FriendUser friendUser = FriendUser(
      friendId: friendUserId,
      userId: loggedUserId,
    );

print('User ID: ${loggedUserId}');
print('User ID: ${friendUserId}');
    // Verificar se o amigo já foi adicionado
    final existingFriend = await db.rawQuery('''
      SELECT * FROM friends_has_users
      WHERE friends_idfriends = ? AND users_id = ?
    ''', [friendUserId, loggedUserId]);
// Imprimir o resultado da consulta
    print('Existing Friend: $existingFriend');

    if (existingFriend.isEmpty) {
      // Inserindo o amigo na tabela `friends`

      // Inserindo o relacionamento na tabela `friends_has_users`
      await insertFriendUser(friendUser);
      Statistic s = await getStatisticsByUserId(loggedUserId);

Statistic updatedStatistic = Statistic(
  lastWorkout: s.lastWorkout,
  totalWorkouts: s.totalWorkouts,
  currentStreak: s.currentStreak,
  biggestStreak: s.biggestStreak,
  totalFriends: s.totalFriends + 1, // Incrementa totalFriends
  userId: s.userId,
);

await updateStatistics(updatedStatistic);

    } else {
      print("Amigo já adicionado.");
    }
  } else {
    print("Erro: ID do usuário logado não encontrado.");
  }
}


  Future<int> insertFriendUser(FriendUser friendUser) async {
    final db = await database;
    return await db.insert('friends_has_users', friendUser.toMap());
  }
Future<List<Friends>> getFriendList(User user) async {
  final db = await database;
  addAllFriendsExceptLoggedUser();
  final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT u.id, u.firstName AS name, s.currentStreak,
           CASE WHEN s.currentStreak > 0 THEN 1 ELSE 0 END AS hasStreak
    FROM friends_has_users fhu
    INNER JOIN users u ON u.id = fhu.friends_idfriends
    INNER JOIN statistics s ON s.userId = u.id
    WHERE fhu.users_id = ?
  ''', [user.id]);

  List<Friends> amigos = List.generate(maps.length, (i) {
    return Friends(
      id: maps[i]['id'],  // Usando o ID do usuário real
      name: maps[i]['name'],
      streakDays: maps[i]['currentStreak'],
      hasStreak: maps[i]['hasStreak'] == 1,
    );
  });

  // Consulta para unir friends_has_users com users e statistics
  // Imprime os amigos
  for (var friend in amigos) {
    print('ID: ${friend.id}, Nome: ${friend.name}, Streak: ${friend.streakDays}, Tem streak: ${friend.hasStreak}');
  }

  return amigos; // Retorna a lista de amigos
}
  Future<int> updateUser(User user) async {
    final db = await database; // Obtém a instância do banco de dados

    // Atualiza o usuário na tabela
    return await db.update(
      'users', // Nome da tabela
      user.toMap(), // Método para converter o usuário em um mapa
      where: 'id = ?', // Condição para identificar qual usuário atualizar
      whereArgs: [user.id], // Argumentos para a condição
    );
  }

Future<int> updateStatistics(Statistic statistic) async {
  final db = await database;

  // Usando o método update para modificar as estatísticas do usuário
  return await db.update(
    'statistics',
    statistic.toMap(),
    where: 'userId = ?',
    whereArgs: [statistic.userId],
  );
}


}
