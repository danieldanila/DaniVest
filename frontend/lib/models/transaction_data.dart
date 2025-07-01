import 'package:intl/intl.dart';

class TransactionData {
  const TransactionData({
    required this.amount,
    required this.datetime,
    required this.details,
    required this.isApproved,
    required this.senderBankAccountId,
    required this.receiverBankAccountId,
  });

  final String amount;
  final String datetime;
  final String details;
  final bool isApproved;
  final String senderBankAccountId;
  final String receiverBankAccountId;

  TransactionData.fromJson(Map<String, dynamic> json)
    : amount = json["amount"] as String,
      datetime = json["datetime"] as String,
      details = json["details"] as String,
      isApproved = json["isApproved"] as bool,
      senderBankAccountId = json["senderBankAccountId"] as String,
      receiverBankAccountId = json["receiverBankAccountId"] as String;

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "datetime": datetime,
    "details": details,
    "isApproved": isApproved,
    "senderBankAccountId": senderBankAccountId,
    "receiverBankAccountId": receiverBankAccountId,
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
}
