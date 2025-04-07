import 'package:frontend/utilities/forms/validations.dart';
import 'package:frontend/constants/constants.dart' as constants;

String? firstNameValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldMinimumLength(
        value!,
        constants.Properties.minimumFirstNameFieldLength,
      ) ??
      Validations.fieldWithLettersOnly(value!);
}
