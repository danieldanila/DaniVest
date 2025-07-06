import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/models/signup_data.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/tracking/tracking_text_controller.dart';
import 'package:frontend/utilities/forms/validators/username_validator.dart';
import 'package:frontend/utilities/forms/validators/email_validator.dart';
import 'package:frontend/utilities/forms/validators/first_name_validator.dart';
import 'package:frontend/utilities/forms/validators/last_name_validator.dart';
import 'package:frontend/utilities/forms/validators/phone_number_validator.dart';
import 'package:frontend/utilities/forms/validators/birthdate_validator.dart';
import 'package:frontend/utilities/forms/validators/password_validator.dart';
import 'package:frontend/utilities/forms/validators/confirm_password_validator.dart';
import 'package:frontend/utilities/navigation/app_navigator.dart';
import 'package:provider/provider.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TrackingTextController usernameController = TrackingTextController();
  final TrackingTextController emailController = TrackingTextController();
  final TrackingTextController firstNameController = TrackingTextController();
  final TrackingTextController lastNameController = TrackingTextController();
  final TrackingTextController phoneNumberController = TrackingTextController();
  final TrackingTextController birthdateController = TrackingTextController();
  final TrackingTextController passwordController = TrackingTextController();
  final TrackingTextController confirmPasswordController =
      TrackingTextController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _message;

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

  void _selectBirthdate() async {
    DateTime? selectedBirthdate = await showDatePicker(
      context: context,
      firstDate: DateTime.utc(constants.Properties.minimumBirthdateYear),
      lastDate: DateTime.now(),
    );

    DateTime parsedSelectedBirthdate = DateTime.parse(
      selectedBirthdate.toString(),
    );

    String birthdateMonth =
        parsedSelectedBirthdate.month < 10
            ? "0${parsedSelectedBirthdate.month}"
            : "${parsedSelectedBirthdate.month}";

    String birthdateDay =
        parsedSelectedBirthdate.day < 10
            ? "0${parsedSelectedBirthdate.day}"
            : "${parsedSelectedBirthdate.day}";

    String formattedSelectedBirthdate =
        "$birthdateDay${constants.Strings.dateDelimiter}$birthdateMonth${constants.Strings.dateDelimiter}${parsedSelectedBirthdate.year}";

    birthdateController.text = formattedSelectedBirthdate;
  }

  void handleSignup(SignupData userBody) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final customResponse = await auth.signup(userBody);

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
            enableSuggestions: false,
            controller: emailController,
            validator: emailValidator,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: constants.Strings.emailFieldLabel,
              hintText: constants.Strings.emailFieldHint,
            ),
          ),
          TextFormField(
            enableSuggestions: false,
            controller: firstNameController,
            validator: firstNameValidator,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: constants.Strings.firstNameFieldLabel,
              hintText: constants.Strings.firstNameFieldHint,
            ),
          ),
          TextFormField(
            enableSuggestions: false,
            controller: lastNameController,
            validator: lastNameValidator,
            keyboardType: TextInputType.text,
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
          TextFormField(
            controller: birthdateController,
            validator: birthdateValidator,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              labelText: constants.Strings.birthdateFieldLabel,
              hintText: constants.Strings.birthdateFieldHint,
              suffixIcon: IconButton(
                onPressed: _selectBirthdate,
                icon: const Icon(Icons.calendar_month),
              ),
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
                final signupData = SignupData(
                  username: usernameController.text,
                  email: emailController.text,
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  phoneNumber: phoneNumberController.text,
                  birthdate: birthdateController.text,
                  password: passwordController.text,
                );
                handleSignup(signupData);
              }
            },
            child: const Text(constants.Strings.signupButtonMessage),
          ),
        ],
      ),
    );
  }
}
