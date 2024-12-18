
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_tracker/services/models/exercise.dart';
import 'package:fit_tracker/services/models/friends.dart';
import 'package:fit_tracker/services/models/friend_user.dart';
import 'package:fit_tracker/services/models/statistics.dart';
import 'package:fit_tracker/services/models/user.dart';
import 'package:fit_tracker/services/models/workout.dart';
import 'package:fit_tracker/utils/global_context.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ======================
  // Métodos para Usuários
  // ======================

  /// Obtém um usuário pelo ID (Firestore)

Future<User?> getUserById(String uid) async {
    print(uid);
  try {
    final userDoc = await _firestore.collection('users').doc(uid).get();

    if (!userDoc.exists) {
      return null; 
    }

    final userData = userDoc.data();
    return User(
      id: uid,  
      email: userData?['email'] ?? '',
      birthDate: userData?['birthDate'] != null
          ? DateTime.parse(userData!['birthDate'])
          : null,
      password: userData?['password'] ?? '',
      firstName: userData?['name'] ?? '',
      lastName: userData?['surname'] ?? '',
    );
  } catch (e) {
    print("Erro ao buscar usuário: $e");
    return null;
  }
}

Future<User?> getUserByName(String name) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    print("Consulta realizada. Documentos encontrados: ${querySnapshot.docs.length}");

    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs.first.data();
      print("Dados do usuário encontrados: $userData");
      
      return User.fromMap(userData);  
    } else {
      print("Nenhum usuário encontrado com o nome: $name");
      return null;  
    }
  } catch (e) {
    print("Erro ao buscar usuário: $e");
    return null;
  }
}

  /// Atualiza os dados de um usuário
  Future<void> updateUser(User updatedUser) async {
    try {
      await _firestore.collection('users').doc(updatedUser.id).update({
        'email': updatedUser.email,
        'birthDate': updatedUser.birthDate?.toIso8601String(),
        'password': updatedUser.password,
        'firstName': updatedUser.firstName,
        'lastName': updatedUser.lastName,
        'profilePicture': updatedUser.profilePicture,
      });
    } catch (e) {
      print("Erro ao atualizar usuário: $e");
    }
  }

  // ======================
  // Métodos para Estatísticas
  // ======================

  /// Obtém as estatísticas de um usuário pelo ID

Future<Statistic> getStatisticsByUserId(String userId) async {
  final statsDoc = await _firestore.collection('statistics').doc('$userId').get();

  if (statsDoc.exists) {
    return Statistic.fromMap(statsDoc.data()!);
  }

  // Retornar uma instância padrão caso não exista no banco
  return Statistic(
    lastWorkout:DateTime(1970,1 ,1), 
    totalWorkouts: 0,
    currentStreak: 0,
    biggestStreak: 0,
    totalFriends: 0,
    userId: userId,
  );
}
  /// Atualiza as estatísticas de um usuário
  Future<void> updateStatistics(Statistic statistic) async {
    try {
      await _firestore
          .collection('statistics')
          .doc(statistic.userId)
          .update(statistic.toMap());
    } catch (e) {
      print("Erro ao atualizar estatísticas: $e");
    }
  }

  // ======================
  // Métodos para Amigos
  // ======================
  Future<void> insertFriend(Friend friend) async {
    await _firestore.collection('friends').doc(friend.id).set(friend.toMap());
  }

  Future<void> addFriend(String friendUserId) async {
    final loggedUserId = GlobalContext.userId;

    if (loggedUserId != null) {
      FriendUser friendUser = FriendUser(
        friendId: friendUserId,
        userId: loggedUserId,
      );

      final existingFriend = await _firestore
          .collection('friends_has_users')
          .where('friends_idfriends', isEqualTo: friendUserId)
          .where('users_id', isEqualTo: loggedUserId)
          .get();

      if (existingFriend.docs.isEmpty) {
        await insertFriendUser(friendUser);

        final statDoc = await _firestore.collection('statistics').doc(loggedUserId).get();

        if (statDoc.exists) {
          Statistic s = Statistic.fromMap(statDoc.data()!);
          Statistic updatedStatistic = Statistic(
            lastWorkout: s.lastWorkout,
            totalWorkouts: s.totalWorkouts,
            currentStreak: s.currentStreak,
            biggestStreak: s.biggestStreak,
            totalFriends: s.totalFriends + 1,
            userId: s.userId,
          );

          await updateStatistics(updatedStatistic);
        }
      } else {
        print("Amigo já adicionado.");
      }
    } else {
      print("Erro: ID do usuário logado não encontrado.");
    }
  }

  Future<void> insertFriendUser(FriendUser friendUser) async {
    await _firestore.collection('friends_has_users').add(friendUser.toMap());
  }

Future<void> createUserStatistics(String userId) async {
  try {
    // Definindo os dados iniciais para o usuário
    Statistic statistic = Statistic(
      userId: userId,
      totalWorkouts: 0,        // Inicia com 0 treinos
      currentStreak: 0,        // Inicia com 0 streak
      biggestStreak: 0,        // Inicia com 0 maior streak
      totalFriends: 0,         // Inicia com 0 amigos
      lastWorkout: null,       // Inicializa como nulo, pois o usuário ainda não fez nenhum treino
    );

    // Convertendo o objeto Statistic para Map
    Map<String, dynamic> statisticData = statistic.toMap();

    // Referência para a coleção 'userStatistics' no Firestore
    await FirebaseFirestore.instance
        .collection('userStatistics')
        .doc(userId)  // Usando o userId para criar o documento com o ID do usuário
        .set(statisticData);  // Criando o documento com os dados iniciais

    print("Estatísticas do usuário $userId criadas com sucesso!");
  } catch (e) {
    print("Erro ao criar estatísticas para o usuário $userId: $e");
  }
}

  // ======================
  // Métodos para Treinos
  // ======================
  Future<List<Workout>> getAllWorkoutsByUserId(String userId) async {
    var snapshot = await _firestore
        .collection('workouts')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => Workout.fromFirestore(doc)).toList();
  }

  Future<void> addWorkout(Workout workout) async {
    await _firestore.collection('workouts').add(workout.toMap());
  }

  Future<void> updateWorkout(Workout workout) async {
    await _firestore.collection('workouts').doc(workout.id).update(workout.toMap());
  }

  Future<void> deleteWorkout(String workoutId) async {
    await _firestore.collection('workouts').doc(workoutId).delete();
  }

  // ======================
  // Métodos para Exercícios
  // ======================
  Future<void> addExercise(Exercise exercise) async {
    await _firestore.collection('exercises').add(exercise.toMap());
  }

  Future<List<Exercise>> getExercisesByWorkoutId(String workoutId) async {
    var snapshot = await _firestore
        .collection('exercises')
        .where('workoutId', isEqualTo: workoutId)
        .get();
    return snapshot.docs.map((doc) => Exercise.fromFirestore(doc)).toList();
  }

  Future<void> deleteExercise(String exerciseId) async {
    await _firestore.collection('exercises').doc(exerciseId).delete();
  }

// ======================
// Métodos para Amigos
// ======================

/// Obtém a lista de amigos de um usuário

Future<List<Friends>> getFriendList(User user) async {
  try {
    final snapshot = await _firestore
        .collection('friends_has_users')
        .where('users_id', isEqualTo: user.id)
        .get();

    print("Amigos encontrados: ");
    snapshot.docs.forEach((doc) {
      print(doc.data()); 
    });

    List<Friends> friendsList = [];
    for (var doc in snapshot.docs) {
      FriendUser friendUser = FriendUser.fromMap(doc.data());

      var friendSnapshot = await _firestore.collection('users').doc(friendUser.friendId).get();

      if (friendSnapshot.exists) {
        var friendData = friendSnapshot.data();
        Friends friend = Friends(
          id: friendUser.friendId,  
          name: friendData?['name'] ?? '',
          hasStreak: true,
          streakDays: 3,
        );

        friendsList.add(friend);
      }
    }


    return friendsList;  
  } catch (e) {
    print("Erro ao carregar amigos: $e");
    return [];
  }
}
}
