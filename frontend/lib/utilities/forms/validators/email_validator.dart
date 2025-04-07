import 'package:frontend/utilities/forms/validations.dart';
import 'package:frontend/constants/constants.dart' as constants;

String? emailValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldWithoutSpaces(value!) ??
      Validations.fieldMinimumLength(
        value!,
        constants.Properties.minimumEmailFieldLength,
      ) ??
      Validations.fieldValidEmail(value!);
}
