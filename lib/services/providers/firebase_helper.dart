
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_tracker/services/models/exercise.dart';
import 'package:fit_tracker/services/models/workout.dart';

class FirestoreHelper {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Carregar todos os treinos de um usuário
  Future<List<Workout>> getAllWorkoutsByUserId(int userId) async {
    var snapshot = await _db
        .collection('workouts')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => Workout.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // Atualizar estatísticas de um usuário
  Future<void> updateUserStatistics(int userId, DateTime lastWorkoutDate, int totalWorkouts, int currentStreak, int biggestStreak) async {
    await _db.collection('users').doc(userId.toString()).update({
      'lastWorkoutDate': lastWorkoutDate,
      'totalWorkouts': totalWorkouts,
      'currentStreak': currentStreak,
      'biggestStreak': biggestStreak,
    });
  }

  // Adicionar um novo treino
  Future<void> addWorkout(Workout workout) async {
    await _db.collection('workouts').add(workout.toMap());
  }

  // Atualizar um treino existente
  Future<void> updateWorkout(Workout workout) async {
    await _db.collection('workouts').doc(workout.id).update(workout.toMap());
  }

  // Adicionar exercício
  Future<void> addExercise(Exercise exercise) async {
    await _db.collection('exercises').add(exercise.toMap());
  }

  // Obter exercícios de um treino
  Future<List<Exercise>> getExercisesByWorkoutId(int workoutId) async {
    var snapshot = await _db
        .collection('exercises')
        .where('workoutId', isEqualTo: workoutId)
        .get();
    return snapshot.docs
        .map((doc) => Exercise.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // Deletar exercício
  Future<void> deleteExercise(String exerciseId) async {
    await _db.collection('exercises').doc(exerciseId).delete();
  }

  // Deletar treino
  Future<void> deleteWorkout(String workoutId) async {
    await _db.collection('workouts').doc(workoutId).delete();
  }
}
