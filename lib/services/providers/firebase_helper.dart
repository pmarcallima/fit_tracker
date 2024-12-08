import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_tracker/services/models/exercise.dart';
import 'package:fit_tracker/services/models/workout.dart';
import 'package:fit_tracker/services/models/friends.dart';
import 'package:fit_tracker/services/models/friend_user.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ======================
  // Métodos para Usuários
  // ======================

  /// Obtém um usuário pelo ID (Firestore)
  Future<User?> getUserById(String id) async {
    try {
      final userDoc = await _firestore.collection('users').doc(id).get();

      if (!userDoc.exists) {
        return null; // Retorna null se o usuário não for encontrado
      }

      final userData = userDoc.data();
      return User(
        id: id,
        email: userData?['email'] ?? '',
        birthDate: userData?['birthDate'] != null
            ? DateTime.parse(userData!['birthDate'])
            : null,
        password: userData?['password'] ?? '',
        firstName: userData?['firstName'] ?? '',
        lastName: userData?['lastName'] ?? '',
        profilePicture: userData?['profilePicture'] ?? '',
      );
    } catch (e) {
      print("Erro ao buscar usuário: $e");
      return null;
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

      // Verificar se o amigo já foi adicionado
      final existingFriend = await _firestore
          .collection('friends_has_users')
          .where('friends_idfriends', isEqualTo: friendUserId)
          .where('users_id', isEqualTo: loggedUserId)
          .get();

      if (existingFriend.docs.isEmpty) {
        // Inserindo o relacionamento na coleção `friends_has_users`
        await insertFriendUser(friendUser);

        // Atualizando as estatísticas
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

  Future<List<Friends>> getFriendList(User user) async {
    final friendsQuery = await _firestore
        .collection('friends_has_users')
        .where('users_id', isEqualTo: user.id)
        .get();

    List<Friends> amigos = [];

    for (var friendDoc in friendsQuery.docs) {
      final friendData = friendDoc.data();
      final friendId = friendData['friends_idfriends'] as String;

      // Buscar informações adicionais do usuário
      final userDoc = await _firestore.collection('users').doc(friendId).get();
      final statsDoc = await _firestore.collection('statistics').doc(friendId).get();

      if (userDoc.exists && statsDoc.exists) {
        final userData = userDoc.data();
        final statsData = statsDoc.data();

        Friends friend = Friends(
          id: friendId,
          name: userData?['firstName'] ?? '',
          streakDays: statsData?['currentStreak'] ?? 0,
          hasStreak: (statsData?['currentStreak'] ?? 0) > 0,
        );

        amigos.add(friend);
      }
    }

    for (var friend in amigos) {
      print('ID: ${friend.id}, Nome: ${friend.name}, Streak: ${friend.streakDays}, Tem streak: ${friend.hasStreak}');
    }

    return amigos;
  }

  Future<void> updateStatistics(Statistic statistic) async {
    await _firestore.collection('statistics').doc(statistic.userId).update(statistic.toMap());
  }

  // ======================
  // Métodos para Treinos
  // ======================
  Future<List<Workout>> getAllWorkoutsByUserId(String userId) async {
    var snapshot = await _firestore
        .collection('workouts')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => Workout.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> updateUserStatistics(String userId, DateTime lastWorkoutDate, int totalWorkouts, int currentStreak, int biggestStreak) async {
    await _firestore.collection('users').doc(userId).update({
      'lastWorkoutDate': lastWorkoutDate,
      'totalWorkouts': totalWorkouts,
      'currentStreak': currentStreak,
      'biggestStreak': biggestStreak,
    });
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
    return snapshot.docs
        .map((doc) => Exercise.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> deleteExercise(String exerciseId) async {
    await _firestore.collection('exercises').doc(exerciseId).delete();
  }
}
