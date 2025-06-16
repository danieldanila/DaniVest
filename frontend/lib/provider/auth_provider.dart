import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/models/login_data.dart';
import 'package:frontend/models/signup_data.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _authService = locator<AuthService>();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  User? _user;
  User? get user => _user;

  Future<void> _updateUser() async {
    try {
      final userData = await _authService.getUserProfile();
      _user = User.fromJson(userData);
    } catch (e) {
      print("Failed to fetch user: $e");
    }
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

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }
}
