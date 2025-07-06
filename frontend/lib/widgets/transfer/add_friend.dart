import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/add_new_friend_data.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/services/user_service.dart';
import 'package:frontend/tracking/tracking_text_controller.dart';
import 'package:frontend/utilities/forms/validators/email_validator.dart';
import 'package:frontend/utilities/forms/validators/phone_number_validator.dart';
import 'package:frontend/utilities/forms/validators/username_validator.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key, required this.updateFriends});
  final Future<void> Function() updateFriends;

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final GlobalKey<FormState> usernameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> phoneNumberKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailKey = GlobalKey<FormState>();

  final TrackingTextController usernameController = TrackingTextController();
  final TrackingTextController phoneNumberController = TrackingTextController();
  final TrackingTextController emailController = TrackingTextController();

  String? _message;

  @override
  void dispose() {
    usernameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> handleSaveFriend(AddNewFriendData addNewFriendData) async {
    final userService = locator<UserService>();

    final customResponse = await userService.createNewUserFriend(
      addNewFriendData,
    );

    await widget.updateFriends();

    if (!mounted) return;

    setState(() {
      _message = customResponse.message;
    });

    if (customResponse.success) {
      Navigator.pop(context);
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_message!)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: constants.Properties.containerHorizontalMargin,
        vertical: constants.Properties.containerVerticalMargin,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(constants.Strings.addNewFriendText),
          const Text(
            constants.Strings.onlyOneFieldMustBeCompletedText,
            style: TextStyle(color: Color(constants.Colors.blue)),
          ),
          Form(
            key: usernameKey,
            child: TextFormField(
              enableSuggestions: false,
              controller: usernameController,
              validator: usernameValidator,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: constants.Strings.usernameFieldLabel,
                hintText: constants.Strings.usernameFieldHint,
              ),
            ),
          ),
          Form(
            key: phoneNumberKey,
            child: TextFormField(
              controller: phoneNumberController,
              validator: phoneNumberValidator,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: constants.Strings.phoneNumberFieldLabel,
                hintText: constants.Strings.phoneNumberFieldHint,
              ),
            ),
          ),
          Form(
            key: emailKey,
            child: TextFormField(
              enableSuggestions: false,
              controller: emailController,
              validator: emailValidator,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: constants.Strings.emailFieldLabel,
                hintText: constants.Strings.emailFieldHint,
              ),
            ),
          ),
          const SizedBox(height: constants.Properties.sizedBoxHeight),
          ElevatedButton(
            onPressed: () {
              bool isUsernameValidated = usernameKey.currentState!.validate();
              bool isPhoneNumberValidated =
                  phoneNumberKey.currentState!.validate();
              bool isEmailValidated = emailKey.currentState!.validate();

              if (isUsernameValidated ||
                  isPhoneNumberValidated ||
                  isEmailValidated) {
                AddNewFriendData changeMyPasscodeData;
                if (isUsernameValidated) {
                  changeMyPasscodeData = AddNewFriendData(
                    username: usernameController.text,
                  );
                } else if (isPhoneNumberValidated) {
                  changeMyPasscodeData = AddNewFriendData(
                    phoneNumber: phoneNumberController.text,
                  );
                } else {
                  changeMyPasscodeData = AddNewFriendData(
                    email: emailController.text,
                  );
                }

                handleSaveFriend(changeMyPasscodeData);
              }
            },
            child: const Text(constants.Strings.saveButtonMessage),
          ),
        ],
      ),
    );
  }
}
