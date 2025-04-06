class StringValidator {
  static final RegExp _name = RegExp(r'^[A-Za-z]+(?:[ -][A-Za-z]+)*$');
  static final RegExp _phoneNumber = RegExp(r'^\+?[0-9]+$');

  static bool isName(String value) {
    return _name.hasMatch(value);
  }

  static bool isPhoneNumber(String value) {
    return _phoneNumber.hasMatch(value);
  }
}
