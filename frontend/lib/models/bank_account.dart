class BankAccount {
  const BankAccount({
    required this.id,
    required this.amount,
    required this.iban,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.isMain,
    required this.userId,
  });

  final String id;
  final String amount;
  final String iban;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final bool isMain;
  final String userId;

  BankAccount.fromJson(Map<String, dynamic> json)
    : id = json["id"] as String,
      amount = json["amount"] as String,
      iban = json["iban"] as String,
      cardNumber = json["cardNumber"] as String,
      expiryDate = json["expiryDate"] as String,
      cvv = json["cvv"] as String,
      isMain = json["isMain"] as bool,
      userId = json["userId"] as String;

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "iban": iban,
    "cardNumber": cardNumber,
    "expiryDate": expiryDate,
    "cvv": cvv,
    "isMain": isMain,
    "userId": userId,
  };
}
