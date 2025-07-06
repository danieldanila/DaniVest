import 'package:flutter/services.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/key_press_event.dart';
import 'package:frontend/services/tracking_events_service.dart';
import 'package:frontend/constants/constants.dart' as constants;

class TrackingService {
  static final TrackingService instance = TrackingService._();
  TrackingService._();

  void logTouchEvent(PointerEvent event) {
    final timestamp = DateTime.now();
    print('Touch at ${event.position} on $timestamp');
  }

  void logKeystroke(String value) {
    final timestamp = DateTime.now();
    print('Key "$value" at $timestamp');
  }

  void logKeystrokeChange({
    required String previous,
    required String current,
    required Duration interval,
  }) {
    print(
      '[Typing] Changed from "$previous" to "$current" in ${interval.inMilliseconds} ms',
    );
    // You can also extract added/removed characters if needed
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

  void logKeyEvent({
    required keyId,
    required String keyName,
    required String eventType,
  }) {
    int epochMillis = DateTime.now().millisecondsSinceEpoch;
    int pressType = eventType == "down" ? 0 : 1;

    final keyPressEventData = KeyPressEvent(
      SYSTIME: epochMillis,
      PRESSTIME: epochMillis - constants.Properties.appStartEpochMillis,
      ACTIVITYID: 270701,
      PRESSTYPE: pressType,
      KEYID: keyId,
      PHONE_ORIENTATION: 0,
    );
    handleKeyPressEvent(keyPressEventData);

    print(
      'Raw Key Event - Type: $eventType, Key Name: $keyName, Key Id: $keyId',
    );
    // Implement your actual raw key event logging logic here
  }
}
