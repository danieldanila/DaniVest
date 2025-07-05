class AddNewFriendData {
  const AddNewFriendData({this.username, this.phoneNumber, this.email});

  final String? username;
  final String? phoneNumber;
  final String? email;

  AddNewFriendData.fromJson(Map<String, dynamic> json)
    : username = json["username"] as String?,
      phoneNumber = json["phoneNumber"] as String?,
      email = json["email"] as String?;

  Map<String, dynamic> toJson() => {
    "username": username,
    "phoneNumber": phoneNumber,
    "email": email,
  };
}
