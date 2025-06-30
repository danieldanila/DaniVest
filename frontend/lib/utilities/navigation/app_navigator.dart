import 'package:flutter/material.dart';
import 'package:frontend/screens/add_withdraw_money.dart';
import 'package:frontend/screens/main_navigation.dart';
import 'package:frontend/screens/my_account.dart';
import 'package:frontend/screens/reset_password.dart';
import 'package:frontend/screens/start.dart';
import 'package:frontend/screens/homepage.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/signup.dart';
import 'package:frontend/screens/transactions.dart';
import 'package:frontend/screens/transfer.dart';

class AppNavigator {
  static void replaceToStartPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StartScreen()),
    );
  }

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

  static void replaceToMainNavigationPage(
    BuildContext context, {
    int initialIndex = 0,
    bool homepageShowCardDetails = false,
  }) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => MainNavigationScreen(
              initialIndex: initialIndex,
              homepageShowCardDetails: homepageShowCardDetails,
            ),
      ),
    );
  }

  static void navigateToHomepage(
    BuildContext context, {
    bool showCardDetails = false,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomepageScreen(showCardDetails: showCardDetails),
      ),
    );
  }

  static void replaceToHomepage(
    BuildContext context, {
    bool showCardDetails = false,
  }) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomepageScreen(showCardDetails: showCardDetails),
      ),
    );
  }

  static void navigateToTransferPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransferScreen()),
    );
  }

  static void navigateToTransactionsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransactionsScreen()),
    );
  }

  static void navigateToMyAccountPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyAccountScreen()),
    );
  }

  static void navigateToAddWithdrawMoneyPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWithdrawMoneyScreen()),
    );
  }

  static void replaceToResetPasswordPage(BuildContext context, String token) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResetPasswordScreen(token: token),
      ),
    );
  }
}
