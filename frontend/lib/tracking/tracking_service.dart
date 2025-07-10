import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/tracking/process/key_press_event_process.dart';
import 'package:frontend/tracking/process/one_finger_touch_event_process.dart';
import 'package:frontend/tracking/process/scroll_event_process.dart';
import 'package:frontend/tracking/process/stroke_event_process.dart';
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

  void logKeyEvent(KeyEvent event) async {
    String? eventType;
    if (event is KeyDownEvent) {
      eventType = "down";
    } else if (event is KeyUpEvent) {
      eventType = "up";
    }
    await processKeyPressEvent(event);

    print(
      "Key Event - Type: $eventType, Key Name: ${event.logicalKey.debugName ?? "Unknown Key"}, Key Id: ${event.logicalKey.keyId}",
    );
  }

  void logTouchEvent(PointerEvent event) async {
    await processOneFingerTouchEvent(event);
    await processTouchEvent(event);
    await processStrokeEvent(event);
    await processScrollEvent(event);

    print("Touch at X: ${event.delta.dx}, Y:${event.delta.dy}");
  }
}
