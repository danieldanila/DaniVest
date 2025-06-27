import 'package:flutter/material.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/utilities/forms/screen_lock.dart';
import 'package:frontend/utilities/navigation/app_navigator.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/widgets/homepage/amount_display.dart';
import 'package:provider/provider.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      authProvider.addListener(() {
        if (!authProvider.isAuthenticated) {
          AppNavigator.replaceToStartPage(context);
        }
      });

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
    // In case of rebuilds
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: constants.Properties.containerHorizontalMargin,
          vertical: constants.Properties.containerVerticalMargin,
        ),
        child: const AmountDisplay(),
      ),
    );
  }
}
