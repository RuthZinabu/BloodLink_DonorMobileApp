import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrL = 'https://bloodlink-backend-bpll.onrender.com';
  static const String _tokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _secureStorage;

  ApiService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Register a new donor
  Future<Map<String, dynamic>> registerDonor({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String address,
    required DateTime birthDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrL/api/auth/register-donor'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'password': password,
          'address': address,
          'birth_date': birthDate.toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message'] ??
              'Donor registered successfully',
        };
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorBody['message'] ?? 'Registration failed',
        };
      } else {
        return {
          'success': false,
          'message': 'Registration failed: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrL/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final accessToken = responseBody['access_token'] ?? '';
        final refreshToken = responseBody['refresh_token'] ?? '';

        // Store tokens securely
        await _secureStorage.write(key: _tokenKey, value: accessToken);
        await _secureStorage.write(
            key: _refreshTokenKey, value: refreshToken);

        return {
          'success': true,
          'message': responseBody['message'] ?? 'Login successful',
          'accessToken': accessToken,
          'refreshToken': refreshToken,
          'role': responseBody['role'],
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Invalid email or password',
        };
      } else {
        return {
          'success': false,
          'message': 'Login failed: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Logout user
  Future<Map<String, dynamic>> logout() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);

      if (token == null) {
        return {
          'success': false,
          'message': 'No active session',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrL/api/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        // Clear stored tokens
        await _secureStorage.delete(key: _tokenKey);
        await _secureStorage.delete(key: _refreshTokenKey);

        return {
          'success': true,
          'message': 'Logged out successfully',
        };
      } else {
        // Still clear tokens locally even if server request fails
        await _secureStorage.delete(key: _tokenKey);
        await _secureStorage.delete(key: _refreshTokenKey);

        return {
          'success': true,
          'message': 'Session cleared',
        };
      }
    } catch (e) {
      // Clear tokens even on network error
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);

      return {
        'success': true,
        'message': 'Session cleared',
      };
    }
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  /// Get stored refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Clear all stored credentials
  Future<void> clearCredentials() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }
}
