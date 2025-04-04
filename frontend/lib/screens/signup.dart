import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/widgets/app_bar_title.dart';
import 'package:frontend/widgets/forms/validators/birthdate_validator.dart';
import 'package:frontend/widgets/forms/validators/confirm_password_validator.dart';
import 'package:frontend/widgets/forms/validators/email_validator.dart';
import 'package:frontend/widgets/forms/validators/first_name_validator.dart';
import 'package:frontend/widgets/forms/validators/last_name_validator.dart';
import 'package:frontend/widgets/forms/validators/password_validator.dart';
import 'package:frontend/widgets/forms/validators/phone_number_validator.dart';
import 'package:frontend/widgets/forms/validators/username_validator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          text: constants.Strings.signupAppBarTitle,
          primaryTextStartPosition: 0,
          primaryTextEndPosition: 1,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: constants.Properties.containerMargin,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                validator: usernameValidator,
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
                decoration: const InputDecoration(
                  labelText: constants.Strings.firstNameFieldLabel,
                  hintText: constants.Strings.firstNameFieldHint,
                ),
              ),
              TextFormField(
                controller: lastNameController,
                validator: lastNameValidator,
                decoration: const InputDecoration(
                  labelText: constants.Strings.lastNameFieldLabel,
                  hintText: constants.Strings.lastNameFieldHint,
                ),
              ),
              TextFormField(
                controller: phoneNumberController,
                validator: phoneNumberValidator,
                decoration: const InputDecoration(
                  labelText: constants.Strings.phoneNumberFieldLabel,
                  hintText: constants.Strings.phoneNumberFieldHint,
                ),
              ),
              TextFormField(
                controller: birthdateController,
                validator: birthdateValidator,
                decoration: const InputDecoration(
                  labelText: constants.Strings.birthdateFieldLabel,
                  hintText: constants.Strings.birthdateFieldHint,
                ),
              ),
              TextFormField(
                controller: passwordController,
                validator: passwordValidator,
                decoration: const InputDecoration(
                  labelText: constants.Strings.passwordFieldLabel,
                  hintText: constants.Strings.passwordFieldHint,
                ),
              ),
              TextFormField(
                controller: confirmPasswordController,
                validator: confirmPasswordValidator,
                decoration: const InputDecoration(
                  labelText: constants.Strings.confirmPasswordFieldLabel,
                  hintText: constants.Strings.confirmPasswordFieldHint,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  formKey.currentState?.validate();
                },
                child: const Text(constants.Strings.signupButtonMessage),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
