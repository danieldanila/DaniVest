class Conversation {
  const Conversation({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.message,
    required this.datetime,
    required this.senderUserId,
    required this.senderUserFullName,
    required this.receiverUserId,
    required this.receiverUserFullName,
  });

  final String id;
  final String userId;
  final String friendId;
  final String message;
  final String datetime;
  final String senderUserId;
  final String senderUserFullName;
  final String receiverUserId;
  final String receiverUserFullName;

  Conversation.fromJson(Map<String, dynamic> json)
    : id = json["id"] as String,
      userId = json["userId"] as String,
      friendId = json["friendId"] as String,
      message = json["message"] as String,
      datetime = json["datetime"] as String,
      senderUserId = json["senderUser"]["id"] as String,
      senderUserFullName = json["senderUser"]["fullName"] as String,
      receiverUserId = json["receiverUser"]["id"] as String,
      receiverUserFullName = json["receiverUser"]["fullName"] as String;

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "friendId": friendId,
    "message": message,
    "datetime": datetime,
    "senderUser.id": senderUserId,
    "senderUser.fullName": senderUserFullName,
    "receiverUser.id": receiverUserId,
    "receiverUser.fullName": receiverUserFullName,
  };
}
