import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/utilities/navigation/app_navigator.dart';

class NavigationBottomBar extends StatefulWidget {
  const NavigationBottomBar({super.key});

  @override
  State<NavigationBottomBar> createState() => _NavigationBottomBarState();
}

class _NavigationBottomBarState extends State<NavigationBottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        AppNavigator.navigateToHomepage(context);
        break;
      case 1:
        AppNavigator.navigateToTransferPage(context);
        break;
      case 2:
        AppNavigator.navigateToAddWithdrawMoneyPage(context);
        break;
      case 3:
        AppNavigator.navigateToTransactionsPage(context);
        break;
      case 4:
        AppNavigator.navigateToMyAccountPage(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: constants.Strings.homepagePageName,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.send),
          label: constants.Strings.transferPageName,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: constants.Strings.addWithdrawMoneyPageName,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: constants.Strings.transactionPageName,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          label: constants.Strings.myAccountPageName,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: const Color(constants.Colors.orange),
      unselectedItemColor: const Color(constants.Colors.black),
      onTap: (int index) {
        _onItemTapped(index, context);
      },
    );
  }
}
