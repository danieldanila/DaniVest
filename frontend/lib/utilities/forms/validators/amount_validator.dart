import 'package:frontend/utilities/forms/validations.dart';

String? amountValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldWithoutSpaces(value!) ??
      Validations.fieldWithValidAmount(value!);
}
