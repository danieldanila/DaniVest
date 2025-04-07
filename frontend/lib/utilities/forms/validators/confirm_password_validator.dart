import 'package:frontend/utilities/forms/validations.dart';
import 'package:frontend/constants/constants.dart' as constants;

String? confirmPasswordValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldMinimumLength(
        value!,
        constants.Properties.minimumPasswordFieldLength,
      ) ??
      Validations.fieldWithLowercaseLetter(value!) ??
      Validations.fieldWithUppercaseLetter(value!) ??
      Validations.fieldWithNumber(value!) ??
      Validations.fieldWithSpecialCharacter(value!);
}
