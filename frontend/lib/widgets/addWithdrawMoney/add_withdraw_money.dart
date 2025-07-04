import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/bank_account.dart';
import 'package:frontend/models/change_other_account_data.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/models/transaction_data.dart';
import 'package:frontend/services/transaction_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utilities/forms/validators/amount_validator.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/widgets/addWithdrawMoney/change_other_account.dart';
import 'package:intl/intl.dart';

class AddWithdrawMoney extends StatefulWidget {
  const AddWithdrawMoney({super.key});

  @override
  State<StatefulWidget> createState() => _AddWithDrawMoneyState();
}

class _AddWithDrawMoneyState extends State<AddWithdrawMoney> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late BankAccount _bankAccount;
  late BankAccount _otherBankAccount;

  bool _isBankAccountTheReceiver = true;
  ChangeOtherAccountData? _changeOtherAccountData;
  String? _message;
  bool _isLoading = true;

  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await fetchUserBankAccount();
    await fetchUserOtherBankAccount(_changeOtherAccountData);

    setState(() {
      _isLoading = false;
    });
  }

  void changeReceiverAccount() {
    setState(() {
      _isBankAccountTheReceiver = !_isBankAccountTheReceiver;
    });
  }

  Future<void> updateChangeOtherAccountData(
    ChangeOtherAccountData? changeOtherAccountData,
  ) async {
    setState(() {
      _changeOtherAccountData = changeOtherAccountData;
    });
    await fetchUserOtherBankAccount(_changeOtherAccountData);
  }

  Future<void> fetchUserBankAccount() async {
    final userService = locator<UserService>();

    CustomResponse customResponse = await userService.getUserBankAccount();

    if (customResponse.success) {
      final userBankAccount = BankAccount.fromJson(customResponse.data);

      setState(() {
        _bankAccount = userBankAccount;
      });
    }
  }

  Future<void> fetchUserOtherBankAccount(
    ChangeOtherAccountData? changeOtherAccountData,
  ) async {
    final userService = locator<UserService>();

    CustomResponse customResponse = await userService.getUserOtherBankAccount(
      changeOtherAccountData,
    );

    if (customResponse.success) {
      final userOtherBankAccount = BankAccount.fromJson(customResponse.data);

      setState(() {
        _otherBankAccount = userOtherBankAccount;
      });
    }
  }

  Future<void> handleTransfer(TransactionData transactionData) async {
    final transactionService = locator<TransactionService>();

    final customResponse = await transactionService.createTransaction(
      transactionData,
    );
    await fetchUserBankAccount();

    if (!mounted) return;

    setState(() {
      _message = customResponse.message;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_message!)));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.account_balance),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(constants.Strings.otherAccountText),
                  Text(
                    "${constants.Strings.obscuredText}${_otherBankAccount.cardNumber.substring(_bankAccount.cardNumber.length - 4)} ${_otherBankAccount.expiryDate.substring(_bankAccount.expiryDate.length - 5)}",
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: ChangeOtherAccount(
                            updateChangeOtherAccountData:
                                updateChangeOtherAccountData,
                          ),
                        ),
                      );
                    },
                  );
                },
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(
                      horizontal: constants.Properties.textButtonPadding,
                    ),
                  ),
                ),
                child: const Text(constants.Strings.changeButtonMessage),
              ),
            ],
          ),
          IconButton(
            onPressed: changeReceiverAccount,
            icon:
                _isBankAccountTheReceiver
                    ? const Icon(Icons.arrow_downward)
                    : const Icon(Icons.arrow_upward),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.account_balance),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(constants.Strings.myAccountText),
                  Text(
                    "${constants.Strings.balanceText} ${_bankAccount.amount}",
                  ),
                ],
              ),
              SizedBox(
                width: constants.Properties.amountFieldWidth,
                child: TextFormField(
                  controller: amountController,
                  validator: amountValidator,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: constants.Strings.amountFieldLabel,
                    hintText: constants.Strings.amountFieldHint,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: constants.Properties.sizedBoxHeight),
          Row(
            children: [
              const Icon(Icons.info),
              const SizedBox(width: constants.Properties.sizedBoxWidth),
              Expanded(
                child: Text(
                  "${amountController.text} ${_isBankAccountTheReceiver ? constants.Strings.transferInformation.replaceAll(":first", constants.Strings.otherAccountText).replaceAll(":second", constants.Strings.myAccountText) : constants.Strings.transferInformation.replaceAll(":first", constants.Strings.myAccountText).replaceAll(":second", constants.Strings.otherAccountText)}",
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: changeReceiverAccount,
            child: const Text(
              constants.Strings.changeTransferDirectionButtonMessage,
            ),
          ),
          const SizedBox(height: constants.Properties.sizedBoxHeight),
          ElevatedButton(
            onPressed: () async {
              bool areFieldsValidated = formKey.currentState!.validate();
              if (areFieldsValidated) {
                final transactionData = TransactionData(
                  amount: amountController.text,
                  datetime: DateFormat(
                    constants.Strings.dateFormat,
                  ).format(DateTime.now()),
                  details: constants.Strings.bankTransferText,
                  isApproved: true,
                  receiverBankAccountId:
                      _isBankAccountTheReceiver
                          ? _bankAccount.id
                          : _otherBankAccount.id,
                  senderBankAccountId:
                      _isBankAccountTheReceiver
                          ? _otherBankAccount.id
                          : _bankAccount.id,
                );
                await handleTransfer(transactionData);
              }
            },
            child: const Text(constants.Strings.transferText),
          ),
        ],
      ),
    );
  }
}
