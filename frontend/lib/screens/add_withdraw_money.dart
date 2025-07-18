import 'package:flutter/material.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/utilities/navigation/app_navigator.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/widgets/addWithdrawMoney/add_withdraw_money.dart';
import 'package:provider/provider.dart';

class AddWithdrawMoneyScreen extends StatelessWidget {
  const AddWithdrawMoneyScreen({super.key});

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
        child: const AddWithdrawMoney(),
      ),
    );
  }
}
