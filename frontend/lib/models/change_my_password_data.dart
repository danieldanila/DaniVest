class ChangeMyPasswordData {
  const ChangeMyPasswordData({
    required this.currentPassword,
    required this.password,
  });

  final String currentPassword;
  final String password;

  ChangeMyPasswordData.fromJson(Map<String, dynamic> json)
    : currentPassword = json["currentPassword"] as String,
      password = json["password"] as String;

  Map<String, dynamic> toJson() => {
    "currentPassword": currentPassword,
    "password": password,
  };
}
