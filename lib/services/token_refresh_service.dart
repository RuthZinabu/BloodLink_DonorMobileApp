import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bloodlink_donor_mobile_app/utils/jwt_utils.dart';
import 'package:bloodlink_donor_mobile_app/utils/navigation_service.dart';

class TokenRefreshService {
  static final TokenRefreshService _instance = TokenRefreshService._internal();
  factory TokenRefreshService() => _instance;
  TokenRefreshService._internal();

  static const String _baseUrl = 'https://bloodlink-backend-bpll.onrender.com';
  static const String _tokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Timer? _refreshTimer;
  bool _isRefreshing = false;

  /// Call after login or app startup to begin proactive token refresh scheduling.
  Future<void> scheduleRefresh() async {
    _refreshTimer?.cancel();

    final accessToken = await _storage.read(key: _tokenKey);
    if (accessToken == null || accessToken.isEmpty) return;

    final secondsLeft = JwtUtils.secondsUntilExpiry(accessToken);

    if (secondsLeft <= 0) {
      await _handleExpired();
      return;
    }

    // Fire 2 minutes before expiry, or in 10 seconds if expiry is very soon
    final delay = Duration(seconds: (secondsLeft - 120).clamp(10, secondsLeft));

    _refreshTimer = Timer(delay, () async {
      await _doRefresh();
    });
  }

  /// Cancel any pending refresh timer (call on logout).
  void cancel() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _isRefreshing = false;
  }

  Future<void> _doRefresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;

    try {
      final refreshToken = await _storage.read(key: _refreshTokenKey);
      if (refreshToken == null || refreshToken.isEmpty) {
        await _handleExpired();
        return;
      }

      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/auth/refresh'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final newAccessToken = body['access_token']?.toString() ?? '';
        final newRefreshToken = body['refresh_token']?.toString() ?? refreshToken;

        if (newAccessToken.isNotEmpty) {
          await _storage.write(key: _tokenKey, value: newAccessToken);
          await _storage.write(key: _refreshTokenKey, value: newRefreshToken);
          _isRefreshing = false;
          // Schedule the next refresh cycle
          await scheduleRefresh();
          return;
        }
      }

      // Non-200 response — refresh failed, session truly expired
      await _handleExpired();
    } catch (_) {
      // Network error during refresh — don't log out, try again in 60 seconds
      _isRefreshing = false;
      _refreshTimer = Timer(const Duration(seconds: 60), () async {
        await _doRefresh();
      });
    }
  }

  Future<void> _handleExpired() async {
    _isRefreshing = false;
    cancel();
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'user_role');
    NavigationService.redirectToLoginOnSessionExpiry();
  }

  /// Force an immediate refresh attempt (e.g., when a 401 is received).
  Future<bool> forceRefresh() async {
    if (_isRefreshing) return false;

    final refreshToken = await _storage.read(key: _refreshTokenKey);
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/auth/refresh'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final newAccessToken = body['access_token']?.toString() ?? '';
        final newRefreshToken = body['refresh_token']?.toString() ?? refreshToken;

        if (newAccessToken.isNotEmpty) {
          await _storage.write(key: _tokenKey, value: newAccessToken);
          await _storage.write(key: _refreshTokenKey, value: newRefreshToken);
          await scheduleRefresh();
          return true;
        }
      }
    } catch (_) {}

    return false;
  }
}
