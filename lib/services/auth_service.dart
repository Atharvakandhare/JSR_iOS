import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/api_response.dart';
import '../utils/constants.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  static Future<ApiResponse<LoginResponse>> login({
    required String username,
    required String password,
    String? twoFactorToken,
  }) async {
    final body = {
      'username': username,
      'password': password,
      if (twoFactorToken != null) 'twoFactorToken': twoFactorToken,
    };

    try {
      final rawResponse = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final jsonData = jsonDecode(rawResponse.body) as Map<String, dynamic>;
      
      // Handle 2FA requirement (backend returns requires2FA at root level with success: false)
      if (jsonData['requires2FA'] == true) {
        return ApiResponse<LoginResponse>(
          success: false,
          message: jsonData['message'] as String? ?? '2FA token required',
          data: LoginResponse(requires2FA: true),
        );
      }

      if (rawResponse.statusCode >= 200 && rawResponse.statusCode < 300 && jsonData['success'] == true) {
        final loginData = LoginResponse.fromJson(jsonData['data'] as Map<String, dynamic>);
        
        // Save token and user
        if (loginData.token != null) {
          await StorageService.saveToken(loginData.token!);
          ApiService.setToken(loginData.token);
        }
        
        if (loginData.user != null) {
          await StorageService.saveUser(jsonEncode(loginData.user!.toJson()));
        }

        return ApiResponse<LoginResponse>(
          success: true,
          message: jsonData['message'] as String?,
          data: loginData,
        );
      }

      return ApiResponse<LoginResponse>(
        success: false,
        message: jsonData['message'] as String? ?? 'Login failed',
      );
    } catch (e) {
      return ApiResponse<LoginResponse>(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  static Future<ApiResponse<User>> getCurrentUser() async {
    final response = await ApiService.get<Map<String, dynamic>>(
      ApiConstants.me,
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return ApiResponse<User>(
        success: true,
        data: User.fromJson(response.data!),
      );
    }

    return ApiResponse<User>(
      success: false,
      message: response.message,
    );
  }

  static Future<ApiResponse<void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await ApiService.post<void>(
      ApiConstants.changePassword,
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );

    return response;
  }

  static Future<ApiResponse<Map<String, dynamic>>> setup2FA() async {
    final response = await ApiService.post<Map<String, dynamic>>(
      ApiConstants.setup2FA,
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return response;
  }

  static Future<ApiResponse<void>> verify2FA(String token) async {
    final response = await ApiService.post<void>(
      ApiConstants.verify2FA,
      body: {'token': token},
    );

    return response;
  }

  static Future<ApiResponse<void>> disable2FA(String token) async {
    final response = await ApiService.post<void>(
      ApiConstants.disable2FA,
      body: {'token': token},
    );

    return response;
  }

  static Future<void> logout() async {
    await StorageService.removeToken();
    await StorageService.removeUser();
    ApiService.setToken(null);
  }
}

class LoginResponse {
  final String? token;
  final User? user;
  final bool requires2FA;

  LoginResponse({
    this.token,
    this.user,
    this.requires2FA = false,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      requires2FA: json['requires2FA'] as bool? ?? false,
    );
  }
}

