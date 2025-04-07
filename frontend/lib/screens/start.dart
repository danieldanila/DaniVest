import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/utilities/navigation/app_navigator.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: constants.Properties.containerHorizontalMargin,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(constants.Strings.logoUrl),
            const SizedBox(height: constants.Properties.sizedBoxHeight),
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToLoginPage(context);
              },
              child: const Text(constants.Strings.loginButtonMessage),
            ),
            TextButton(
              onPressed: () {
                AppNavigator.navigateToSignupPage(context);
              },
              child: const Text(constants.Strings.signupButtonMessage),
            ),
          ],
        ),
      ),
    );
  }
}
