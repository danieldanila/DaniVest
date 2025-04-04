import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/widgets/app_bar_title.dart';
import 'package:frontend/widgets/forms/validations/username.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
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
