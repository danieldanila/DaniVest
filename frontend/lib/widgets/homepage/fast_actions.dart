import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/utilities/navigation/app_navigator.dart';

class FastActions extends StatelessWidget {
  const FastActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textButtonTheme: TextButtonThemeData(
          style: Theme.of(context).textButtonTheme.style?.copyWith(
            foregroundColor: WidgetStateProperty.all<Color>(
              const Color(constants.Colors.black),
            ),
          ),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: constants.Properties.columnSpacing,
        runSpacing: constants.Properties.columnSpacing,
        children: [
          TextButton(
            onPressed: () {
              AppNavigator.replaceToMainNavigationPage(
                context,
                initialIndex: constants.Properties.transferPageIndex,
              );
            },
            child: const Text(constants.Strings.transferPageName),
          ),
          TextButton(
            onPressed: () {
              AppNavigator.replaceToMainNavigationPage(
                context,
                initialIndex: constants.Properties.addWithdrawMoneyPageIndex,
              );
            },
            child: const Text(constants.Strings.addWithdrawMoneyPageName),
          ),
          TextButton(
            onPressed: () {
              AppNavigator.replaceToMainNavigationPage(
                context,
                initialIndex: constants.Properties.myAccountPageIndex,
              );
            },
            child: const Text(constants.Strings.myAccountPageName),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(constants.Strings.shareIbanPageName),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(constants.Strings.showCardDetailsPageName),
          ),
        ],
      ),
    );
  }
}
