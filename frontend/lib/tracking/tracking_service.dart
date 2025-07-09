import 'package:flutter/material.dart';
import 'package:frontend/tracking/process/key_press_event_process.dart';
import 'package:frontend/tracking/process/one_finger_touch_event_process.dart';
import 'package:frontend/tracking/process/touch_event_process.dart';

class TrackingService {
  static final TrackingService instance = TrackingService._();
  TrackingService._();

  void logKeystrokeChange({
    required String previous,
    required String current,
    required Duration interval,
  }) {
    print(
      "[Typing] Changed from '$previous' to '$current' in ${interval.inMilliseconds} ms",
    );
  }

  void logKeyEvent({
    required int keyId,
    required String keyName,
    required String eventType,
  }) async {
    // await processKeyPressEvent(keyId, eventType);

    print("Key Event - Type: $eventType, Key Name: $keyName, Key Id: $keyId");
  }

  void logTouchEvent(PointerEvent event) async {
    // await processOneFingerTouchEvent(event);
    await processTouchEvent(event);

    print("Touch at X: ${event.delta.dx}, Y:${event.delta.dy}");
  }
}
