import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/conversation.dart';
import 'package:frontend/models/conversation_data.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/services/conversation_service.dart';
import 'package:frontend/tracking/tracking_text_controller.dart';
import 'package:frontend/utilities/forms/validators/message_validator.dart';
import 'package:intl/intl.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({
    super.key,
    required this.userId,
    required this.friendId,
    required this.updateGroupMapFunction,
  });

  final String userId;
  final String friendId;
  final void Function(Conversation) updateGroupMapFunction;

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final TrackingTextController messageController = TrackingTextController();

  String? _message;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> handleSendMessage(ConversationData conversationData) async {
    final conversationService = locator<ConversationService>();

    final customResponse = await conversationService.createConversation(
      conversationData,
    );

    if (!mounted) return;

    setState(() {
      _message = customResponse.message;
    });

    if (customResponse.success) {
      messageController.text = "";
      widget.updateGroupMapFunction(
        Conversation.fromJson(
          customResponse.data[constants.Strings.responseDataFieldName],
        ),
      );
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
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                enableSuggestions: false,
                controller: messageController,
                validator: messageValidator,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: constants.Strings.messageFieldLabel,
                  hintText: constants.Strings.messageFieldHint,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                bool areFieldsValidated = formKey.currentState!.validate();

                if (areFieldsValidated) {
                  final conversationData = ConversationData(
                    userId: widget.userId,
                    friendId: widget.friendId,
                    message: messageController.text,
                    datetime: DateFormat(
                      constants.Strings.dateFormat,
                    ).format(DateTime.now()),
                  );
                  handleSendMessage(conversationData);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
