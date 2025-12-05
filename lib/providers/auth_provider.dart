import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userJson = StorageService.getUser();
      if (userJson != null) {
        _user = User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      }

      // Verify token is still valid
      final response = await AuthService.getCurrentUser();
      if (response.success && response.data != null) {
        _user = response.data;
        await StorageService.saveUser(jsonEncode(_user!.toJson()));
      } else {
        _user = null;
        await StorageService.removeToken();
        await StorageService.removeUser();
      }
    } catch (e) {
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String username,
    required String password,
    String? twoFactorToken,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.login(
        username: username,
        password: password,
        twoFactorToken: twoFactorToken,
      );

      // Check for 2FA requirement first
      if (response.data != null && response.data!.requires2FA) {
        _error = '2FA token required';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (response.success && response.data != null) {
        _user = response.data!.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    _error = null;
    notifyListeners();
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      _isLoading = false;
      if (response.success) {
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Failed to change password';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

