import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/bank_account.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/models/update_me.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utilities/forms/validators/email_validator.dart';
import 'package:frontend/utilities/forms/validators/first_name_validator.dart';
import 'package:frontend/utilities/forms/validators/last_name_validator.dart';
import 'package:frontend/utilities/forms/validators/phone_number_validator.dart';
import 'package:provider/provider.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<StatefulWidget> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> firstNameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> lastNameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> phoneNumberKey = GlobalKey<FormState>();

  String? _message;

  String _userIban = constants.Strings.shareIbanPageName;
  bool _isEditModeEmail = false;
  bool _isEditModeFirstName = false;
  bool _isEditModeLastName = false;
  bool _isEditModePhoneNumber = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserIban();
  }

  Future<void> fetchUserIban() async {
    final userService = locator<UserService>();

    CustomResponse customResponse = await userService.getUserBankAccount();

    if (customResponse.success) {
      final userBankAccount = BankAccount.fromJson(customResponse.data);

      setState(() {
        _userIban = userBankAccount.iban;
      });
    }
  }

  void _changeIsEditModeEmail({String currentEmail = ""}) {
    setState(() {
      _isEditModeEmail = !_isEditModeEmail;

      if (_isEditModeEmail) {
        emailController.text = currentEmail;
      }
    });
  }

  void _changeIsEditModeFirstName({String currentFirstName = ""}) {
    setState(() {
      _isEditModeFirstName = !_isEditModeFirstName;

      if (_isEditModeFirstName) {
        firstNameController.text = currentFirstName;
      }
    });
  }

  void _changeIsEditModeLastName({String currentLastName = ""}) {
    setState(() {
      _isEditModeLastName = !_isEditModeLastName;

      if (_isEditModeLastName) {
        lastNameController.text = currentLastName;
      }
    });
  }

  void _changeIsEditModePhoneNumber({String currentPhoneNumber = ""}) {
    setState(() {
      _isEditModePhoneNumber = !_isEditModePhoneNumber;

      if (_isEditModePhoneNumber) {
        phoneNumberController.text = currentPhoneNumber;
      }
    });
  }

  void handleUpdateMe(
    UpdateMeData updateMeData,
    AuthProvider authProvider,
  ) async {
    final userService = locator<UserService>();

    final customResponse = await userService.updateMe(updateMeData);

    await authProvider.updateUser();

    if (!mounted) return;

    setState(() {
      _message = customResponse.message;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_message!)));
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: constants.Properties.fontSizeMainText,
            ),
            constants.Strings.personalDetailsText,
          ),
          const Text(constants.Strings.usernameFieldLabel),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: constants.Properties.textButtonPadding,
              horizontal: constants.Properties.textButtonPadding,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(constants.Colors.black)),
            ),
            child: Text(authProvider.user!.username),
          ),
          const Text(constants.Strings.emailFieldLabel),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: constants.Properties.textButtonPadding,
                    horizontal: constants.Properties.textButtonPadding,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(constants.Colors.black),
                    ),
                  ),
                  child:
                      _isEditModeEmail
                          ? Form(
                            key: emailFormKey,
                            child: TextFormField(
                              controller: emailController,
                              validator: emailValidator,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: constants.Strings.emailFieldLabel,
                                hintText: constants.Strings.emailFieldHint,
                              ),
                            ),
                          )
                          : Text(authProvider.user!.email),
                ),
              ),
              IconButton(
                onPressed: () {
                  _changeIsEditModeEmail(
                    currentEmail: authProvider.user!.email,
                  );
                },
                icon:
                    _isEditModeEmail
                        ? const Icon(Icons.edit_off)
                        : const Icon(Icons.edit),
              ),
              if (_isEditModeEmail)
                IconButton(
                  onPressed: () {
                    bool isEmailValidated =
                        emailFormKey.currentState!.validate();

                    if (isEmailValidated) {
                      final updateMeData = UpdateMeData(
                        email: emailController.text,
                      );
                      handleUpdateMe(updateMeData, authProvider);
                      _changeIsEditModeEmail();
                    }
                  },
                  icon: const Icon(Icons.check),
                ),
            ],
          ),
          const Text(constants.Strings.firstNameFieldLabel),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: constants.Properties.textButtonPadding,
                    horizontal: constants.Properties.textButtonPadding,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(constants.Colors.black),
                    ),
                  ),
                  child:
                      _isEditModeFirstName
                          ? Form(
                            key: firstNameKey,
                            child: TextFormField(
                              controller: firstNameController,
                              validator: firstNameValidator,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                labelText:
                                    constants.Strings.firstNameFieldLabel,
                                hintText: constants.Strings.firstNameFieldHint,
                              ),
                            ),
                          )
                          : Text(authProvider.user!.firstName),
                ),
              ),
              IconButton(
                onPressed: () {
                  _changeIsEditModeFirstName(
                    currentFirstName: authProvider.user!.firstName,
                  );
                },
                icon:
                    _isEditModeFirstName
                        ? const Icon(Icons.edit_off)
                        : const Icon(Icons.edit),
              ),
              if (_isEditModeFirstName)
                IconButton(
                  onPressed: () {
                    bool isFirstNameValidated =
                        firstNameKey.currentState!.validate();

                    if (isFirstNameValidated) {
                      final updateMeData = UpdateMeData(
                        firstName: firstNameController.text,
                      );
                      handleUpdateMe(updateMeData, authProvider);
                      _changeIsEditModeFirstName();
                    }
                  },
                  icon: const Icon(Icons.check),
                ),
            ],
          ),
          const Text(constants.Strings.lastNameFieldLabel),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: constants.Properties.textButtonPadding,
                    horizontal: constants.Properties.textButtonPadding,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(constants.Colors.black),
                    ),
                  ),
                  child:
                      _isEditModeLastName
                          ? Form(
                            key: lastNameKey,
                            child: TextFormField(
                              controller: lastNameController,
                              validator: lastNameValidator,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                labelText: constants.Strings.lastNameFieldLabel,
                                hintText: constants.Strings.lastNameFieldHint,
                              ),
                            ),
                          )
                          : Text(authProvider.user!.lastName),
                ),
              ),
              IconButton(
                onPressed: () {
                  _changeIsEditModeLastName(
                    currentLastName: authProvider.user!.lastName,
                  );
                },
                icon:
                    _isEditModeLastName
                        ? const Icon(Icons.edit_off)
                        : const Icon(Icons.edit),
              ),
              if (_isEditModeLastName)
                IconButton(
                  onPressed: () {
                    bool isLastNameValidated =
                        lastNameKey.currentState!.validate();

                    if (isLastNameValidated) {
                      final updateMeData = UpdateMeData(
                        lastName: lastNameController.text,
                      );
                      handleUpdateMe(updateMeData, authProvider);
                      _changeIsEditModeLastName();
                    }
                  },
                  icon: const Icon(Icons.check),
                ),
            ],
          ),
          const Text(constants.Strings.phoneNumberFieldLabel),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: constants.Properties.textButtonPadding,
                    horizontal: constants.Properties.textButtonPadding,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(constants.Colors.black),
                    ),
                  ),
                  child:
                      _isEditModePhoneNumber
                          ? Form(
                            key: phoneNumberKey,
                            child: TextFormField(
                              controller: phoneNumberController,
                              validator: phoneNumberValidator,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                labelText:
                                    constants.Strings.phoneNumberFieldLabel,
                                hintText:
                                    constants.Strings.phoneNumberFieldLabel,
                              ),
                            ),
                          )
                          : Text(authProvider.user!.phoneNumber),
                ),
              ),
              IconButton(
                onPressed: () {
                  _changeIsEditModePhoneNumber(
                    currentPhoneNumber: authProvider.user!.phoneNumber,
                  );
                },
                icon:
                    _isEditModePhoneNumber
                        ? const Icon(Icons.edit_off)
                        : const Icon(Icons.edit),
              ),
              if (_isEditModePhoneNumber)
                IconButton(
                  onPressed: () {
                    bool isPhoneNumberValidated =
                        phoneNumberKey.currentState!.validate();

                    if (isPhoneNumberValidated) {
                      final updateMeData = UpdateMeData(
                        phoneNumber: phoneNumberController.text,
                      );
                      handleUpdateMe(updateMeData, authProvider);
                      _changeIsEditModePhoneNumber();
                    }
                  },
                  icon: const Icon(Icons.check),
                ),
            ],
          ),
          const Text(constants.Strings.birthdateFieldLabel),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: constants.Properties.textButtonPadding,
              horizontal: constants.Properties.textButtonPadding,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(constants.Colors.black)),
            ),
            child: Text(authProvider.user!.birthdate),
          ),
          const SizedBox(height: constants.Properties.sizedBoxHeight),
          const Text(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: constants.Properties.fontSizeMainText,
            ),
            constants.Strings.accountDetailsText,
          ),
          const Text(constants.Strings.ibanFieldLabel),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: constants.Properties.textButtonPadding,
                  horizontal: constants.Properties.textButtonPadding,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(constants.Colors.black),
                  ),
                ),
                child: Text(_userIban),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _userIban));
                },
                icon: const Icon(Icons.copy),
              ),
            ],
          ),

          const SizedBox(height: constants.Properties.sizedBoxHeight),
          const Text(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: constants.Properties.fontSizeMainText,
            ),
            constants.Strings.otherDetailsText,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text(constants.Strings.changePasscodeButtonText),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text(constants.Strings.changePasswordButtonText),
          ),
        ],
      ),
    );
  }
}
