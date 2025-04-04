import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/signup.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  void _navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateToSignupPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: constants.Properties.containerMargin,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(constants.Strings.logoUrl),
            const SizedBox(height: constants.Properties.sizedBoxHeight),
            ElevatedButton(
              onPressed: () {
                _navigateToLoginPage(context);
              },
              child: const Text(constants.Strings.loginButtonMessage),
            ),
            TextButton(
              onPressed: () {
                _navigateToSignupPage(context);
              },
              child: const Text(constants.Strings.signupButtonMessage),
            ),
          ],
        ),
      ),
    );
  }
}
