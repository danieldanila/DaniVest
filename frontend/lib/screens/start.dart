import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/utilities/navigation/app_navigator.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    initDeepLinking();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        AppNavigator.replaceToHomepage(context);
      }
    });
  }

  void initDeepLinking() {
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.host == constants.Strings.androidIntentHost) {
        String token = uri.pathSegments.first;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            AppNavigator.replaceToResetPasswordPage(context, token);
          }
        });
      }
    });
  }

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
