import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/models/login_data.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/tracking/tracking_text_controller.dart';
import 'package:frontend/utilities/forms/validators/username_validator.dart';
import 'package:frontend/utilities/forms/validators/password_validator.dart';
import 'package:frontend/utilities/navigation/app_navigator.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TrackingTextController usernameController = TrackingTextController();
  final TrackingTextController passwordController = TrackingTextController();

  bool _obscurePassword = true;
  String? _message;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _changePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> handleLogin(LoginData loginData) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final customResponse = await auth.login(loginData);

    if (!mounted) return;

    setState(() {
      _message = customResponse.message;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_message!)));

    if (customResponse.success) {
      AppNavigator.replaceToMainNavigationPage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            enableSuggestions: false,
            controller: usernameController,
            validator: usernameValidator,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: constants.Strings.usernameFieldLabel,
              hintText: constants.Strings.usernameFieldHint,
            ),
          ),
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
          const SizedBox(height: constants.Properties.sizedBoxHeight),
          ElevatedButton(
            onPressed: () async {
              bool areFieldsValidated = formKey.currentState!.validate();
              if (areFieldsValidated) {
                final loginData = LoginData(
                  username: usernameController.text,
                  password: passwordController.text,
                );
                await handleLogin(loginData);
              }
            },
            child: const Text(constants.Strings.loginButtonMessage),
          ),
        ],
      ),
    );
  }
}
