class Friend {
  const Friend({
    required this.userId,
    required this.friendId,
    required this.since,
    required this.friendName,
  });

  final String userId;
  final String friendId;
  final String since;
  final String friendName;

  Friend.fromJson(Map<String, dynamic> json)
    : userId = json["userId"] as String,
      friendId = json["friendId"] as String,
      since = json["since"] as String,
      friendName = json["friend"]["fullName"] as String;

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "friendId": friendId,
    "since": since,
    "friend.fullName": friendName,
  };
}
