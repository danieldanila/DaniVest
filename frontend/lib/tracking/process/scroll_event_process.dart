import 'dart:math';

import 'package:frontend/constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/scroll_event.dart';
import 'package:frontend/services/tracking_events_service.dart';
import 'package:frontend/utilities/tracking/tracking_utils.dart';

List<ScrollEvent> _scrollEventBuffer = [];

Future<void> processScrollEvent(PointerEvent event) async {
  ScrollEvent strokeEvent = await createScrollEvent(event);
  _scrollEventBuffer.add(strokeEvent);

  flushScrollEventBufferToDatabase(_scrollEventBuffer);
}

Future<ScrollEvent> createScrollEvent(PointerEvent event) async {
  int epochMillis = DateTime.now().millisecondsSinceEpoch;
  Offset coordinates = event.position;
  double x = coordinates.dx;
  double y = coordinates.dy;
  double contactArea = pi * event.radiusMajor * event.radiusMinor / 100;
  int phoneOrientation = await getNativeDeviceOrientation();
  int activityId = await getActivityId("scroll");

  return ScrollEvent(
    SYSTIME: epochMillis,
    BEGINTIME: epochMillis - constants.Properties.appStartEpochMillis,
    CURRENTTIME: 0,
    ACTIVITYID: activityId,
    SCROLLID: 0,
    START_X: x,
    START_Y: y,
    START_SIZE: contactArea,
    CURRENT_X: 0,
    CURRENT_Y: 0,
    CURRENT_SIZE: 0,
    DISTANCE_X: 0,
    DISTANCE_Y: 0,
    PHONE_ORIENTATION: phoneOrientation,
  );
}

Future<void> handleScrollEvent(ScrollEvent scrollEvent) async {
  final trackingEventsService = locator<TrackingEventsService>();

  final customResponse = await trackingEventsService.createScrollEvent(
    scrollEvent,
  );

  if (customResponse.success) {
    print(customResponse.message);
  }
}

Future<void> flushScrollEventBufferToDatabase(List<ScrollEvent> events) async {
  for (final event in events) {
    await handleScrollEvent(event);
  }
  _scrollEventBuffer.clear();
}
