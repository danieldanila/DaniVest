import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/models/transaction.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/services/user_service.dart';
import 'package:provider/provider.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({super.key});

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  List<Transaction> _transactions = [];
  Map<String, List<Transaction>> _groupedTransactions = {};
  Map<String, double> _dailyTotals = {};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await fetchTransactions();
    groupTransactions();

    setState(() {
      _isLoading = false;
    });
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

  void groupTransactions() {
    Map<String, List<Transaction>> groupedTransactions = {};
    Map<String, double> dailyTotals = {};
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    for (var transaction in _transactions) {
      final dateKey = transaction.formattedOnlyDate;
      groupedTransactions.putIfAbsent(dateKey, () => []).add(transaction);

      final amount = double.tryParse(transaction.amount) ?? 0;

      final isReceiver =
          (authProvider.user!.id == transaction.receiverId ||
              transaction.senderId == transaction.receiverId);

      final adjustedAmount = isReceiver ? amount : -amount;

      dailyTotals.update(
        dateKey,
        (existing) => existing + adjustedAmount,
        ifAbsent: () => adjustedAmount,
      );
    }
    setState(() {
      _groupedTransactions = Map.from(groupedTransactions);
      _dailyTotals = Map.from(dailyTotals);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            _groupedTransactions.entries.map((entry) {
              final date = entry.key;
              final transactions = entry.value;
              final total =
                  _dailyTotals[date]?.toStringAsFixed(2) ??
                  constants.Strings.defaultAmount;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: constants.Properties.fontSizeMainText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$total ${constants.Strings.defaultCurrency}",
                        style: const TextStyle(
                          fontSize: constants.Properties.fontSizeMainText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  ...transactions.map(
                    (transaction) => Container(
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
                              Text(transaction.receiverName),
                              Text(transaction.formattedDate),
                            ],
                          ),
                          Text(
                            "${((authProvider.user!.id == transaction.receiverId || transaction.senderId == transaction.receiverId) ? "+" : "-")} ${transaction.formattedAmount} ${constants.Strings.defaultCurrency}",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}
