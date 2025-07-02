import 'package:frontend/utilities/forms/validations.dart';

String? cvvValidator(String? value) {
  return Validations.fieldRequired(value);
}
