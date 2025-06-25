class ResetPasswordData {
  const ResetPasswordData({required this.password});

  final String password;

  ResetPasswordData.fromJson(Map<String, dynamic> json)
    : password = json["password"] as String;

  Map<String, dynamic> toJson() => {"password": password};
}
