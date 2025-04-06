import 'package:frontend/utilities/forms/validations.dart';

String? birthdateValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldWithoutSpaces(value!) ??
      Validations.fieldWithoutLeadingNumber(value!) ??
      Validations.fieldMinimumLength(value!, 6);
}
