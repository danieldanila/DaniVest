import 'package:flutter/material.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/utilities/navigation/app_navigator.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/widgets/myAccount/my_account.dart';
import 'package:provider/provider.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppNavigator.replaceToStartPage(context);
      });
    }

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: constants.Properties.containerHorizontalMargin,
          vertical: constants.Properties.containerVerticalMargin,
        ),
        child: const MyAccount(),
      ),
    );
  }
}
