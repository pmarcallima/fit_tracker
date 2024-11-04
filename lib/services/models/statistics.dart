class Statistic {
  DateTime? lastWorkout;
  int totalWorkouts;
  int currentStreak;
  int biggestStreak;
  int totalFriends;
  int userId;

  Statistic({
    this.lastWorkout,
    required this.totalWorkouts,
    required this.currentStreak,
    required this.biggestStreak,
    required this.totalFriends,
    required this.userId,
  });


  factory Statistic.fromMap(Map<String, dynamic> map) {
    return Statistic(
      lastWorkout: map['lastWorkout'] != null
          ? DateTime.parse(map['lastWorkout'])
          : null,
      totalWorkouts: map['totalWorkouts'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      biggestStreak: map['biggestStreak'] ?? 0,
      totalFriends: map['totalFriends'] ?? 0,
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastWorkout': lastWorkout?.toIso8601String(),
      'totalWorkouts': totalWorkouts,
      'currentStreak': currentStreak,
      'biggestStreak': biggestStreak,
      'totalFriends': totalFriends,
      'userId': userId,
    };
  }
}
