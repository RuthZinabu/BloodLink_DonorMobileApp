import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';
import 'token_refresh_service.dart';

class AuthManager {
  late ApiService _apiService;
  late FlutterSecureStorage _secureStorage;

  static String? _currentUserRole;
  static String? _currentUserEmail;

  AuthManager({
    ApiService? apiService,
    FlutterSecureStorage? secureStorage,
  }) {
    _secureStorage = secureStorage ?? const FlutterSecureStorage();
    _apiService = apiService ?? ApiService(secureStorage: _secureStorage);
  }

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
      final result = await _apiService.registerDonor(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        address: address,
        birthDate: birthDate,
      );

      if (result['success']) {
        _currentUserEmail = email;
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'message': 'Registration error: ${e.toString()}',
      };
    }
  }

  /// Login user — starts proactive token refresh after successful login.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _apiService.login(
        email: email,
        password: password,
      );

      if (result['success']) {
        _currentUserEmail = email;
        _currentUserRole = result['role'];
        await _secureStorage.write(key: 'user_email', value: email);
        await _secureStorage.write(key: 'user_role', value: result['role']);
        // Start proactive token refresh in the background
        TokenRefreshService().scheduleRefresh();
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'message': 'Login error: ${e.toString()}',
      };
    }
  }

  /// Logout user — cancels any pending refresh timer.
  Future<Map<String, dynamic>> logout() async {
    try {
      // Cancel refresh before calling logout endpoint
      TokenRefreshService().cancel();

      final result = await _apiService.logout();

      if (result['success']) {
        _currentUserRole = null;
        _currentUserEmail = null;
        await _secureStorage.delete(key: 'user_email');
        await _secureStorage.delete(key: 'user_role');
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'message': 'Logout error: ${e.toString()}',
      };
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _apiService.isLoggedIn();
  }

  /// Get current user email
  Future<String?> getCurrentUserEmail() async {
    return _currentUserEmail ??
        await _secureStorage.read(key: 'user_email');
  }

  /// Get current user role
  Future<String?> getCurrentUserRole() async {
    return _currentUserRole ?? await _secureStorage.read(key: 'user_role');
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _apiService.getAccessToken();
  }

  /// Get access token for API calls
  Future<String?> getAuthHeader() async {
    final token = await _apiService.getAccessToken();
    return token != null ? 'Bearer $token' : null;
  }
}
