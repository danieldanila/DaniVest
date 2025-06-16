import 'package:flutter/material.dart';
import 'package:frontend/screens/add_withdraw_money.dart';
import 'package:frontend/screens/invest.dart';
import 'package:frontend/screens/my_account.dart';
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

  static void navigateToHomepage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomepageScreen()),
    );
  }

  static void replaceToHomepage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomepageScreen()),
    );
  }

  static void navigateToTransferPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransferScreen()),
    );
  }

  static void navigateToInvestPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InvestScreen()),
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
}
