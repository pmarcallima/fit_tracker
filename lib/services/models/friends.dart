
class Friends {
  final String id;
  final String name;
  final int streakDays;
  final bool hasStreak;

  Friends({required this.id, required this.name, required this.streakDays, required this.hasStreak});

  factory Friends.fromMap(Map<String, dynamic> map) {
    return Friends(
      id: map['friends_idfriends'],
      name: map['name'],
      streakDays: map['streakDays'],
      hasStreak: map['hasStreak'] == 1,
    );
  }
}
class Friend {
  final String? id;

  Friend({this.id});

  Map<String, dynamic> toMap() {
    return {
      'idfriends': id,
    };
  }
}
