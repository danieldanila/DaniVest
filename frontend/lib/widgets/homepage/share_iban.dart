import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/bank_account.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:share_plus/share_plus.dart';

class ShareIban extends StatefulWidget {
  const ShareIban({super.key});

  @override
  State<ShareIban> createState() => _ShareIbanState();
}

class _ShareIbanState extends State<ShareIban> {
  String _userIban = constants.Strings.shareIbanPageName;

  @override
  void initState() {
    super.initState();
    fetchUserIban();
  }

  Future<void> fetchUserIban() async {
    final userService = locator<UserService>();

    CustomResponse customResponse = await userService.getUserBankAccount();

    if (customResponse.success) {
      final userBankAccount = BankAccount.fromJson(customResponse.data);

      setState(() {
        _userIban = userBankAccount.iban;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: constants.Properties.containerHorizontalMargin,
        vertical: constants.Properties.containerVerticalMargin,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_userIban),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _userIban));
                },
                icon: const Icon(Icons.copy),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              SharePlus.instance.share(ShareParams(text: _userIban));
            },
            child: const Text(constants.Strings.shareToOhterApps),
          ),
        ],
      ),
    );
  }
}
