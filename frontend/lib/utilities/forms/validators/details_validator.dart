import 'package:frontend/utilities/forms/validations.dart';

String? detailsValidator(String? value) {
  return Validations.fieldRequired(value);
}
