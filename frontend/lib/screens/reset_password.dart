import 'package:flutter/material.dart';
import 'package:frontend/widgets/app_bar_title.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/widgets/forms/reset_password_form.dart';
import 'package:frontend/widgets/sidebar_drawer.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          text: constants.Strings.myAccountPageName,
          primaryTextStartPosition: 0,
          primaryTextEndPosition: 1,
        ),
      ),
      drawer: const SidebarDrawer(),
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
                const Text(constants.Strings.forgotMyPassword),
                ResetPasswordForm(token: token),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
