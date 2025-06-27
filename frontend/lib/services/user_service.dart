import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/custom_response.dart';

import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/models/forgot_password_data.dart';
import 'package:frontend/models/patch_passcode.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/auth_service.dart';

class UserService {
  final Dio _dio;

  UserService(this._dio);

  Future<CustomResponse> setPasscode(PatchPasscode patchPasscode) async {
    try {
      final response = await _dio.patch(
        constants.Strings.authPasscodePath,
        data: jsonEncode(patchPasscode),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 200) {
        return CustomResponse(
          success: true,
          message: responseBodyJson[constants.Strings.responseMessageFieldName],
        );
      }

      return CustomResponse(
        success: false,
        message: responseBodyJson[constants.Strings.responseMessageFieldName],
      );
    } catch (e) {
      return CustomResponse(success: false, message: "SetPassCode error: $e");
    }
  }

  Future<CustomResponse> forgotPassword(
    ForgotPasswordData forgotPasswordData,
  ) async {
    try {
      final response = await _dio.post(
        constants.Strings.forgotPasswordPath,
        data: jsonEncode(forgotPasswordData),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 200) {
        return CustomResponse(
          success: true,
          message: responseBodyJson[constants.Strings.responseMessageFieldName],
        );
      }

      return CustomResponse(
        success: false,
        message: responseBodyJson[constants.Strings.responseMessageFieldName],
      );
    } catch (e) {
      return CustomResponse(
        success: false,
        message: "ForgotPassword error: $e",
      );
    }
  }

  Future<CustomResponse> getUserBankAccount() async {
    final authService = locator<AuthService>();

    try {
      CustomResponse customResponse = await authService.getCurrentUser();

      if (customResponse.success) {
        User user = User.fromJson(customResponse.data);

        final response = await _dio.get(
          constants.Strings.getUserBankAccount.replaceAll(":id", user.id),
        );

        final responseBodyJson = response.data;

        if (response.statusCode == 200) {
          return CustomResponse(
            success: true,
            data: responseBodyJson,
            message:
                responseBodyJson[constants.Strings.responseMessageFieldName],
          );
        }

        return CustomResponse(
          success: false,
          message: responseBodyJson[constants.Strings.responseMessageFieldName],
        );
      }
      return CustomResponse(success: false, message: customResponse.message);
    } catch (e) {
      return CustomResponse(
        success: false,
        message: "ForgotPassword error: $e",
      );
    }
  }
}
