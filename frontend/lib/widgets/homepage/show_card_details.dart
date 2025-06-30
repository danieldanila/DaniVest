import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/bank_account.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/constants/constants.dart' as constants;

class ShowCardDetails extends StatefulWidget {
  const ShowCardDetails({super.key, required this.onToggle});

  final VoidCallback onToggle;

  @override
  State<ShowCardDetails> createState() => _ShowCardDetailsState();
}

class _ShowCardDetailsState extends State<ShowCardDetails> {
  String _userCardNumber = constants.Strings.cardNumberTitle;
  String _userCVV = constants.Strings.cvvTitle;
  String _userExpiryDate = constants.Strings.expiryDateTitle;

  late Timer _timer;
  int _remainingSeconds = constants.Properties.timerSeconds * 60;

  @override
  void initState() {
    super.initState();
    fetchUserCardDetails();
    startTimer();
  }

  Future<void> fetchUserCardDetails() async {
    final userService = locator<UserService>();

    CustomResponse customResponse = await userService.getUserBankAccount();

    if (customResponse.success) {
      final userBankAccount = BankAccount.fromJson(customResponse.data);

      setState(() {
        _userCardNumber = userBankAccount.cardNumber;
        _userCVV = userBankAccount.cvv;
        _userExpiryDate = userBankAccount.expiryDate;
      });
    }
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: constants.Properties.timerSeconds),
      (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          timer.cancel();
          widget.onToggle();
        }
      },
    );
  }

  String formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(1, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(formatTime(_remainingSeconds)),
            IconButton(
              onPressed: widget.onToggle,
              icon: const Icon(Icons.visibility_off),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    const Text(constants.Strings.cardNumberTitle),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _userCardNumber));
                      },
                      icon: const Icon(Icons.copy),
                      iconSize: constants.Properties.iconSize,
                    ),
                  ],
                ),
                Text(_userCardNumber),
              ],
            ),
            Column(
              children: [
                const Text(constants.Strings.cvvTitle),
                Text(_userCVV),
              ],
            ),
            Column(
              children: [
                const Text(constants.Strings.expiryDateTitle),
                Text(_userExpiryDate),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _userCardNumber));
              },
              child: const Row(
                children: [
                  Text(constants.Strings.copyCardNumberTitle),
                  SizedBox(width: constants.Properties.sizedBoxWidth),
                  Icon(Icons.copy),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
