import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/change_other_account_data.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/tracking/tracking_text_controller.dart';
import 'package:frontend/utilities/forms/validators/card_number_validator.dart';
import 'package:frontend/utilities/forms/validators/cvv_validator.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/utilities/forms/validators/expiry_date_validator.dart';

class ChangeOtherAccount extends StatefulWidget {
  const ChangeOtherAccount({
    super.key,
    required this.updateChangeOtherAccountData,
  });

  final Future<void> Function(ChangeOtherAccountData)
  updateChangeOtherAccountData;

  @override
  State<ChangeOtherAccount> createState() => _ChangeOtherAccountState();
}

class _ChangeOtherAccountState extends State<ChangeOtherAccount> {
  final TrackingTextController cardNumberController = TrackingTextController();
  final TrackingTextController expiryDateController = TrackingTextController();
  final TrackingTextController cvvController = TrackingTextController();

  String? _message;

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  Future<void> handleChangeOtherAccount(
    ChangeOtherAccountData changeOtherAccountData,
  ) async {
    final userService = locator<UserService>();

    final customResponse = await userService.getUserOtherBankAccount(
      changeOtherAccountData,
    );

    if (customResponse.success) {
      await widget.updateChangeOtherAccountData(changeOtherAccountData);
    }

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
            const Text(constants.Strings.changeOtherAccount),
            TextFormField(
              enableSuggestions: false,
              controller: cardNumberController,
              validator: cardNumberValidator,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: constants.Strings.cardNumberFieldLabel,
                hintText: constants.Strings.cardNumberFieldHint,
              ),
            ),
            TextFormField(
              enableSuggestions: false,
              controller: expiryDateController,
              validator: expiryDateValidator,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: constants.Strings.expiryDateFieldLabel,
                hintText: constants.Strings.expiryDateFieldHint,
              ),
            ),
            TextFormField(
              enableSuggestions: false,
              controller: cvvController,
              validator: cvvValidator,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: constants.Strings.cvvFieldLabel,
                hintText: constants.Strings.cvvFieldHint,
              ),
            ),
            const SizedBox(height: constants.Properties.sizedBoxHeight),
            ElevatedButton(
              onPressed: () {
                bool areFieldsValidated = formKey.currentState!.validate();

                if (areFieldsValidated) {
                  final changeOtherAccountData = ChangeOtherAccountData(
                    cardNumber: cardNumberController.text,
                    expiryDate: expiryDateController.text,
                    cvv: cvvController.text,
                  );
                  handleChangeOtherAccount(changeOtherAccountData);
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
