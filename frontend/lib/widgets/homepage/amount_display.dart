import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/bank_account.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/services/user_service.dart';

class AmountDisplay extends StatefulWidget {
  const AmountDisplay({super.key});

  @override
  State<AmountDisplay> createState() => _AmountDisplayState();
}

class _AmountDisplayState extends State<AmountDisplay> {
  bool _obscureAmount = true;
  String _userAmount = constants.Strings.defaultAmount;

  @override
  void initState() {
    super.initState();
    fetchUserAmount();
  }

  Future<void> fetchUserAmount() async {
    final userService = locator<UserService>();

    CustomResponse customResponse = await userService.getUserBankAccount();

    if (customResponse.success) {
      final userBankAccount = BankAccount.fromJson(customResponse.data);

      setState(() {
        _userAmount =
            "${userBankAccount.amount} ${constants.Strings.defaultCurrency}";
      });
    }
  }

  void _changeAmountVisibility() {
    setState(() {
      _obscureAmount = !_obscureAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            _obscureAmount ? constants.Strings.amountObscured : _userAmount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: constants.Properties.fontSizeMainTitle,
            ),
          ),
          TextButton(
            onPressed: _changeAmountVisibility,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  _obscureAmount
                      ? constants.Strings.showTheAmount
                      : constants.Strings.hideTheAmount,
                ),
                const SizedBox(width: constants.Properties.sizedBoxWidth),
                Icon(_obscureAmount ? Icons.visibility : Icons.visibility_off),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
