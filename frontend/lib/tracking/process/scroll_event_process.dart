import 'dart:async';
import 'dart:math';

import 'package:frontend/constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/scroll_event.dart';
import 'package:frontend/services/tracking_events_service.dart';
import 'package:frontend/tracking/session_counter_manager.dart';
import 'package:frontend/utilities/tracking/tracking_utils.dart';

List<ScrollEvent> _scrollEventBuffer = [];

Timer? _scrollInactivityFlushTimer;

Future<void> processScrollEvent(PointerEvent event) async {
  final bool isDown = event is PointerDownEvent;
  final bool isUp = event is PointerUpEvent;
  final bool isMove = event is PointerMoveEvent;

  ScrollEvent newScrollEvent = await createScrollEvent(event);

  if (isDown) {
    _scrollEventBuffer.add(newScrollEvent);
  }

  if (isUp || isMove) {
    ScrollEvent firstScrollEvent;

    try {
      firstScrollEvent = _scrollEventBuffer.firstWhere(
        (e) => e.SCROLLID == newScrollEvent.SCROLLID,
      );

      double dx = newScrollEvent.START_X - firstScrollEvent.START_X;
      double dy = newScrollEvent.START_Y - firstScrollEvent.START_Y;

      newScrollEvent = newScrollEvent.copyWith(
        BEGINTIME: firstScrollEvent.BEGINTIME,
        START_X: firstScrollEvent.START_X,
        START_Y: firstScrollEvent.START_Y,
        START_SIZE: firstScrollEvent.START_SIZE,
        CURRENT_X: newScrollEvent.START_X,
        CURRENT_Y: newScrollEvent.START_Y,
        CURRENT_SIZE: newScrollEvent.START_SIZE,
        DISTANCE_X: dx,
        DISTANCE_Y: dy,
      );

      _scrollEventBuffer.add(newScrollEvent);

      if (isUp) {
        SessionCounterManager.increment("scroll");
      }
    } catch (e) {
      print(e);
    }
  }

  _scrollInactivityFlushTimer?.cancel();
  _scrollInactivityFlushTimer = Timer(
    const Duration(seconds: constants.Properties.secondsBeforeSentToDb),
    () {
      flushScrollEventBufferToDatabase(_scrollEventBuffer);
      SessionCounterManager.increment("activity_id_scroll");
    },
  );
}

Future<ScrollEvent> createScrollEvent(PointerEvent event) async {
  int epochMillis = DateTime.now().millisecondsSinceEpoch;
  Offset coordinates = event.position;
  double x = coordinates.dx;
  double y = coordinates.dy;
  double contactArea = pi * event.radiusMajor * event.radiusMinor / 100;
  int phoneOrientation = await getNativeDeviceOrientation();
  int activityId = await getActivityId("activity_id_scroll");
  int scrollId = SessionCounterManager.get("scroll");

  return ScrollEvent(
    SYSTIME: epochMillis,
    BEGINTIME: epochMillis - constants.Properties.appStartEpochMillis,
    CURRENTTIME: epochMillis - constants.Properties.appStartEpochMillis,
    ACTIVITYID: activityId,
    SCROLLID: scrollId,
    START_X: x,
    START_Y: y,
    START_SIZE: contactArea,
    CURRENT_X: null,
    CURRENT_Y: null,
    CURRENT_SIZE: null,
    DISTANCE_X: null,
    DISTANCE_Y: null,
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
