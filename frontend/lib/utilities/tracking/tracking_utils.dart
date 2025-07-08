import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/tracking/session_counter_manager.dart';
import 'package:frontend/tracking/session_tracker.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

Future<int> getNativeDeviceOrientation() async {
  NativeDeviceOrientation nativeDeviceOrientation =
      await NativeDeviceOrientationCommunicator().orientation();

  if (nativeDeviceOrientation == NativeDeviceOrientation.portraitUp) {
    return 0;
  } else if (nativeDeviceOrientation ==
      NativeDeviceOrientation.landscapeRight) {
    return 1;
  } else if (nativeDeviceOrientation == NativeDeviceOrientation.portraitDown) {
    return 2;
  } else if (nativeDeviceOrientation == NativeDeviceOrientation.landscapeLeft) {
    return 3;
  }
  return -1;
}

Future<String> getCurrentUserId() async {
  final authService = locator<AuthService>();

  try {
    CustomResponse customResponse = await authService.getCurrentUser();

    if (customResponse.success) {
      User user = User.fromJson(customResponse.data);
      return user.id;
    }
    return "${customResponse.message}";
  } catch (e) {
    return "GetCurrentUserId error: $e";
  }
}

String uuidTo6DigitId(String uuid) {
  final bytes = utf8.encode(uuid);
  final digest = sha256.convert(bytes);

  final hashInt = digest.bytes.sublist(0, 4).fold(0, (a, b) => (a << 8) + b);

  final sixDigitId = hashInt % 1000000;

  return sixDigitId.toString().padLeft(6, '0');
}

Future<int> getActivityId(String dataCollectedName) async {
  String currentUserId = await getCurrentUserId();
  String uniqueId = uuidTo6DigitId(currentUserId);
  int currentSession = await SessionTracker.getSessionCount();
  int dataCollectedNumber = SessionCounterManager.get(dataCollectedName);

  String activityIdString =
      "$uniqueId${currentSession.toString().padLeft(2, '0')}${dataCollectedNumber.toString().padLeft(3, '0')}";
  int activityId = int.parse(activityIdString);

  return activityId;
}
