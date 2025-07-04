import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/models/change_my_passcode_data.dart';
import 'package:frontend/models/change_my_password_data.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/models/login_data.dart';
import 'package:frontend/models/login_passcode_data.dart';
import 'package:frontend/models/reset_password_data.dart';
import 'package:frontend/models/signup_data.dart';

import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/services/token_service.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<CustomResponse> getCurrentUser() async {
    final response = await _dio.get(constants.Strings.userAuthenticatedPath);

    final responseBodyJson = response.data;

    if (response.statusCode == 200) {
      return CustomResponse(
        success: true,
        data: responseBodyJson,
        message: responseBodyJson[constants.Strings.responseMessageFieldName],
      );
    } else {
      return CustomResponse(
        success: false,
        message: responseBodyJson[constants.Strings.responseMessageFieldName],
      );
    }
  }

  Future<CustomResponse> login(LoginData loginData) async {
    try {
      final response = await _dio.post(
        constants.Strings.loginUserPath,
        data: jsonEncode(loginData),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 200) {
        final token = responseBodyJson["token"];
        if (token != null) {
          await TokenService().saveToken(token);
          return CustomResponse(
            success: true,
            message:
                responseBodyJson[constants.Strings.responseMessageFieldName],
          );
        }
      }
      return CustomResponse(
        success: false,
        message: responseBodyJson[constants.Strings.responseMessageFieldName],
      );
    } catch (e) {
      return CustomResponse(success: false, message: "Login error: $e");
    }
  }

  Future<CustomResponse> checkPasscode(
    LoginPasscodeData loginPasscodeData,
  ) async {
    try {
      final response = await _dio.post(
        constants.Strings.authPasscodePath,
        data: jsonEncode(loginPasscodeData),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 200) {
        final token = responseBodyJson["token"];
        if (token != null) {
          await TokenService().saveToken(token);
          return CustomResponse(
            success: true,
            message:
                responseBodyJson[constants.Strings.responseMessageFieldName],
          );
        }
      }
      return CustomResponse(
        success: false,
        message: responseBodyJson[constants.Strings.responseMessageFieldName],
      );
    } catch (e) {
      return CustomResponse(
        success: false,
        message: "Passcode login error: $e",
      );
    }
  }

  Future<CustomResponse> signup(SignupData userBody) async {
    try {
      final response = await _dio.post(
        constants.Strings.createUserPath,
        data: jsonEncode(userBody),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 201) {
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
      return CustomResponse(success: false, message: "Signup error: $e");
    }
  }

  Future<CustomResponse> resetPassword(
    ResetPasswordData resetPasswordData,
    String token,
  ) async {
    try {
      final response = await _dio.patch(
        "${constants.Strings.resetPasswordPath}/$token",
        data: jsonEncode(resetPasswordData),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 201) {
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
        message: "Reset password error: $e",
      );
    }
  }

  Future<CustomResponse> updatePassword(
    ChangeMyPasswordData changeMyPasswordData,
  ) async {
    try {
      final response = await _dio.patch(
        constants.Strings.updateMyPasswordPath,
        data: jsonEncode(changeMyPasswordData),
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
        message: "Update password error: $e",
      );
    }
  }

  Future<CustomResponse> updatePasscode(
    ChangeMyPasscodeData changeMyPasscodeData,
  ) async {
    try {
      final response = await _dio.patch(
        constants.Strings.updateMyPasscodePath,
        data: jsonEncode(changeMyPasscodeData),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 202) {
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
        message: "Update passcode error: $e",
      );
    }
  }

  Future<void> logout() async {
    await TokenService().deleteToken();
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception("Invalid token");
    }
    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    return json.decode(payload);
  }
}
