
class Exercise {
  final int? id;
  final String? name;
  final String? description;
  final int workoutId;

  Exercise({
    this.id,
    this.name,
    this.description,
    required this.workoutId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'workoutId': workoutId,
    };
  }
}
