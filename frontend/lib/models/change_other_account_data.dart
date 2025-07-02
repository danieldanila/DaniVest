class ChangeOtherAccountData {
  const ChangeOtherAccountData({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });

  final String cardNumber;
  final String expiryDate;
  final String cvv;

  ChangeOtherAccountData.fromJson(Map<String, dynamic> json)
    : cardNumber = json["cardNumber"] as String,
      expiryDate = json["expiryDate"] as String,
      cvv = json["cvv"] as String;

  Map<String, dynamic> toJson() => {
    "cardNumber": cardNumber,
    "expiryDate": expiryDate,
    "cvv": cvv,
  };
}
