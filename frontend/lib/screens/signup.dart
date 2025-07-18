import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/utilities/navigation/app_navigator.dart';
import 'package:frontend/widgets/app_bar_title.dart';
import 'package:frontend/widgets/forms/signup_form.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppNavigator.replaceToHomepage(context);
      });
    }

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
          horizontal: constants.Properties.containerHorizontalMargin,
          vertical: constants.Properties.containerVerticalMargin,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              spacing: constants.Properties.columnSpacing,
              children: [
                Image.asset(constants.Strings.logoUrl),
                const SignupForm(),
                TextButton(
                  onPressed: () {
                    AppNavigator.replaceToLoginPage(context);
                  },
                  child: const Text(constants.Strings.alreadyHasAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
