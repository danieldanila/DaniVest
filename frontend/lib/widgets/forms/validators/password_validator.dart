import 'package:frontend/widgets/forms/validations.dart';

String? passwordValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldWithoutSpaces(value!) ??
      Validations.fieldWithoutLeadingNumber(value!) ??
      Validations.fieldMinimumLength(value!, 6);
}
