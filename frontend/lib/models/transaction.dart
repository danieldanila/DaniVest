import 'package:intl/intl.dart';

class Transaction {
  const Transaction({
    required this.id,
    required this.amount,
    required this.datetime,
    required this.details,
    required this.isApproved,
    required this.senderBankAccountId,
    required this.receiverBankAccountId,
    required this.senderName,
    required this.receiverName,
    required this.senderId,
    required this.receiverId,
  });

  final String id;
  final String amount;
  final String datetime;
  final String details;
  final bool isApproved;
  final String senderBankAccountId;
  final String receiverBankAccountId;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;

  Transaction.fromJson(Map<String, dynamic> json)
    : id = json["id"] as String,
      amount = json["amount"] as String,
      datetime = json["datetime"] as String,
      details = json["details"] as String,
      isApproved = json["isApproved"] as bool,
      senderBankAccountId = json["senderBankAccountId"] as String,
      receiverBankAccountId = json["receiverBankAccountId"] as String,
      senderId = json["sender"]["User"]["id"] as String,
      senderName = json["sender"]["User"]["fullName"] as String,
      receiverId = json["receiver"]["User"]["id"] as String,
      receiverName = json["receiver"]["User"]["fullName"] as String;

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "datetime": datetime,
    "details": details,
    "isApproved": isApproved,
    "senderBankAccountId": senderBankAccountId,
    "receiverBankAccountId": receiverBankAccountId,
    "sender.User.id": senderId,
    "sender.User.firstName": senderName,
    "receiver.User.id": receiverId,
    "receiver.User.firstName": receiverName,
  };

  DateTime get parsedDateTime => DateTime.parse(datetime);

  String get formattedDate {
    DateTime now = DateTime.now();

    DateFormat formatter = DateFormat("d MMMM yyyy, h:mm a");
    String prefix = "";
    if (parsedDateTime.year == now.year && parsedDateTime.month == now.month) {
      if (parsedDateTime.day == now.day) {
        formatter = DateFormat("h:mm a");
        prefix = "Today ";
      } else if (parsedDateTime.day == now.day - 1) {
        formatter = DateFormat("h:mm a");
        prefix = "Yesterday ";
      }
    }
    return "$prefix${formatter.format(parsedDateTime)}";
  }

  String get formattedOnlyDate {
    DateTime now = DateTime.now();

    DateFormat formatter = DateFormat("d MMMM yyyy");

    if (parsedDateTime.year == now.year && parsedDateTime.month == now.month) {
      if (parsedDateTime.day == now.day) {
        return "Today";
      } else if (parsedDateTime.day == now.day - 1) {
        return "Yesterday";
      }
    }

    return formatter.format(parsedDateTime);
  }

  String get formattedAmount {
    return double.parse(amount).toStringAsFixed(2);
  }
}
