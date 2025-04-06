import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/utilities/forms/validators/string_validator.dart';

class Validations {
  static String? fieldRequired(String? value) {
    if (value == null || value.isEmpty) {
      return constants.Strings.fieldRequired;
    }
    return null;
  }

  static String? fieldWithoutSpaces(String value) {
    if (value.length != value.replaceAll(" ", "").length) {
      return constants.Strings.fieldWithoutSpaces;
    }
    return null;
  }

  static String? fieldWithoutLeadingNumber(String value) {
    if (int.tryParse(value[0]) != null) {
      return constants.Strings.fieldWithoutLeadingNumber;
    }
    return null;
  }

  static String? fieldMinimumLength(String value, int minimumLength) {
    if (value.length < minimumLength) {
      return "${constants.Strings.fieldMinimumLength} $minimumLength";
    }
    return null;
  }

  static String? fieldValidEmail(String value) {
    if (!value.contains('@') ||
        value.indexOf('@') == 0 ||
        value.indexOf('@') == value.length - 1) {
      return constants.Strings.fieldValidEmail;
    }
    return null;
  }

  static String? fieldWithLettersOnly(String value) {
    if (!StringValidator.isName(value)) {
      return constants.Strings.fieldValidName;
    }
    return null;
  }

  static String? fieldValidPhoneNumber(String value) {
    if (!StringValidator.isPhoneNumber(value)) {
      return constants.Strings.fieldValidPhoneNumber;
    }
    return null;
  }
}
