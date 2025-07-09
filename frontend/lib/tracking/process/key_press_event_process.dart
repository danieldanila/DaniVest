import 'dart:async';

import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/key_press_event.dart';
import 'package:frontend/services/tracking_events_service.dart';
import 'package:frontend/tracking/session_counter_manager.dart';
import 'package:frontend/utilities/tracking/tracking_utils.dart';

List<KeyPressEvent> _keyPressEventBuffer = [];
Timer? _keyInactivityFlushTimer;

Future<void> processKeyPressEvent(int keyId, String eventType) async {
  final KeyPressEvent keyPressEvent = await createKeyPressEvent(
    keyId,
    eventType,
  );

  _keyPressEventBuffer.add(keyPressEvent);

  _keyInactivityFlushTimer?.cancel();
  _keyInactivityFlushTimer = Timer(const Duration(seconds: 10), () {
    flushKeyPressEventBufferToDatabase(_keyPressEventBuffer);
    SessionCounterManager.increment("activity_id_key");
  });
}

Future<KeyPressEvent> createKeyPressEvent(int keyId, String eventType) async {
  int epochMillis = DateTime.now().millisecondsSinceEpoch;
  int pressType = eventType == "down" ? 0 : 1;
  int phoneOrientation = await getNativeDeviceOrientation();
  int activityId = await getActivityId("activity_id_key");

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

Future<void> flushKeyPressEventBufferToDatabase(
  List<KeyPressEvent> events,
) async {
  for (final event in events) {
    await handleKeyPressEvent(event);
  }
  _keyPressEventBuffer.clear();
}
