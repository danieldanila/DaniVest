import 'package:frontend/utilities/forms/validations.dart';

String? phoneNumberValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldWithoutSpaces(value!) ??
      Validations.fieldMinimumLength(value!, 10) ??
      Validations.fieldValidPhoneNumber(value!);
}
