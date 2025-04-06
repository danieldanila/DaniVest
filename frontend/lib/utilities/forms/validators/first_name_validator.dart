import 'package:frontend/utilities/forms/validations.dart';

String? firstNameValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldMinimumLength(value!, 3) ??
      Validations.fieldWithLettersOnly(value!);
}
