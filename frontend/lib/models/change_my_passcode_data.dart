class ChangeMyPasscodeData {
  const ChangeMyPasscodeData({
    required this.currentPasscode,
    required this.passcode,
  });

  final String currentPasscode;
  final String passcode;

  ChangeMyPasscodeData.fromJson(Map<String, dynamic> json)
    : currentPasscode = json["currentPasscode"] as String,
      passcode = json["passcode"] as String;

  Map<String, dynamic> toJson() => {
    "currentPasscode": currentPasscode,
    "passcode": passcode,
  };
}
