import 'package:frontend/utilities/forms/validations.dart';

String? cardNumberValidator(String? value) {
  return Validations.fieldRequired(value);
}
