import 'package:flutter/material.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/widgets/app_bar_title.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:provider/provider.dart';

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          text: constants.Strings.homepageAppBarTitle,
          primaryTextStartPosition: 0,
          primaryTextEndPosition: 1,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: constants.Properties.containerHorizontalMargin,
          vertical: constants.Properties.containerVerticalMargin,
        ),
        child:
            authProvider.isAuthenticated
                ? Center(
                  child: Text("ESTI LOGAT ${authProvider.user!.username}"),
                )
                : const Center(child: Text("NU ESTI LOGAT")),
      ),
    );
  }
}
