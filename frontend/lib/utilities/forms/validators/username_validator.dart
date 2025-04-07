import 'package:frontend/utilities/forms/validations.dart';
import 'package:frontend/constants/constants.dart' as constants;

String? usernameValidator(String? value) {
  return Validations.fieldRequired(value) ??
      Validations.fieldWithoutSpaces(value!) ??
      Validations.fieldWithoutLeadingNumber(value!) ??
      Validations.fieldMinimumLength(
        value!,
        constants.Properties.minimumUsernameFieldLength,
      );
}
