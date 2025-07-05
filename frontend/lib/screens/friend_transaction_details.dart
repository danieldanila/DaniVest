import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/conversation.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/models/friend.dart';
import 'package:frontend/models/transaction.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/widgets/transfer/send_message.dart';
import 'package:frontend/widgets/transfer/send_money.dart';
import 'package:provider/provider.dart';

class FriendTransactionDetailsScreen extends StatefulWidget {
  const FriendTransactionDetailsScreen({
    super.key,
    required this.friend,
    required this.friendTransactions,
  });

  final Friend friend;
  final List<Transaction> friendTransactions;

  @override
  State<FriendTransactionDetailsScreen> createState() =>
      _FriendTransactionDetailsScreenState();
}

class _FriendTransactionDetailsScreenState
    extends State<FriendTransactionDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  List<Conversation> _conversations = [];

  Map<String, List<dynamic>> _groupTransactionsAndConversationsByDatetime = {};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await fetchConversations();
    groupTransactionsAndConversationsByDatetime();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    setState(() {
      _isLoading = false;
    });
  }

  void updateGroupMapWithTransaction(Transaction transaction) {
    setState(() {
      _groupTransactionsAndConversationsByDatetime
          .putIfAbsent(transaction.datetime.split("T")[0], () => [])
          .add({
            "type": "transaction",
            "sender": transaction.senderId,
            "datetime":
                DateTime.parse(
                  transaction.datetime,
                ).toLocal().toIso8601String(),
            "date":
                DateTime.parse(
                  transaction.datetime,
                ).toLocal().toIso8601String().split('T')[0],
            "time":
                DateTime.parse(
                  transaction.datetime,
                ).toLocal().toIso8601String().split('T')[1],
            "data": transaction,
          });
    });
  }

  void updateGroupMapWithConversation(Conversation conversation) {
    setState(() {
      _groupTransactionsAndConversationsByDatetime
          .putIfAbsent(conversation.datetime.split("T")[0], () => [])
          .add({
            "type": "conversation",
            "sender": conversation.senderUserId,
            "datetime":
                DateTime.parse(
                  conversation.datetime,
                ).toLocal().toIso8601String(),
            "date":
                DateTime.parse(
                  conversation.datetime,
                ).toLocal().toIso8601String().split('T')[0],
            "time":
                DateTime.parse(
                  conversation.datetime,
                ).toLocal().toIso8601String().split('T')[1],
            "data": conversation,
          });
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Future<void> fetchConversations() async {
    final userService = locator<UserService>();

    CustomResponse customResponse = await userService.getUserAllConversations();

    if (customResponse.success) {
      List<Conversation> conversations = [];
      for (dynamic data in customResponse.data) {
        Conversation conversation = Conversation.fromJson(data);
        conversations.add(conversation);
      }
      conversations = List.from(
        conversations
            .where(
              (conversation) =>
                  conversation.userId == widget.friend.friendId ||
                  conversation.friendId == widget.friend.friendId,
            )
            .toList(),
      );
      conversations.sort(
        (a, b) =>
            DateTime.parse(b.datetime).compareTo(DateTime.parse(a.datetime)),
      );

      setState(() {
        _conversations = List.from(conversations);
      });
    }
  }

  void groupTransactionsAndConversationsByDatetime() {
    final List<Map<String, dynamic>> allItems = [];

    for (final transaction in widget.friendTransactions) {
      allItems.add({
        "type": "transaction",
        "sender": transaction.senderId,
        "datetime":
            DateTime.parse(transaction.datetime).toLocal().toIso8601String(),
        "date":
            DateTime.parse(
              transaction.datetime,
            ).toLocal().toIso8601String().split('T')[0],
        "time":
            DateTime.parse(
              transaction.datetime,
            ).toLocal().toIso8601String().split('T')[1],
        "data": transaction,
      });
    }

    for (final conversation in _conversations) {
      allItems.add({
        "type": "conversation",
        "sender": conversation.senderUserId,
        "datetime":
            DateTime.parse(conversation.datetime).toLocal().toIso8601String(),
        "date":
            DateTime.parse(
              conversation.datetime,
            ).toLocal().toIso8601String().split('T')[0],
        "time":
            DateTime.parse(
              conversation.datetime,
            ).toLocal().toIso8601String().split('T')[1],
        "data": conversation,
      });
    }

    allItems.sort((a, b) => a["datetime"].compareTo(b["datetime"]));

    final Map<String, List<dynamic>> grouped = {};
    for (final item in allItems) {
      grouped.putIfAbsent(item["date"], () => []).add(item);
    }

    setState(() {
      _groupTransactionsAndConversationsByDatetime = grouped;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.friend.friendName)),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: constants.Properties.containerHorizontalMargin,
          vertical: constants.Properties.containerVerticalMargin,
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person,
                    size: constants.Properties.largeIconSize,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.friend.friendName),
                      Text(
                        "${constants.Strings.friendSinceText} ${widget.friend.since}",
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children:
                    _groupTransactionsAndConversationsByDatetime.entries.map((
                      entry,
                    ) {
                      final date = entry.key;
                      final items = entry.value;

                      return Padding(
                        padding: const EdgeInsets.all(
                          constants.Properties.rowPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: constants.Properties.fontSizeMainText,
                              ),
                              date,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Align(
                                  alignment:
                                      item["sender"] == authProvider.user!.id
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    padding: const EdgeInsets.symmetric(
                                      vertical:
                                          constants
                                              .Properties
                                              .textButtonPadding,
                                      horizontal:
                                          constants
                                              .Properties
                                              .textButtonPadding,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      vertical:
                                          constants
                                              .Properties
                                              .listVerticalMargin,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(
                                          constants.Colors.black,
                                        ),
                                      ),
                                    ),
                                    child:
                                        item["type"] == "transaction"
                                            ? Column(
                                              children: [
                                                Text(
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        constants
                                                            .Properties
                                                            .fontSizeMediumText,
                                                  ),
                                                  "${item["data"].amount} ${constants.Strings.defaultCurrency}",
                                                ),
                                                Text(item["data"].details),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    style: const TextStyle(
                                                      fontSize:
                                                          constants
                                                              .Properties
                                                              .fonstSizeSmallText,
                                                    ),
                                                    item["time"]
                                                        .toString()
                                                        .substring(0, 5),
                                                  ),
                                                ),
                                              ],
                                            )
                                            : Column(
                                              children: [
                                                Text(item["data"].message),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    style: const TextStyle(
                                                      fontSize:
                                                          constants
                                                              .Properties
                                                              .fonstSizeSmallText,
                                                    ),
                                                    item["time"]
                                                        .toString()
                                                        .substring(0, 5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
              SendMessage(
                userId: authProvider.user!.id,
                friendId: widget.friend.friendId,
                updateGroupMapFunction: updateGroupMapWithConversation,
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
                          child: SendMoney(
                            userId: authProvider.user!.id,
                            friendId: widget.friend.friendId,
                            updateGroupMapFunction:
                                updateGroupMapWithTransaction,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text(constants.Strings.sendButtonMessage),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
