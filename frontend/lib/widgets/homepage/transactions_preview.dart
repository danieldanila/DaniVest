import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/models/transaction.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utilities/navigation/app_navigator.dart';

class TransactionsPreview extends StatefulWidget {
  const TransactionsPreview({super.key});

  @override
  State<TransactionsPreview> createState() => _TransactionsPreviewState();
}

class _TransactionsPreviewState extends State<TransactionsPreview> {
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final userService = locator<UserService>();

    CustomResponse customResponse = await userService.getUserAllTransactions();

    if (customResponse.success) {
      List<Transaction> transactions = [];
      for (dynamic data in customResponse.data) {
        Transaction transaction = Transaction.fromJson(data);
        transactions.add(transaction);
      }
      transactions.sort((a, b) => b.parsedDateTime.compareTo(a.parsedDateTime));

      setState(() {
        _transactions = List.from(transactions);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_transactions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(constants.Colors.black)),
      );
    }
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount:
              _transactions.length >
                      constants.Properties.maximumListPreviewNumber
                  ? constants.Properties.maximumListPreviewNumber
                  : _transactions.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(
                vertical: constants.Properties.columnSpacing,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.person),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_transactions[index].receiverName),
                      Text(_transactions[index].formattedDate),
                    ],
                  ),
                  Text(
                    "-${_transactions[index].formattedAmount} ${constants.Strings.defaultCurrency}",
                  ),
                ],
              ),
            );
          },
        ),
        TextButton(
          onPressed: () {
            AppNavigator.replaceToMainNavigationPage(
              context,
              initialIndex: constants.Properties.transactionPageIndex,
            );
          },
          child: const Text(constants.Strings.seeAllTransactions),
        ),
      ],
    );
  }
}
