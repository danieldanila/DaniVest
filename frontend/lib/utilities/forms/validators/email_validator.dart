import 'package:frontend/utilities/forms/validations.dart';

String? emailValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldWithoutSpaces(value!) ??
      Validations.fieldMinimumLength(value!, 3) ??
      Validations.fieldValidEmail(value!);
}
