import 'package:frontend/utilities/forms/validations.dart';

String? messageValidator(String? value) {
  return Validations.fieldRequired(value);
}
