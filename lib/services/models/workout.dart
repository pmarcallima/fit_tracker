
import 'dart:typed_data';

class Workout {
  final int? id;
  final String? name;
  final Uint8List? workoutPicture;
  final int userId;

  Workout({
    this.id,
    this.name,
    this.workoutPicture,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'workoutPicture': workoutPicture,
      'userId': userId,
    };
  }
}
