import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/models/key_press_event.dart';

class TrackingEventsService {
  final Dio _dio;

  TrackingEventsService(this._dio);

  Future<CustomResponse> createKeyPressEvent(
    KeyPressEvent keyPressEvent,
  ) async {
    try {
      final response = await _dio.post(
        constants.Strings.createKeyPressEvent,
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
}
