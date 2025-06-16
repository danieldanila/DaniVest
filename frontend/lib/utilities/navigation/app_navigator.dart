import 'package:flutter/material.dart';
import 'package:frontend/screens/homepage.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/signup.dart';

class AppNavigator {
  static void navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  static void replaceToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  static void navigateToSignupPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  static void navigateToHomepage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomepageScreen()),
    );
  }
}
