import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(constants.Strings.loginAppBarTitle)),
    );
  }
}
