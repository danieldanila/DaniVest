import 'package:frontend/constants/constants.dart' as constants;

class StringValidator {
  static final RegExp _name = RegExp(constants.Strings.nameRegExp);
  static final RegExp _phoneNumber = RegExp(
    constants.Strings.phoneNumberRegExp,
  );

  static bool isName(String value) {
    return _name.hasMatch(value);
  }

  static bool isPhoneNumber(String value) {
    return _phoneNumber.hasMatch(value);
  }

  static bool isDate(String value) {
    List<String> dateParts = value.split(constants.Strings.dateDelimiter);

    if (dateParts.length != 3) {
      return false;
    }

    for (String datePart in dateParts) {
      if (int.tryParse(datePart) == null) {
        return false;
      }
    }

    return true;
  }
}
