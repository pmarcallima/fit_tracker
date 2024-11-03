
import 'dart:ui';
import 'dart:typed_data';

class Exercise {
  final int id;
  String name;
  String? description;
  final int workoutId;
  Uint8List? image;

  Exercise({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.workoutId,
  });

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
