import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/screens/add_withdraw_money.dart';
import 'package:frontend/screens/homepage.dart';
import 'package:frontend/screens/my_account.dart';
import 'package:frontend/screens/transactions.dart';
import 'package:frontend/screens/transfer.dart';
import 'package:frontend/utilities/sidebar/user_logout.dart';
import 'package:frontend/widgets/app_bar_title.dart';
import 'package:frontend/widgets/homepage/share_iban.dart';

class FullNavigation extends StatefulWidget {
  const FullNavigation({
    super.key,
    this.initialIndex = 0,
    this.homepageShowCardDetails = false,
  });

  final int initialIndex;
  final bool homepageShowCardDetails;

  @override
  State<FullNavigation> createState() => _FullNavigationState();
}

class _FullNavigationState extends State<FullNavigation> {
  late int _selectedIndex;
  late bool _homepageShowCardDetails;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _homepageShowCardDetails = widget.homepageShowCardDetails;

    _pages = _buildPages();
  }

  List<Widget> _buildPages() => [
    HomepageScreen(showCardDetails: _homepageShowCardDetails),
    const TransferScreen(),
    const AddWithdrawMoneyScreen(),
    const TransactionsScreen(),
    const MyAccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          text: constants.Strings.homepageAppBarTitle,
          primaryTextStartPosition: 0,
          primaryTextEndPosition: 1,
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Image.asset(constants.Strings.logoUrl)),
            ListTile(
              title: const Text(constants.Strings.homepagePageName),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            ListTile(
              title: const Text(constants.Strings.transferPageName),
              leading: const Icon(Icons.send),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            ListTile(
              title: const Text(constants.Strings.addWithdrawMoneyPageName),
              leading: const Icon(Icons.attach_money),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            ListTile(
              title: const Text(constants.Strings.transactionPageName),
              leading: const Icon(Icons.shopping_cart),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 3;
                });
              },
            ),
            ListTile(
              title: const Text(constants.Strings.myAccountPageName),
              leading: const Icon(Icons.account_box),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 4;
                });
              },
            ),
            ListTile(
              title: const Text(constants.Strings.shareIbanPageName),
              leading: const Icon(Icons.share),
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const ShareIban();
                  },
                );
              },
            ),
            ListTile(
              title: const Text(constants.Strings.showCardDetailsPageName),
              leading: const Icon(Icons.visibility),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _homepageShowCardDetails = true;
                  _pages = _buildPages();
                });
              },
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(constants.Colors.orange),
        unselectedItemColor: const Color(constants.Colors.black),
        items: const [
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
      ),
    );
  }
}
