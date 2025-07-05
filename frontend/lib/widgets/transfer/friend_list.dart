import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/models/friend.dart';
import 'package:frontend/models/transaction.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utilities/navigation/app_navigator.dart';
import 'package:frontend/widgets/transfer/add_friend.dart';
import 'package:provider/provider.dart';

class FriendList extends StatefulWidget {
  const FriendList({super.key});

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  List<Transaction> _transactions = [];
  List<Friend> _friends = [];

  Map<Friend, List<Transaction>> _groupTransactionsByFriend = {};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await fetchTransactions();
    await fetchFriends();
    groupTransactionsByFriend();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> fetchFriends() async {
    final userService = locator<UserService>();

    CustomResponse customResponse = await userService.getUserAllFriends();

    if (customResponse.success) {
      List<Friend> friends = [];
      for (dynamic data in customResponse.data) {
        Friend friend = Friend.fromJson(data);
        friends.add(friend);
      }
      friends.sort((a, b) => b.since.compareTo(a.since));

      setState(() {
        _friends = List.from(friends);
      });
    }
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

  void groupTransactionsByFriend() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final Map<Friend, List<Transaction>> grouped = {};

    for (Transaction transaction in _transactions) {
      final isSender = transaction.senderId == authProvider.user!.id;
      final isReceiver = transaction.receiverId == authProvider.user!.id;

      if (!isSender && !isReceiver) continue;

      bool isFriend;
      Friend friend;

      if (isSender) {
        isFriend = _friends.any(
          (friend) => friend.friendId == transaction.receiverId,
        );

        if (isFriend) {
          friend = _friends.firstWhere(
            (friend) => friend.friendId == transaction.receiverId,
          );
        } else {
          continue;
        }
      } else {
        isFriend = _friends.any(
          (friend) => friend.friendId == transaction.senderId,
        );

        if (isFriend) {
          friend = _friends.firstWhere(
            (friend) => friend.friendId == transaction.senderId,
          );
        } else {
          continue;
        }
      }

      grouped.putIfAbsent(friend, () => []).add(transaction);
    }

    for (final friend in _friends) {
      grouped.putIfAbsent(friend, () => []);
    }

    setState(() {
      _groupTransactionsByFriend = Map.from(grouped);
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
        children: [
          const Text(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: constants.Properties.fontSizeMainText,
            ),
            constants.Strings.friendsTitle,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                _groupTransactionsByFriend.entries.map((entry) {
                  final friend = entry.key;
                  final transactions = entry.value;

                  return GestureDetector(
                    onTap: () {
                      AppNavigator.navigateToFriendTransactionDetailsPage(
                        context,
                        friend,
                        transactions,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(
                        constants.Properties.rowPadding,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.person),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(friend.friendName),
                              Text(
                                transactions.isNotEmpty
                                    ? "${((authProvider.user!.id == transactions[0].receiverId || transactions[0].senderId == transactions[0].receiverId) ? constants.Strings.sentYouText : constants.Strings.youSentText)} ${transactions[0].formattedAmount} ${constants.Strings.defaultCurrency}"
                                    : constants.Strings.noActivityRecordedText,
                              ),
                            ],
                          ),
                          Text(
                            transactions.isNotEmpty
                                ? transactions[0].formattedOnlyDate
                                : constants.Strings.noneText,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
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
                      child: AddFriend(updateFriends: _initData),
                    ),
                  );
                },
              );
            },
            child: const Text(constants.Strings.addFriendButtonText),
          ),
        ],
      ),
    );
  }
}
