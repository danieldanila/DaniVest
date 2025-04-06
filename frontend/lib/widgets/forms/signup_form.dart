import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/utilities/forms/validators/birthdate_validator.dart';
import 'package:frontend/utilities/forms/validators/confirm_password_validator.dart';
import 'package:frontend/utilities/forms/validators/email_validator.dart';
import 'package:frontend/utilities/forms/validators/first_name_validator.dart';
import 'package:frontend/utilities/forms/validators/last_name_validator.dart';
import 'package:frontend/utilities/forms/validators/password_validator.dart';
import 'package:frontend/utilities/forms/validators/phone_number_validator.dart';
import 'package:frontend/utilities/forms/validators/username_validator.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    birthdateController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: usernameController,
            validator: usernameValidator,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: constants.Strings.usernameFieldLabel,
              hintText: constants.Strings.usernameFieldHint,
            ),
          ),
          TextFormField(
            controller: emailController,
            validator: emailValidator,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: constants.Strings.emailFieldLabel,
              hintText: constants.Strings.emailFieldHint,
            ),
          ),
          TextFormField(
            controller: firstNameController,
            validator: firstNameValidator,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              labelText: constants.Strings.firstNameFieldLabel,
              hintText: constants.Strings.firstNameFieldHint,
            ),
          ),
          TextFormField(
            controller: lastNameController,
            validator: lastNameValidator,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              labelText: constants.Strings.lastNameFieldLabel,
              hintText: constants.Strings.lastNameFieldHint,
            ),
          ),
          TextFormField(
            controller: phoneNumberController,
            validator: phoneNumberValidator,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: constants.Strings.phoneNumberFieldLabel,
              hintText: constants.Strings.phoneNumberFieldHint,
            ),
          ),
          InputDatePickerFormField(
            firstDate: DateTime.utc(1920),
            lastDate: DateTime.now(),
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
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: _changePasswordVisibility,
              ),
            ),
          ),
          TextFormField(
            controller: confirmPasswordController,
            validator: confirmPasswordValidator,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: constants.Strings.confirmPasswordFieldLabel,
              hintText: constants.Strings.confirmPasswordFieldHint,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: _changeConfirmPasswordVisibility,
              ),
            ),
          ),
          const SizedBox(height: constants.Properties.sizedBoxHeight),
          ElevatedButton(
            onPressed: () {
              formKey.currentState?.validate();
            },
            child: const Text(constants.Strings.signupButtonMessage),
          ),
        ],
      ),
    );
  }
}
