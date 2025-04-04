import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/widgets/app_bar_title.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          text: constants.Strings.loginAppBarTitle,
          primaryTextStartPosition: 0,
          primaryTextEndPosition: 1,
        ),
      ),
    );
  }
}
