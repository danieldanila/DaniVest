import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/forgot_password_data.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/tracking/tracking_text_controller.dart';
import 'package:frontend/utilities/forms/validators/email_validator.dart';
import 'package:frontend/constants/constants.dart' as constants;

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({super.key});

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final TrackingTextController emailController = TrackingTextController();

  String? _message;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> handleForgotPassword(
    ForgotPasswordData forgotPasswordData,
  ) async {
    final userService = locator<UserService>();

    final customResponse = await userService.forgotPassword(forgotPasswordData);

    if (!mounted) return;

    setState(() {
      _message = customResponse.message;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_message!)));

    if (customResponse.success) {
      Navigator.pop(context);
    }
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
            const Text(constants.Strings.forgotMyPassword),
            TextFormField(
              enableSuggestions: false,
              controller: emailController,
              validator: emailValidator,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: constants.Strings.emailFieldLabel,
                hintText: constants.Strings.emailFieldHint,
              ),
            ),
            const SizedBox(height: constants.Properties.sizedBoxHeight),
            ElevatedButton(
              onPressed: () {
                bool isEmailValid = formKey.currentState!.validate();

                if (isEmailValid) {
                  final forgotPasswordData = ForgotPasswordData(
                    email: emailController.text,
                  );
                  handleForgotPassword(forgotPasswordData);
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
