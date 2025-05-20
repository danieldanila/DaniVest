import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/models/signup_data.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utilities/forms/validators/username_validator.dart';
import 'package:frontend/utilities/forms/validators/email_validator.dart';
import 'package:frontend/utilities/forms/validators/first_name_validator.dart';
import 'package:frontend/utilities/forms/validators/last_name_validator.dart';
import 'package:frontend/utilities/forms/validators/phone_number_validator.dart';
import 'package:frontend/utilities/forms/validators/birthdate_validator.dart';
import 'package:frontend/utilities/forms/validators/password_validator.dart';
import 'package:frontend/utilities/forms/validators/confirm_password_validator.dart';
import 'package:frontend/utilities/navigation/app_navigator.dart';

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
    final response = await UserService.createUser(userBody);

    if (!mounted) return;

    setState(() {
      _message = response;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(response)));

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
