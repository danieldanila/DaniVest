import 'package:frontend/constants/constants.dart' as constants;

String? usernameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return constants.Strings.fieldRequired;
  }
  if (value.length != value.replaceAll(" ", "").length) {
    return constants.Strings.fieldWithoutSpaces;
  }
  if (int.tryParse(value[0]) != null) {
    return constants.Strings.fieldWithoutLeadingNumber;
  }
  if (value.length < 6) {
    return "${constants.Strings.fieldMinimumLength} 6";
  }
  return null;
}
