
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String id;
  String name;
  String? description;
  final String workoutId;
  Uint8List? image;

  Exercise({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.workoutId,
  });

  // Método para converter o documento do Firestore para a classe Exercise
  factory Exercise.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Exercise(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      image: data['image'] != null
          ? Uint8List.fromList(List<int>.from(data['image']))
          : null,  // Se a imagem for armazenada como lista de bytes
      workoutId: data['workoutId'],
    );
  }

  // Método para converter a classe Exercise em um Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'workoutId': workoutId,
    };
  }
}
