import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/bank_account.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/models/transaction.dart';
import 'package:frontend/models/transaction_data.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/services/transaction_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/tracking/tracking_text_controller.dart';
import 'package:frontend/utilities/forms/validators/amount_validator.dart';
import 'package:frontend/utilities/forms/validators/details_validator.dart';
import 'package:intl/intl.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({
    super.key,
    required this.userId,
    required this.friendId,
    required this.updateGroupMapFunction,
  });

  final String userId;
  final String friendId;
  final void Function(Transaction) updateGroupMapFunction;

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  late BankAccount _userBankAccount;
  late BankAccount _friendBankAccount;

  final TrackingTextController amountController = TrackingTextController();
  final TrackingTextController detailsController = TrackingTextController();

  String? _message;

  @override
  void initState() {
    super.initState();
    fetchMainBankAccounts();
  }

  @override
  void dispose() {
    amountController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  Future<void> fetchMainBankAccounts() async {
    final userService = locator<UserService>();

    CustomResponse customResponse = await userService.getUserBankAccount();

    if (customResponse.success) {
      final userBankAccount = BankAccount.fromJson(customResponse.data);

      setState(() {
        _userBankAccount = userBankAccount;
      });
    }

    customResponse = await userService.getUserBankAccount(
      userId: widget.friendId,
    );

    if (customResponse.success) {
      final friendBankAccount = BankAccount.fromJson(customResponse.data);

      setState(() {
        _friendBankAccount = friendBankAccount;
      });
    }
  }

  Future<void> handleSendMoney(TransactionData transactionData) async {
    final transactionService = locator<TransactionService>();

    final customResponse = await transactionService.createTransaction(
      transactionData,
    );

    if (!mounted) return;

    setState(() {
      _message = customResponse.message;
    });

    if (customResponse.success) {
      widget.updateGroupMapFunction(
        Transaction.fromJson(
          customResponse.data[constants.Strings.responseDataFieldName],
        ),
      );

      Navigator.pop(context);
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_message!)));
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: constants.Properties.containerHorizontalMargin,
          vertical: constants.Properties.containerVerticalMargin,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(constants.Strings.sendMoneyText),
            TextFormField(
              controller: amountController,
              validator: amountValidator,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: constants.Strings.amountFieldLabel,
                hintText: constants.Strings.amountFieldHint,
              ),
            ),
            TextFormField(
              enableSuggestions: false,
              controller: detailsController,
              validator: detailsValidator,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: constants.Strings.detailsFieldLabel,
                hintText: constants.Strings.detailsFieldHint,
              ),
            ),
            const SizedBox(height: constants.Properties.sizedBoxHeight),
            ElevatedButton(
              onPressed: () {
                bool areFieldsValidated = formKey.currentState!.validate();

                if (areFieldsValidated) {
                  final transactionData = TransactionData(
                    amount: amountController.text,
                    datetime: DateFormat(
                      constants.Strings.dateFormat,
                    ).format(DateTime.now()),
                    details: detailsController.text,
                    isApproved: true,
                    senderBankAccountId: _userBankAccount.id,
                    receiverBankAccountId: _friendBankAccount.id,
                  );
                  handleSendMoney(transactionData);
                }
              },
              child: const Text(constants.Strings.sendButtonMessage),
            ),
          ],
        ),
      ),
    );
  }
}
