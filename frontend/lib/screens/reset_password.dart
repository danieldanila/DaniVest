import 'package:flutter/material.dart';
import 'package:frontend/widgets/app_bar_title.dart';
import 'package:frontend/constants/constants.dart' as constants;
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
        child: Center(child: Text("RESETARE PAROLA $token")),
      ),
    );
  }
}
