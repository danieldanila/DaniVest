import 'package:flutter/material.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/utilities/forms/screen_lock.dart';
import 'package:frontend/utilities/navigation/app_navigator.dart';
import 'package:frontend/widgets/app_bar_title.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/widgets/sidebar_drawer.dart';
import 'package:provider/provider.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (!authProvider.passcodeChecked) {
        if (authProvider.user!.hasPasscode) {
          passcodeCheck(context);
        } else {
          passcodeSetup(context);
        }
        authProvider.setPasscodeChecked(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          AppNavigator.replaceToStartPage(context);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          text: constants.Strings.homepageAppBarTitle,
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
