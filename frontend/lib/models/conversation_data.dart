class ConversationData {
  const ConversationData({
    required this.userId,
    required this.friendId,
    required this.message,
    required this.datetime,
  });

  final String userId;
  final String friendId;
  final String message;
  final String datetime;

  ConversationData.fromJson(Map<String, dynamic> json)
    : userId = json["userId"] as String,
      friendId = json["friendId"] as String,
      message = json["message"] as String,
      datetime = json["datetime"] as String;

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "friendId": friendId,
    "message": message,
    "datetime": datetime,
  };
}
