import 'package:flutter/material.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/utilities/forms/screen_lock.dart';
import 'package:frontend/utilities/navigation/app_navigator.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/widgets/homepage/amount_display.dart';
import 'package:frontend/widgets/homepage/fast_actions.dart';
import 'package:frontend/widgets/homepage/show_card_details.dart';
import 'package:frontend/widgets/homepage/transactions_preview.dart';
import 'package:provider/provider.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key, this.showCardDetails = false});

  final bool showCardDetails;

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  late AuthProvider authProvider;
  late bool _showCardDetails;

  @override
  void initState() {
    super.initState();

    _showCardDetails = widget.showCardDetails;

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
  void didUpdateWidget(covariant HomepageScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_showCardDetails != widget.showCardDetails) {
      setState(() {
        _showCardDetails = widget.showCardDetails;
      });
    }
  }

  void _toggleShowCardDetails() {
    setState(() {
      _showCardDetails = !_showCardDetails;
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              _showCardDetails
                  ? ShowCardDetails(onToggle: _toggleShowCardDetails)
                  : const AmountDisplay(),
              const SizedBox(height: constants.Properties.sizedBoxHeight),
              const TransactionsPreview(),
              const SizedBox(height: constants.Properties.sizedBoxHeight),
              const FastActions(),
              const SizedBox(height: constants.Properties.sizedBoxHeight),
              const Text(constants.Strings.endOfPage),
              const SizedBox(height: constants.Properties.sizedBoxHeight),
              const Text(constants.Strings.endOfPage),
            ],
          ),
        ),
      ),
    );
  }
}
