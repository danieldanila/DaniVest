import 'package:frontend/utilities/forms/validations.dart';

String? lastNameValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldMinimumLength(value!, 3) ??
      Validations.fieldWithLettersOnly(value!);
}
