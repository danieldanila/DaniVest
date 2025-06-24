class ForgotPasswordData {
  const ForgotPasswordData({required this.email});

  final String email;

  ForgotPasswordData.fromJson(Map<String, dynamic> json)
    : email = json["email"] as String;

  Map<String, dynamic> toJson() => {"email": email};
}
