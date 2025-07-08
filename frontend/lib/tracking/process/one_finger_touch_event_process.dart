import 'dart:math';

import 'package:frontend/constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/one_finger_touch_event.dart';
import 'package:frontend/services/tracking_events_service.dart';
import 'package:frontend/tracking/session_counter_manager.dart';
import 'package:frontend/utilities/tracking/tracking_utils.dart';

enum TapState { idle, waitingSecondTap, inDoubleTap }

List<OneFingerTouchEvent> _oneFingerTouchEventBuffer = [];

TapState _tapState = TapState.idle;
int _firstTapDownTime = 0;

Future<void> processOneFingerTouchEvent(PointerEvent event) async {
  final int now = DateTime.now().millisecondsSinceEpoch;
  final OneFingerTouchEvent tapEvent = await createTouchEvent(event);

  final bool isDown = event is PointerDownEvent;
  final bool isUp = event is PointerUpEvent;
  final bool isMove = event is PointerMoveEvent;

  switch (_tapState) {
    case TapState.idle:
      if (isDown) {
        _oneFingerTouchEventBuffer = [tapEvent.copyWith(TAP_TYPE: 0)];
        _firstTapDownTime = now;
        _tapState = TapState.waitingSecondTap;
      }
      break;

    case TapState.waitingSecondTap:
      if (isUp) {
        _oneFingerTouchEventBuffer.add(tapEvent.copyWith(TAP_TYPE: 1));

        Future.delayed(const Duration(milliseconds: 320), () {
          if (_tapState == TapState.waitingSecondTap) {
            flushOneFingerTouchEventBufferToDatabase(
              _oneFingerTouchEventBuffer,
            );
            _tapState = TapState.idle;
          }
        });
        SessionCounterManager.increment("onefinger");
      } else if (isDown && (now - _firstTapDownTime <= 300)) {
        for (int i = 0; i < _oneFingerTouchEventBuffer.length; i++) {
          final e = _oneFingerTouchEventBuffer[i];
          if (e.ACTION_TYPE == 0) {
            _oneFingerTouchEventBuffer[i] = e.copyWith(TAP_TYPE: 2);
          }
        }
        _oneFingerTouchEventBuffer.add(tapEvent.copyWith(TAP_TYPE: 3));
        _tapState = TapState.inDoubleTap;
      }
      break;

    case TapState.inDoubleTap:
      if (isMove) {
        _oneFingerTouchEventBuffer.add(tapEvent.copyWith(TAP_TYPE: 3));
      } else if (isUp) {
        _oneFingerTouchEventBuffer.add(tapEvent.copyWith(TAP_TYPE: 3));
        flushOneFingerTouchEventBufferToDatabase(_oneFingerTouchEventBuffer);
        _tapState = TapState.idle;
        SessionCounterManager.increment("onefinger");
      }
      break;
  }
}

Future<OneFingerTouchEvent> createTouchEvent(PointerEvent event) async {
  int epochMillis = DateTime.now().millisecondsSinceEpoch;
  Offset coordinates = event.position;
  double x = coordinates.dx;
  double y = coordinates.dy;
  double contactArea = pi * event.radiusMajor * event.radiusMinor / 100;
  int phoneOrientation = await getNativeDeviceOrientation();
  int activityId = await getActivityId("onefinger");
  int tapId = SessionCounterManager.get("onefinger");

  int actionType;
  if (event is PointerDownEvent) {
    actionType = 0;
  } else if (event is PointerUpEvent) {
    actionType = 1;
  } else if (event is PointerMoveEvent) {
    actionType = 2;
  } else {
    actionType = -1;
  }

  return OneFingerTouchEvent(
    SYSTIME: epochMillis,
    PRESSTIME: epochMillis - constants.Properties.appStartEpochMillis,
    ACTIVITYID: activityId,
    TAPID: tapId,
    TAP_TYPE: -1,
    ACTION_TYPE: actionType,
    X: x,
    Y: y,
    CONTACT_SIZE: contactArea,
    PHONE_ORIENTATION: phoneOrientation,
  );
}

Future<void> handleOneFingerTouchEvent(
  OneFingerTouchEvent oneFingerTouchEvent,
) async {
  final trackingEventsService = locator<TrackingEventsService>();

  final customResponse = await trackingEventsService.createOneFingerTouchEvent(
    oneFingerTouchEvent,
  );

  if (customResponse.success) {
    print(customResponse.message);
  }
}

void flushOneFingerTouchEventBufferToDatabase(
  List<OneFingerTouchEvent> events,
) async {
  for (final event in events) {
    await handleOneFingerTouchEvent(event);
  }
  _oneFingerTouchEventBuffer.clear();
}
