import 'package:frontend/utilities/forms/validations.dart';

String? confirmPasscodeValidator(String? value, String passcode) {
  return Validations.fieldRequired(value) ??
      Validations.fieldEqualToOtherValue(value!, passcode);
}
