import 'package:frontend/utilities/forms/validations.dart';
import 'package:frontend/constants/constants.dart' as constants;

String? birthdateValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldWithoutSpaces(value!) ??
      Validations.fieldMinimumLength(
        value!,
        constants.Properties.minimumBirthdateFieldLength,
      ) ??
      Validations.fieldValidDate(value!);
}
