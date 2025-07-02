import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/models/transaction_data.dart';

class TransactionService {
  final Dio _dio;

  TransactionService(this._dio);

  Future<CustomResponse> createTransaction(
    TransactionData transactionData,
  ) async {
    try {
      final response = await _dio.post(
        constants.Strings.createTransaction,
        data: jsonEncode(transactionData),
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
        message: "CreateTransaction error: $e",
      );
    }
  }
}
