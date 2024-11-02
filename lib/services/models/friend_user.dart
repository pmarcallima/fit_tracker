
class FriendUser {
  final int friendId;
  final int userId;

  FriendUser({
    required this.friendId,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'friends_idfriends': friendId,
      'users_id': userId,
    };
  }
}
