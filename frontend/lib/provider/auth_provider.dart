import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/models/login_data.dart';
import 'package:frontend/models/signup_data.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/token_service.dart';

class AuthProvider with ChangeNotifier {
  final _authService = locator<AuthService>();
  bool _isAuthenticated = false;
  bool _passcodeChecked = false;

  bool get isAuthenticated => _isAuthenticated;

  User? _user;
  User? get user => _user;
  bool get passcodeChecked => _passcodeChecked;

  void setPasscodeChecked(bool value) {
    _passcodeChecked = value;
    notifyListeners();
  }

  Future<CustomResponse> _updateUser() async {
    CustomResponse customResponse = await _authService.getCurrentUser();

    if (customResponse.success) {
      _user = User.fromJson(customResponse.data);
    }
    return customResponse;
  }

  Future<CustomResponse> login(LoginData loginData) async {
    CustomResponse customResponse = await _authService.login(loginData);

    if (customResponse.success) {
      _isAuthenticated = true;
      await _updateUser();
      notifyListeners();
    }
    return customResponse;
  }

  Future<CustomResponse> signup(SignupData signupData) async {
    CustomResponse customResponse = await _authService.signup(signupData);

    return customResponse;
  }

  Future<void> tryAutoLogin() async {
    try {
      final token = await TokenService().getToken();

      if (token == null) {
        return;
      }
      CustomResponse customResponse = await _updateUser();

      if (customResponse.success) {
        _isAuthenticated = true;
        notifyListeners();
      } else {
        _isAuthenticated = false;
      }
    } catch (e) {
      throw Exception("Failed to login. $e");
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }
}
