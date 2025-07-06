import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/change_my_passcode_data.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/tracking/tracking_text_controller.dart';
import 'package:frontend/utilities/forms/validators/confirm_passcode_validator.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/utilities/forms/validators/passcode_validator.dart';

class ChangeMyPasscode extends StatefulWidget {
  const ChangeMyPasscode({super.key});

  @override
  State<ChangeMyPasscode> createState() => _ChangeMyPasscodeState();
}

class _ChangeMyPasscodeState extends State<ChangeMyPasscode> {
  final TrackingTextController currentPasscodeController =
      TrackingTextController();
  final TrackingTextController newPasscodeController = TrackingTextController();
  final TrackingTextController newPasscodeConfirmController =
      TrackingTextController();

  String? _message;
  bool _obscureCurrentPasscode = true;
  bool _obscurePasscode = true;
  bool _obscureConfirmPasscode = true;

  void _changeCurrentPasscodeVisibility() {
    setState(() {
      _obscureCurrentPasscode = !_obscureCurrentPasscode;
    });
  }

  void _changePasscodeVisibility() {
    setState(() {
      _obscurePasscode = !_obscurePasscode;
    });
  }

  void _changeConfirmPasscodeVisibility() {
    setState(() {
      _obscureConfirmPasscode = !_obscureConfirmPasscode;
    });
  }

  @override
  void dispose() {
    currentPasscodeController.dispose();
    newPasscodeController.dispose();
    newPasscodeConfirmController.dispose();
    super.dispose();
  }

  Future<void> handleChangePasscode(
    ChangeMyPasscodeData changeMyPasscodeData,
  ) async {
    final authService = locator<AuthService>();

    final customResponse = await authService.updatePasscode(
      changeMyPasscodeData,
    );

    if (!mounted) return;

    setState(() {
      _message = customResponse.message;
    });

    if (customResponse.success) {
      Navigator.pop(context);
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_message!)));
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: constants.Properties.containerHorizontalMargin,
          vertical: constants.Properties.containerVerticalMargin,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(constants.Strings.changeMyPasswordText),
            TextFormField(
              controller: currentPasscodeController,
              validator: passcodeValidator,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscureCurrentPasscode,
              decoration: InputDecoration(
                labelText: constants.Strings.currentPasscodeFieldLabel,
                hintText: constants.Strings.currentPasscodeFieldHint,
                suffixIcon: IconButton(
                  onPressed: _changeCurrentPasscodeVisibility,
                  icon: Icon(
                    _obscureCurrentPasscode
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: newPasscodeController,
              validator: passcodeValidator,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscurePasscode,
              decoration: InputDecoration(
                labelText: constants.Strings.passcodeFieldLabel,
                hintText: constants.Strings.passcodeFieldHint,
                suffixIcon: IconButton(
                  onPressed: _changePasscodeVisibility,
                  icon: Icon(
                    _obscurePasscode ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: newPasscodeConfirmController,
              validator: (String? value) {
                return confirmPasscodeValidator(
                  value,
                  newPasscodeController.text,
                );
              },
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscureConfirmPasscode,
              decoration: InputDecoration(
                labelText: constants.Strings.confirmPasscodeFieldLabel,
                hintText: constants.Strings.confirmPasscodeFieldHint,
                suffixIcon: IconButton(
                  onPressed: _changeConfirmPasscodeVisibility,
                  icon: Icon(
                    _obscureConfirmPasscode
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            const SizedBox(height: constants.Properties.sizedBoxHeight),
            ElevatedButton(
              onPressed: () {
                bool areFieldsValidated = formKey.currentState!.validate();

                if (areFieldsValidated) {
                  final changeMyPasscodeData = ChangeMyPasscodeData(
                    currentPasscode: currentPasscodeController.text,
                    passcode: newPasscodeController.text,
                  );
                  handleChangePasscode(changeMyPasscodeData);
                }
              },
              child: const Text(constants.Strings.sendButtonMessage),
            ),
          ],
        ),
      ),
    );
  }
}
