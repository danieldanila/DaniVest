class LoginData {
  const LoginData({required this.username, required this.password});

  final String username;
  final String password;

  LoginData.fromJson(Map<String, dynamic> json)
    : username = json["username"] as String,
      password = json["password"] as String;

  Map<String, dynamic> toJson() => {"username": username, "password": password};
}
