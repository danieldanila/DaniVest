import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/change_my_password_data.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/utilities/forms/validators/confirm_password_validator.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/utilities/forms/validators/password_validator.dart';

class ChangeMyPassword extends StatefulWidget {
  const ChangeMyPassword({super.key});

  @override
  State<ChangeMyPassword> createState() => _ChangeMyPasswordState();
}

class _ChangeMyPasswordState extends State<ChangeMyPassword> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordConfirmController =
      TextEditingController();

  String? _message;
  bool _obscureCurrentPassword = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _changeCurrentPasswordVisibility() {
    setState(() {
      _obscureCurrentPassword = !_obscureCurrentPassword;
    });
  }

  void _changePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _changeConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    newPasswordConfirmController.dispose();
    super.dispose();
  }

  Future<void> handleChangePassword(
    ChangeMyPasswordData changeMyPasswordData,
  ) async {
    final authService = locator<AuthService>();

    final customResponse = await authService.updatePassword(
      changeMyPasswordData,
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
              controller: currentPasswordController,
              validator: passwordValidator,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscureCurrentPassword,
              decoration: InputDecoration(
                labelText: constants.Strings.currentPasswordFieldLabel,
                hintText: constants.Strings.currentPasswordFieldHint,
                suffixIcon: IconButton(
                  onPressed: _changeCurrentPasswordVisibility,
                  icon: Icon(
                    _obscureCurrentPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: newPasswordController,
              validator: passwordValidator,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: constants.Strings.passwordFieldLabel,
                hintText: constants.Strings.passwordFieldHint,
                suffixIcon: IconButton(
                  onPressed: _changePasswordVisibility,
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: newPasswordConfirmController,
              validator: (String? value) {
                return confirmPasswordValidator(
                  value,
                  newPasswordController.text,
                );
              },
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: constants.Strings.confirmPasswordFieldLabel,
                hintText: constants.Strings.confirmPasswordFieldHint,
                suffixIcon: IconButton(
                  onPressed: _changeConfirmPasswordVisibility,
                  icon: Icon(
                    _obscureConfirmPassword
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
                  final changeMyPasswordData = ChangeMyPasswordData(
                    currentPassword: currentPasswordController.text,
                    password: newPasswordController.text,
                  );
                  handleChangePassword(changeMyPasswordData);
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
