import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/key_press_event.dart';
import 'package:frontend/services/tracking_events_service.dart';
import 'package:frontend/tracking/session_counter_manager.dart';
import 'package:frontend/utilities/tracking/tracking_utils.dart';

Future<void> processKeyPressEvent(int keyId, String eventType) async {
  final KeyPressEvent keyPressEvent = await createKeyPressEvent(
    keyId,
    eventType,
  );
  await handleKeyPressEvent(keyPressEvent);
}

Future<KeyPressEvent> createKeyPressEvent(int keyId, String eventType) async {
  int epochMillis = DateTime.now().millisecondsSinceEpoch;
  int pressType = eventType == "down" ? 0 : 1;
  int phoneOrientation = await getNativeDeviceOrientation();
  int activityId = await getActivityId("key");

  if (pressType == 1) {
    SessionCounterManager.increment("key");
  }

  return KeyPressEvent(
    SYSTIME: epochMillis,
    PRESSTIME: epochMillis - constants.Properties.appStartEpochMillis,
    ACTIVITYID: activityId,
    PRESSTYPE: pressType,
    KEYID: keyId,
    PHONE_ORIENTATION: phoneOrientation,
  );
}

Future<void> handleKeyPressEvent(KeyPressEvent keyPressEvent) async {
  final trackingEventsService = locator<TrackingEventsService>();

  final customResponse = await trackingEventsService.createKeyPressEvent(
    keyPressEvent,
  );

  if (customResponse.success) {
    print(customResponse.message);
  }
}
