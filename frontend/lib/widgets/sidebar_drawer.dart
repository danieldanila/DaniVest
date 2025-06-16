import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/utilities/navigation/app_navigator.dart';
import 'package:frontend/utilities/sidebar/user_logout.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Image.asset(constants.Strings.logoUrl)),
          ListTile(
            title: const Text(constants.Strings.homepagePageName),
            leading: const Icon(Icons.home),
            onTap: () {
              AppNavigator.navigateToHomepage(context);
            },
          ),
          ListTile(
            title: const Text(constants.Strings.transferPageName),
            leading: const Icon(Icons.send),
            onTap: () {
              AppNavigator.navigateToTransferPage(context);
            },
          ),
          ListTile(
            title: const Text(constants.Strings.investPageName),
            leading: const Icon(Icons.attach_money),
            onTap: () {
              AppNavigator.navigateToInvestPage(context);
            },
          ),
          ListTile(
            title: const Text(constants.Strings.transactionPageName),
            leading: const Icon(Icons.shopping_cart),
            onTap: () {
              AppNavigator.navigateToTransactionsPage(context);
            },
          ),
          ListTile(
            title: const Text(constants.Strings.myAccountPageName),
            leading: const Icon(Icons.account_box),
            onTap: () {
              AppNavigator.navigateToMyAccountPage(context);
            },
          ),
          ListTile(
            title: const Text(constants.Strings.addWithdrawMoneyPageName),
            leading: const Icon(Icons.attach_money),
            onTap: () {
              AppNavigator.navigateToAddWithdrawMoneyPage(context);
            },
          ),
          ListTile(
            title: const Text(constants.Strings.shareIbanPageName),
            leading: const Icon(Icons.share),
            onTap: () {},
          ),
          ListTile(
            title: const Text(constants.Strings.showCardDetailsPageName),
            leading: const Icon(Icons.remove_red_eye),
            onTap: () {},
          ),
          const SizedBox(height: constants.Properties.sizedBoxHeight),
          ListTile(
            title: const Text(constants.Strings.logoutButtonMessage),
            leading: const Icon(Icons.logout),
            onTap: () {
              userLogout(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(constants.Strings.successfulLogout),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
