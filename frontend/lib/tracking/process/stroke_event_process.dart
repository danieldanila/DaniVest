import 'dart:math';

import 'package:frontend/constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/stroke_event.dart';
import 'package:frontend/services/tracking_events_service.dart';
import 'package:frontend/utilities/tracking/tracking_utils.dart';

List<StrokeEvent> _strokeEventBuffer = [];

Future<void> processStrokeEvent(PointerEvent event) async {
  StrokeEvent strokeEvent = await createStrokeEvent(event);
  _strokeEventBuffer.add(strokeEvent);

  flushStrokeEventBufferToDatabase(_strokeEventBuffer);
}

Future<StrokeEvent> createStrokeEvent(PointerEvent event) async {
  int epochMillis = DateTime.now().millisecondsSinceEpoch;
  Offset coordinates = event.position;
  double x = coordinates.dx;
  double y = coordinates.dy;
  double contactArea = pi * event.radiusMajor * event.radiusMinor / 100;
  int phoneOrientation = await getNativeDeviceOrientation();
  int activityId = await getActivityId("stroke");

  return StrokeEvent(
    SYSTIME: epochMillis,
    BEGIN_TIME: epochMillis - constants.Properties.appStartEpochMillis,
    END_TIME: 0,
    ACTIVITYID: activityId,
    START_X: x,
    START_Y: y,
    START_SIZE: contactArea,
    END_X: 0,
    END_Y: 0,
    END_SIZE: 0,
    SPEED_X: 0,
    SPEED_Y: 0,
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
  for (final event in events) {
    await handleStrokeEvent(event);
  }
  _strokeEventBuffer.clear();
}
