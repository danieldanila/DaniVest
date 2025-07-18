import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/add_new_friend_data.dart';
import 'package:frontend/models/change_other_account_data.dart';
import 'package:frontend/models/custom_response.dart';

import 'package:frontend/constants/constants.dart' as constants;
import 'package:frontend/models/forgot_password_data.dart';
import 'package:frontend/models/patch_passcode.dart';
import 'package:frontend/models/update_me.dart';
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

  Future<CustomResponse> getUserBankAccount({String? userId}) async {
    final authService = locator<AuthService>();

    try {
      CustomResponse customResponse = await authService.getCurrentUser();

      if (customResponse.success) {
        User user = User.fromJson(customResponse.data);

        final response = await _dio.get(
          constants.Strings.getUserBankAccount.replaceAll(
            ":id",
            userId ?? user.id,
          ),
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
        message: "GetUserBankAccount error: $e",
      );
    }
  }

  Future<CustomResponse> getUserOtherBankAccount(
    ChangeOtherAccountData? changeOtherAccountData,
  ) async {
    final authService = locator<AuthService>();

    try {
      CustomResponse customResponse = await authService.getCurrentUser();

      if (customResponse.success) {
        User user = User.fromJson(customResponse.data);

        final Response response;

        if (changeOtherAccountData != null &&
            changeOtherAccountData.cardNumber.isNotEmpty &&
            changeOtherAccountData.expiryDate.isNotEmpty &&
            changeOtherAccountData.cvv.isNotEmpty) {
          response = await _dio.get(
            constants.Strings.getUserOtherBankAccountByCardDetails
                .replaceAll(":id", user.id)
                .replaceAll(":cardNumber", changeOtherAccountData.cardNumber)
                .replaceAll(":expiryDate", changeOtherAccountData.expiryDate)
                .replaceAll(":cvv", changeOtherAccountData.cvv),
          );
        } else {
          response = await _dio.get(
            constants.Strings.getUserOtherBankAccount.replaceAll(
              ":id",
              user.id,
            ),
          );
        }

        final responseBodyJson = response.data;

        if (response.statusCode == 200) {
          return CustomResponse(
            success: true,
            data:
                changeOtherAccountData == null
                    ? responseBodyJson
                    : responseBodyJson[constants.Strings.responseDataFieldName],
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
        message: "GetUserOtherBankAccount error: $e",
      );
    }
  }

  Future<CustomResponse> getUserAllTransactions() async {
    final authService = locator<AuthService>();

    try {
      CustomResponse customResponse = await authService.getCurrentUser();

      if (customResponse.success) {
        User user = User.fromJson(customResponse.data);

        final response = await _dio.get(
          constants.Strings.getUserAllTransactions.replaceAll(":id", user.id),
        );

        final responseBodyJson = response.data;

        if (response.statusCode == 200) {
          return CustomResponse(
            success: true,
            data: responseBodyJson,
            message: constants.Strings.success,
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
        message: "GetUserAllTranscations error: $e",
      );
    }
  }

  Future<CustomResponse> getUserAllFriends() async {
    final authService = locator<AuthService>();

    try {
      CustomResponse customResponse = await authService.getCurrentUser();

      if (customResponse.success) {
        User user = User.fromJson(customResponse.data);

        final response = await _dio.get(
          constants.Strings.getUserAllFriends.replaceAll(":id", user.id),
        );

        final responseBodyJson = response.data;

        if (response.statusCode == 200) {
          return CustomResponse(
            success: true,
            data: responseBodyJson,
            message: constants.Strings.success,
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
        message: "GetUserAllFriends error: $e",
      );
    }
  }

  Future<CustomResponse> getUserAllConversations() async {
    final authService = locator<AuthService>();

    try {
      CustomResponse customResponse = await authService.getCurrentUser();

      if (customResponse.success) {
        User user = User.fromJson(customResponse.data);

        final response = await _dio.get(
          constants.Strings.getUserAllConversations.replaceAll(":id", user.id),
        );

        final responseBodyJson = response.data;

        if (response.statusCode == 200) {
          return CustomResponse(
            success: true,
            data: responseBodyJson,
            message: constants.Strings.success,
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
        message: "GetUserAllConversations error: $e",
      );
    }
  }

  Future<CustomResponse> updateMe(UpdateMeData updateMeData) async {
    try {
      final filteredData =
          updateMeData.toJson()..removeWhere((key, value) => value == null);

      final response = await _dio.patch(
        constants.Strings.updateMePath,
        data: jsonEncode(filteredData),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 200) {
        return CustomResponse(
          success: true,
          data: responseBodyJson[constants.Strings.responseDataFieldName],
          message: responseBodyJson[constants.Strings.responseMessageFieldName],
        );
      }

      return CustomResponse(
        success: false,
        message:
            responseBodyJson[constants.Strings.responseMessageFieldName][0],
      );
    } catch (e) {
      return CustomResponse(success: false, message: "UpdateMe error: $e");
    }
  }

  Future<CustomResponse> createNewUserFriend(
    AddNewFriendData addNewFriendData,
  ) async {
    try {
      final filteredData =
          addNewFriendData.toJson()..removeWhere((key, value) => value == null);

      final response = await _dio.post(
        constants.Strings.createNewUserFriendPath,
        data: jsonEncode(filteredData),
      );

      final responseBodyJson = response.data;

      if (response.statusCode == 200) {
        return CustomResponse(
          success: true,
          data: responseBodyJson[constants.Strings.responseDataFieldName],
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
        message: "CreateNewUserFriend error: $e",
      );
    }
  }
}
