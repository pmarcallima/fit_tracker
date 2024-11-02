
class Friend {
  final int? id;

  Friend({this.id});

  Map<String, dynamic> toMap() {
    return {
      'idfriends': id,
    };
  }
}
