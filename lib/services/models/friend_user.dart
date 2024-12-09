
class FriendUser {
  final String friendId;
  final String userId;

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
factory FriendUser.fromMap(Map<String, dynamic> map) {
    return FriendUser(
      friendId: map['friends_idfriends'],
      userId: map['users_id'],
    );
  }
}
