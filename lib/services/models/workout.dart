
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  final String? id;
  String? name;
  final Uint8List? workoutPicture;
  final String userId;

  Workout({
    this.id,
    this.name,
    this.workoutPicture,
    required this.userId,
  });

  factory Workout.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Workout(
      id: data['id'], // Adapte conforme necessário para o seu banco de dados
      name: data['name'],
      workoutPicture: data['workoutPicture'] != null
          ? Uint8List.fromList(List<int>.from(data['workoutPicture']))
          : null,  // Se a imagem for armazenada como lista de bytes
      userId: data['userId'],
    );
  }

  // Método para converter a classe Workout em um Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'workoutPicture': workoutPicture,
      'userId': userId,
    };
  }
}
