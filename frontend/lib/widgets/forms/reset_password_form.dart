import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/models/reset_password_data.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/utilities/forms/validators/password_validator.dart';
import 'package:frontend/utilities/forms/validators/confirm_password_validator.dart';
import 'package:frontend/utilities/navigation/app_navigator.dart';
import 'package:provider/provider.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key, required this.token});

  final String token;

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _message;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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

  void handleResetPassword(ResetPasswordData resetPasswordData) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final customResponse = await auth.resetPassword(
      resetPasswordData,
      widget.token,
    );

    if (!mounted) return;

    setState(() {
      _message = customResponse.message;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_message!)));

    AppNavigator.replaceToLoginPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: passwordController,
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
            controller: confirmPasswordController,
            validator: (String? value) {
              return confirmPasswordValidator(value, passwordController.text);
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
                final signupData = ResetPasswordData(
                  password: passwordController.text,
                );
                handleResetPassword(signupData);
              }
            },
            child: const Text(constants.Strings.sendButtonMessage),
          ),
        ],
      ),
    );
  }
}
