import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/models/conversation_data.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/constants/constants.dart' as constants;

class ConversationService {
  final Dio _dio;

  ConversationService(this._dio);

  Future<CustomResponse> createConversation(
    ConversationData conversationData,
  ) async {
    try {
      final response = await _dio.post(
        constants.Strings.createConversationPath,
        data: jsonEncode(conversationData),
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
        message: "CreateConversation error: $e",
      );
    }
  }
}
