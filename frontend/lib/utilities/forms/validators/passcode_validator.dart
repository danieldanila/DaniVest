import 'package:frontend/utilities/forms/validations.dart';

String? passcodeValidator(String? value) {
  return Validations.fieldRequired(value);
}
