import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/models/key_press_event.dart';
import 'package:frontend/models/one_finger_touch_event.dart';
import 'package:frontend/models/scroll_event.dart';
import 'package:frontend/models/stroke_event.dart';
import 'package:frontend/models/touch_event.dart';

class TrackingEventsService {
  final Dio _dio;

  TrackingEventsService(this._dio);

  Future<CustomResponse> createKeyPressEvent(
    KeyPressEvent keyPressEvent,
  ) async {
    try {
      final response = await _dio.post(
        constants.Strings.createKeyPressEventPath,
        data: jsonEncode(keyPressEvent),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 201) {
        return CustomResponse(
          success: true,
          data: responseBodyJson,
          message: responseBodyJson[constants.Strings.responseMessageFieldName],
        );
      }

      return CustomResponse(
        success: false,
        message:
            responseBodyJson[constants.Strings.responseMessageFieldName][0],
      );
    } catch (e) {
      return CustomResponse(success: false, message: "KeyPressEvent error: $e");
    }
  }

  Future<CustomResponse> createOneFingerTouchEvent(
    OneFingerTouchEvent oneFingerTouchEvent,
  ) async {
    try {
      final response = await _dio.post(
        constants.Strings.createOneFingerTouchEventPath,
        data: jsonEncode(oneFingerTouchEvent),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 201) {
        return CustomResponse(
          success: true,
          data: responseBodyJson,
          message: responseBodyJson[constants.Strings.responseMessageFieldName],
        );
      }

      return CustomResponse(
        success: false,
        message:
            responseBodyJson[constants.Strings.responseMessageFieldName][0],
      );
    } catch (e) {
      return CustomResponse(
        success: false,
        message: "OneFingerTouchEvent error: $e",
      );
    }
  }

  Future<CustomResponse> createTouchEvent(TouchEvent touchEvent) async {
    try {
      final response = await _dio.post(
        constants.Strings.createTouchEventPath,
        data: jsonEncode(touchEvent),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 201) {
        return CustomResponse(
          success: true,
          data: responseBodyJson,
          message: responseBodyJson[constants.Strings.responseMessageFieldName],
        );
      }

      return CustomResponse(
        success: false,
        message:
            responseBodyJson[constants.Strings.responseMessageFieldName][0],
      );
    } catch (e) {
      return CustomResponse(success: false, message: "TouchEvent error: $e");
    }
  }

  Future<CustomResponse> createScrollEvent(ScrollEvent scrollEvent) async {
    try {
      final response = await _dio.post(
        constants.Strings.createScrollEventPath,
        data: jsonEncode(scrollEvent),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 201) {
        return CustomResponse(
          success: true,
          data: responseBodyJson,
          message: responseBodyJson[constants.Strings.responseMessageFieldName],
        );
      }

      return CustomResponse(
        success: false,
        message:
            responseBodyJson[constants.Strings.responseMessageFieldName][0],
      );
    } catch (e) {
      return CustomResponse(success: false, message: "ScrollEvent error: $e");
    }
  }

  Future<CustomResponse> createStrokeEvent(StrokeEvent strokeEvent) async {
    try {
      final response = await _dio.post(
        constants.Strings.createStrokeEventPath,
        data: jsonEncode(strokeEvent),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 201) {
        return CustomResponse(
          success: true,
          data: responseBodyJson,
          message: responseBodyJson[constants.Strings.responseMessageFieldName],
        );
      }

      return CustomResponse(
        success: false,
        message:
            responseBodyJson[constants.Strings.responseMessageFieldName][0],
      );
    } catch (e) {
      return CustomResponse(success: false, message: "StrokeEvent error: $e");
    }
  }
}
