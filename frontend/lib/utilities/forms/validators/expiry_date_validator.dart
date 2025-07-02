import 'package:frontend/utilities/forms/validations.dart';

String? expiryDateValidator(String? value) {
  return Validations.fieldRequired(value);
}
