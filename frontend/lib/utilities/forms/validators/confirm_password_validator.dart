import 'package:frontend/utilities/forms/validations.dart';
import 'package:frontend/constants/constants.dart' as constants;

String? confirmPasswordValidator(String? value, String password) {
  return Validations.fieldRequired(value) ??
      Validations.fieldMinimumLength(
        value!,
        constants.Properties.minimumPasswordFieldLength,
      ) ??
      Validations.fieldWithLowercaseLetter(value!) ??
      Validations.fieldWithUppercaseLetter(value!) ??
      Validations.fieldWithNumber(value!) ??
      Validations.fieldWithSpecialCharacter(value!) ??
      Validations.fieldEqualToOtherValue(value!, password);
}
