import 'package:frontend/widgets/forms/validations.dart';

String? emailValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldWithoutSpaces(value!) ??
      Validations.fieldWithoutLeadingNumber(value!) ??
      Validations.fieldMinimumLength(value!, 6);
}
