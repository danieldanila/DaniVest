import 'dart:async';
import 'dart:math';

import 'package:frontend/constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/stroke_event.dart';
import 'package:frontend/services/tracking_events_service.dart';
import 'package:frontend/tracking/session_counter_manager.dart';
import 'package:frontend/utilities/tracking/tracking_utils.dart';

List<StrokeEvent> _strokeEventBuffer = [];

Timer? _strokeInactivityFlushTimer;
Set<int> _activePointers = {};

Future<void> processStrokeEvent(PointerEvent event) async {
  final bool isDown = event is PointerDownEvent;
  final bool isUp = event is PointerUpEvent;

  StrokeEvent newStrokeEvent = await createStrokeEvent(event);

  final int pointer = event.pointer;

  if (isDown) {
    _strokeEventBuffer.add(newStrokeEvent);
    _activePointers.add(pointer);
  }

  int pointerId;
  if (_activePointers.isEmpty) {
    pointerId = 0;
  } else {
    pointerId = _activePointers.elementAt(0) == event.pointer ? 0 : 1;
  }

  if (isUp) {
    StrokeEvent firstStrokeEvent;
    int strokeEventBufferSize = _strokeEventBuffer.length;
    int activePointersSize = _activePointers.length;

    if (pointerId == 0) {
      if (activePointersSize == 1) {
        firstStrokeEvent = _strokeEventBuffer.elementAt(
          strokeEventBufferSize - 1,
        );
      } else {
        firstStrokeEvent = _strokeEventBuffer.elementAt(
          strokeEventBufferSize - 2,
        );
      }
    } else {
      firstStrokeEvent = _strokeEventBuffer.elementAt(
        strokeEventBufferSize - 1,
      );
    }

    double dx = newStrokeEvent.START_X - firstStrokeEvent.START_X;
    double dy = newStrokeEvent.START_Y - firstStrokeEvent.START_Y;
    double dt =
        (newStrokeEvent.BEGIN_TIME - firstStrokeEvent.BEGIN_TIME) / 1000;
    double speedX = dx / dt;
    double speedY = dy / dt;

    firstStrokeEvent = firstStrokeEvent.copyWith(
      END_TIME: newStrokeEvent.BEGIN_TIME,
      END_X: newStrokeEvent.START_X,
      END_Y: newStrokeEvent.START_Y,
      END_SIZE: newStrokeEvent.START_SIZE,
      SPEED_X: speedX,
      SPEED_Y: speedY,
    );

    if (pointerId == 0) {
      if (activePointersSize == 1) {
        _strokeEventBuffer[strokeEventBufferSize - 1] = firstStrokeEvent;
      } else {
        _strokeEventBuffer[strokeEventBufferSize - 2] = firstStrokeEvent;
      }
    } else {
      _strokeEventBuffer[strokeEventBufferSize - 1] = firstStrokeEvent;
    }

    _activePointers.remove(pointer);
  }

  _strokeInactivityFlushTimer?.cancel();
  _strokeInactivityFlushTimer = Timer(const Duration(seconds: 10), () {
    flushStrokeEventBufferToDatabase(_strokeEventBuffer);
    SessionCounterManager.increment("activity_id_stroke");
  });
}

Future<StrokeEvent> createStrokeEvent(PointerEvent event) async {
  int epochMillis = DateTime.now().millisecondsSinceEpoch;
  Offset coordinates = event.position;
  double x = coordinates.dx;
  double y = coordinates.dy;
  double contactArea = pi * event.radiusMajor * event.radiusMinor / 100;
  int phoneOrientation = await getNativeDeviceOrientation();
  int activityId = await getActivityId("activity_id_stroke");

  return StrokeEvent(
    SYSTIME: epochMillis,
    BEGIN_TIME: epochMillis - constants.Properties.appStartEpochMillis,
    END_TIME: null,
    ACTIVITYID: activityId,
    START_X: x,
    START_Y: y,
    START_SIZE: contactArea,
    END_X: null,
    END_Y: null,
    END_SIZE: null,
    SPEED_X: null,
    SPEED_Y: null,
    PHONE_ORIENTATION: phoneOrientation,
  );
}

Future<void> handleStrokeEvent(StrokeEvent strokeEvent) async {
  final trackingEventsService = locator<TrackingEventsService>();

  final customResponse = await trackingEventsService.createStrokeEvent(
    strokeEvent,
  );

  if (customResponse.success) {
    print(customResponse.message);
  }
}

Future<void> flushStrokeEventBufferToDatabase(List<StrokeEvent> events) async {
  print("SIZE ${events.length}");
  for (final event in events) {
    await handleStrokeEvent(event);
  }
  _strokeEventBuffer.clear();
}
