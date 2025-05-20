class SignupData {
  const SignupData({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.birthdate,
    required this.password,
  });

  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String birthdate;
  final String password;

  SignupData.fromJson(Map<String, dynamic> json)
    : username = json["username"] as String,
      email = json["email"] as String,
      firstName = json["firstName"] as String,
      lastName = json["lastName"] as String,
      phoneNumber = json["phoneNumber"] as String,
      birthdate = json["birthdate"] as String,
      password = json["password"] as String;

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "phoneNumber": phoneNumber,
    "birthdate": birthdate,
    "password": password,
  };
}
