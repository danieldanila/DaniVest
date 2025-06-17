import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/models/login_passcode_data.dart';
import 'package:frontend/models/patch_passcode.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:provider/provider.dart';

void passcodeSetup(BuildContext context) {
  final userService = locator<UserService>();

  screenLockCreate(
    context: context,
    onConfirmed: (passcode) async {
      final patchPasscode = PatchPasscode(passcode: passcode);
      await userService.setPasscode(patchPasscode);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    },
  );
}

void passcodeCheck(BuildContext context) {
  final authService = locator<AuthService>();

  screenLock(
    context: context,
    title: const Text("Enter your passcode"),
    correctString: "9999",
    canCancel: false,
    onValidate: (passcode) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final loginPasscodeData = LoginPasscodeData(
        username: authProvider.user!.username,
        passcode: passcode,
      );

      CustomResponse customResponse = await authService.checkPasscode(
        loginPasscodeData,
      );

      return customResponse.success;
    },
  );
}
