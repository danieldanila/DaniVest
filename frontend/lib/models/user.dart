class User {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.birthdate,
    required this.profilePicturePath,
    required this.hasPasscode,
  });

  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String birthdate;
  final String? profilePicturePath;
  final bool hasPasscode;

  User.fromJson(Map<String, dynamic> json)
    : id = json["id"] as String,
      username = json["username"] as String,
      email = json["email"] as String,
      firstName = json["firstName"] as String,
      lastName = json["lastName"] as String,
      phoneNumber = json["phoneNumber"] as String,
      birthdate = json["birthdate"] as String,
      profilePicturePath = json["profilePicturePath"] as String?,
      hasPasscode = json["hasPasscode"] as bool;

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "phoneNumber": phoneNumber,
    "birthdate": birthdate,
    "profilePicturePath": profilePicturePath,
    "hasPasscode": hasPasscode,
  };
}
