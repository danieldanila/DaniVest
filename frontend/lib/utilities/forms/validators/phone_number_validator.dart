import 'package:frontend/utilities/forms/validations.dart';
import 'package:frontend/constants/constants.dart' as constants;

String? phoneNumberValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldWithoutSpaces(value!) ??
      Validations.fieldMinimumLength(
        value!,
        constants.Properties.minimumPhoneNumberFieldLength,
      ) ??
      Validations.fieldValidPhoneNumber(value!);
}
