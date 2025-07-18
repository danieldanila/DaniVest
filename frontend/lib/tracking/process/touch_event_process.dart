import 'dart:async';
import 'dart:math';

import 'package:frontend/constants/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/touch_event.dart';
import 'package:frontend/services/tracking_events_service.dart';
import 'package:frontend/tracking/session_counter_manager.dart';
import 'package:frontend/utilities/tracking/tracking_utils.dart';

enum TapState { idle, waitingSecondTouch, inDoubleTouch }

List<TouchEvent> _touchEventBuffer = [];

TapState _tapState = TapState.idle;
Timer? _touchInactivityFlushTimer;
int _firstTapDownTime = 0;
Set<int> _activePointers = {};

Future<void> processTouchEvent(PointerEvent event) async {
  final int now = DateTime.now().millisecondsSinceEpoch;
  final int pointer = event.pointer;

  final bool isDown = event is PointerDownEvent;
  final bool isUp = event is PointerUpEvent;
  final bool isMove = event is PointerMoveEvent;

  if (isDown) _activePointers.add(pointer);

  final int pointerCount =
      _activePointers.isEmpty ? 1 : _activePointers.length.clamp(1, 2);

  int pointerId;
  if (_activePointers.isEmpty) {
    pointerId = 0;
  } else {
    pointerId = _activePointers.elementAt(0) == event.pointer ? 0 : 1;
  }

  TouchEvent tapEvent = await createTouchEvent(event);
  tapEvent = tapEvent.copyWith(
    POINTER_COUNT: pointerCount,
    POINTERID: pointerId,
  );

  switch (_tapState) {
    case TapState.idle:
      if (isDown) {
        _touchEventBuffer.add(tapEvent);
        _firstTapDownTime = now;
        _tapState = TapState.waitingSecondTouch;
      }
      break;

    case TapState.waitingSecondTouch:
      if (isMove && tapEvent.POINTER_COUNT == 1) {
        _touchEventBuffer.add(tapEvent);
      } else if (isUp && tapEvent.POINTER_COUNT == 1) {
        _touchEventBuffer.add(tapEvent);

        Future.delayed(const Duration(milliseconds: 320), () {
          if (_tapState == TapState.waitingSecondTouch) {
            _tapState = TapState.idle;
          }
        });
      } else if (isDown && (now - _firstTapDownTime <= 300)) {
        // Because of how HMOG dataset is (most likely a bug)
        final previousTouchEvent =
            _touchEventBuffer[_touchEventBuffer.length - 1];

        if (previousTouchEvent.ACTIONID == 2) {
          _touchEventBuffer[_touchEventBuffer.length - 1] = previousTouchEvent
              .copyWith(POINTER_COUNT: 2, ACTIONID: 0);
        }

        _touchEventBuffer.add(tapEvent);
        _tapState = TapState.inDoubleTouch;
      }
      break;

    case TapState.inDoubleTouch:
      if (isMove) {
        _touchEventBuffer.add(tapEvent);
      } else if (isUp) {
        _touchEventBuffer.add(tapEvent);

        if (tapEvent.POINTER_COUNT == 2 && tapEvent.POINTERID == 0) {
          // Because of how HMOG dataset is (most likely a bug)
          TouchEvent finalTouchEvent = tapEvent.copyWith(
            POINTER_COUNT: 1,
            POINTERID: 1,
          );
          _touchEventBuffer.add(finalTouchEvent);

          _tapState = TapState.idle;
        }
      }
      break;
  }
  if (isUp) _activePointers.remove(pointer);

  _touchInactivityFlushTimer?.cancel();
  _touchInactivityFlushTimer = Timer(
    const Duration(seconds: constants.Properties.secondsBeforeSentToDb),
    () {
      flushTouchEventBufferToDatabase(_touchEventBuffer);
      SessionCounterManager.increment("activity_id_touch");
    },
  );
}

Future<TouchEvent> createTouchEvent(PointerEvent event) async {
  int epochMillis = DateTime.now().millisecondsSinceEpoch;
  Offset coordinates = event.position;
  double x = coordinates.dx;
  double y = coordinates.dy;
  double contactArea = pi * event.radiusMajor * event.radiusMinor / 100;
  int phoneOrientation = await getNativeDeviceOrientation();
  int activityId = await getActivityId("activity_id_touch");

  int actiondId;
  if (event is PointerDownEvent) {
    actiondId = 0;
  } else if (event is PointerUpEvent) {
    actiondId = 1;
  } else if (event is PointerMoveEvent) {
    actiondId = 2;
  } else {
    actiondId = -1;
  }

  return TouchEvent(
    SYSTIME: epochMillis,
    EVENTTIME: epochMillis - constants.Properties.appStartEpochMillis,
    ACTIVITYID: activityId,
    POINTER_COUNT: null,
    POINTERID: null,
    ACTIONID: actiondId,
    X: x,
    Y: y,
    CONTACT_SIZE: contactArea,
    PHONE_ORIENTATION: phoneOrientation,
  );
}

Future<void> handleTouchEvent(TouchEvent touchEvent) async {
  final trackingEventsService = locator<TrackingEventsService>();

  final customResponse = await trackingEventsService.createTouchEvent(
    touchEvent,
  );

  if (customResponse.success) {
    print(customResponse.message);
  }
}

Future<void> flushTouchEventBufferToDatabase(List<TouchEvent> events) async {
  final List<TouchEvent> eventsCopy = List.from(events);

  for (final event in eventsCopy) {
    await handleTouchEvent(event);
  }

  _touchEventBuffer.clear();
}
