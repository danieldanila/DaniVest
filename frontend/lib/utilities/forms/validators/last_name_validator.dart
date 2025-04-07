import 'package:frontend/utilities/forms/validations.dart';
import 'package:frontend/constants/constants.dart' as constants;

String? lastNameValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldMinimumLength(
        value!,
        constants.Properties.minimumLastNameFieldLength,
      ) ??
      Validations.fieldWithLettersOnly(value!);
}
