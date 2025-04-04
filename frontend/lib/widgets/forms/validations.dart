import 'package:frontend/constants/constants.dart' as constants;

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
}
