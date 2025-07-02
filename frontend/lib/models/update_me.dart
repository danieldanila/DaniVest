class UpdateMeData {
  const UpdateMeData({
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });

  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  UpdateMeData.fromJson(Map<String, dynamic> json)
    : email = json["email"] as String?,
      firstName = json["firstName"] as String?,
      lastName = json["lastName"] as String?,
      phoneNumber = json["phoneNumber"] as String?;

  Map<String, dynamic> toJson() => {
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "phoneNumber": phoneNumber,
  };
}
