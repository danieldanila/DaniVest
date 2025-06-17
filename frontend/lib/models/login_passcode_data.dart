class LoginPasscodeData {
  const LoginPasscodeData({required this.username, required this.passcode});

  final String username;
  final String passcode;

  LoginPasscodeData.fromJson(Map<String, dynamic> json)
    : username = json["username"] as String,
      passcode = json["passcode"] as String;

  Map<String, dynamic> toJson() => {"username": username, "passcode": passcode};
}
