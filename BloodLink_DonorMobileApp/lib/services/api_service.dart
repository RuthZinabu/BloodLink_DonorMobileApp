import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloodlink_donor_mobile_app/models/campaign.dart';
import 'package:bloodlink_donor_mobile_app/models/donation.dart';
import 'package:bloodlink_donor_mobile_app/models/test_result.dart';
import 'package:bloodlink_donor_mobile_app/models/badge.dart';
import 'package:bloodlink_donor_mobile_app/models/leaderboard_entry.dart';
import 'package:bloodlink_donor_mobile_app/models/emergency.dart';
import 'package:bloodlink_donor_mobile_app/models/blood_request.dart';
import 'package:bloodlink_donor_mobile_app/utils/navigation_service.dart';
import 'package:bloodlink_donor_mobile_app/services/token_refresh_service.dart';

class ApiService {
  static const String baseUrL = 'https://bloodlink-backend-bpll.onrender.com';
  static const String _tokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _cacheProfileKey = 'cache_profile';
  static const String _cacheDonationsKey = 'cache_donations';
  static const String _cacheEmergenciesKey = 'cache_emergencies';
  static const String _cacheCampaignsKey = 'cache_campaigns';
  static const String _cacheMyRequestsKey = 'cache_my_requests';

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
      final response = await http
          .post(
            Uri.parse('$baseUrL/api/auth/register-donor'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'full_name': fullName,
              'email': email,
              'phone': phone,
              'password': password,
              'address': address,
              'birth_date': "${birthDate.year.toString().padLeft(4, '0')}-"
                  "${birthDate.month.toString().padLeft(2, '0')}-"
                  "${birthDate.day.toString().padLeft(2, '0')}T00:00:00Z",
            }),
          )
          .timeout(const Duration(seconds: 30));

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
          'message': 'Registration failed: ${response.body}',
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
      final response = await http
          .post(
            Uri.parse('$baseUrL/api/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final accessToken = responseBody['access_token'] ?? '';
        final refreshToken = responseBody['refresh_token'] ?? '';

        // Store tokens securely
        await _secureStorage.write(key: _tokenKey, value: accessToken);
        await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);

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

  /// Forgot password — sends OTP to the registered email
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrL/api/auth/forgot-password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseBody['message'] ??
              'Password reset OTP sent to your email',
        };
      } else {
        final errorBody = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorBody['error'] ??
              errorBody['message'] ??
              'Failed to send reset OTP',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Reset password — verifies OTP and sets the new password
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrL/api/auth/reset-password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'otp': otp,
              'new_password': newPassword,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseBody['message'] ?? 'Password reset successfully',
        };
      } else {
        final errorBody = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorBody['error'] ??
              errorBody['message'] ??
              'Failed to reset password',
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

  Future<Map<String, String>> _getHeaders({bool authenticated = false}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authenticated) {
      final token = await getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<void> _writeCache(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  Future<dynamic> _readCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    return jsonDecode(raw);
  }

  /// Call this whenever an authenticated endpoint returns 401.
  /// First attempts a silent token refresh using the stored refresh token.
  /// If the refresh succeeds the session is silently restored.
  /// If it fails all credentials are cleared and the user is redirected to login.
  Future<void> _handleUnauthorized() async {
    final refreshed = await TokenRefreshService().forceRefresh();
    if (refreshed) {
      // Session silently restored — the next request will use the new token.
      return;
    }
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: 'user_email');
    await _secureStorage.delete(key: 'user_role');
    NavigationService.redirectToLoginOnSessionExpiry();
  }

  /// Retrieve the current user's profile from the backend.
  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final token = await getAccessToken();
      if (token == null || token.isEmpty) {
        await _handleUnauthorized();
        return {
          'success': false,
          'message': 'Session expired. Please log in again.'
        };
      }

      final response = await http
          .get(
            Uri.parse('$baseUrL/api/protected/profile'),
            headers: await _getHeaders(authenticated: true),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final profile =
            decoded is Map<String, dynamic> && decoded.containsKey('data')
                ? decoded['data']
                : decoded;
        await _writeCache(_cacheProfileKey, profile);
        return {
          'success': true,
          'profile': profile,
        };
      } else if (response.statusCode == 401) {
        await _handleUnauthorized();
        return {
          'success': false,
          'message': 'Session expired. Please log in again.'
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to load profile: ${response.statusCode}',
        };
      }
    } catch (e) {
      final cached = await _readCache(_cacheProfileKey);
      if (cached != null) {
        return {
          'success': true,
          'profile': cached,
          'message': 'Showing cached profile data due to network interruption.',
          'isCached': true,
        };
      }
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Update the current user's profile.
  Future<Map<String, dynamic>> updateUserProfile({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? photoUrl,
  }) async {
    try {
      final token = await getAccessToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'User is not authenticated.',
        };
      }

      final body = <String, dynamic>{};
      if (fullName != null) body['full_name'] = fullName;
      if (email != null) body['email'] = email;
      if (phone != null) body['phone'] = phone;
      if (address != null) body['address'] = address;
      if (photoUrl != null) body['profile_picture_url'] = photoUrl;

      final response = await http
          .patch(
            Uri.parse('$baseUrL/api/protected/profile'),
            headers: await _getHeaders(authenticated: true),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return {
          'success': true,
          'message': decoded['message'] ?? 'Profile updated successfully',
          'profile':
              decoded is Map<String, dynamic> && decoded.containsKey('data')
                  ? decoded['data']
                  : decoded,
        };
      } else {
        final decoded = jsonDecode(response.body);
        return {
          'success': false,
          'message': decoded['message'] ?? 'Failed to update profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Retrieve the current user's donations.
  Future<List<Donation>> fetchDonations() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrL/api/donor/donations'),
            headers: await _getHeaders(authenticated: true),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          final donations = decoded
              .map((item) => Donation.fromJson(item as Map<String, dynamic>))
              .toList();
          await _writeCache(_cacheDonationsKey, decoded);
          return donations;
        }
      } else if (response.statusCode == 401) {
        await _handleUnauthorized();
      }
      final cached = await _readCache(_cacheDonationsKey);
      if (cached is List) {
        return cached
            .map((item) => Donation.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      final cached = await _readCache(_cacheDonationsKey);
      if (cached is List) {
        return cached
            .map((item) => Donation.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    }
  }

  /// Retrieve the top donor leaderboard for the current donor role.
  Future<List<LeaderboardEntry>> fetchLeaderboard({int limit = 10}) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrL/api/donor/leaderboard?limit=$limit'),
            headers: await _getHeaders(authenticated: true),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final leaderboardData = decoded is Map<String, dynamic> &&
                decoded.containsKey('leaderboard')
            ? decoded['leaderboard']
            : [];

        if (leaderboardData is List) {
          return leaderboardData
              .map((item) =>
                  LeaderboardEntry.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      } else if (response.statusCode == 401) {
        await _handleUnauthorized();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Retrieve the current user's awarded badges.
  Future<List<Badge>> fetchBadges() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrL/api/donor/badges'),
            headers: await _getHeaders(authenticated: true),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final badgeData =
            decoded is Map<String, dynamic> && decoded.containsKey('badges')
                ? decoded['badges']
                : [];

        if (badgeData is List) {
          return badgeData
              .map((item) => Badge.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      } else if (response.statusCode == 401) {
        await _handleUnauthorized();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Retrieve the current user's latest test result.
  Future<TestResult?> fetchLatestTestResult() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrL/api/donor/test-result/latest'),
            headers: await _getHeaders(authenticated: true),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return TestResult.fromJson(decoded);
        }
      } else if (response.statusCode == 401) {
        await _handleUnauthorized();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fetch published emergency requests from the backend.
  Future<List<Emergency>> fetchEmergencies() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrL/api/emergencies/published'),
            headers: await _getHeaders(authenticated: false),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          final emergencies = decoded
              .map((item) => Emergency.fromJson(item as Map<String, dynamic>))
              .toList();
          await _writeCache(_cacheEmergenciesKey, decoded);
          return emergencies;
        } else {
          return [];
        }
      } else {
        final cached = await _readCache(_cacheEmergenciesKey);
        if (cached is List) {
          return cached
              .map((item) => Emergency.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        throw Exception('Failed to load emergencies: ${response.body}');
      }
    } catch (e) {
      final cached = await _readCache(_cacheEmergenciesKey);
      if (cached is List) {
        return cached
            .map((item) => Emergency.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Update the donor's current location on the backend.
  Future<bool> updateDonorLocation(double latitude, double longitude) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrL/api/donor/location'),
            headers: await _getHeaders(authenticated: true),
            body: jsonEncode({
              'latitude': latitude,
              'longitude': longitude,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Fetch public campaigns from the backend.
  Future<List<Campaign>> fetchCampaigns({
    String? title,
    String? location,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (title != null && title.isNotEmpty) queryParams['title'] = title;
      if (location != null && location.isNotEmpty)
        queryParams['location'] = location;
      if (startDate != null && startDate.isNotEmpty)
        queryParams['start_date'] = startDate;
      if (endDate != null && endDate.isNotEmpty)
        queryParams['end_date'] = endDate;

      final uri = Uri.parse('$baseUrL/api/campaigns/').replace(
          queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await http
          .get(uri, headers: await _getHeaders())
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final campaignsData = decoded is Map<String, dynamic>
            ? (decoded['campaigns'] ?? decoded['data'] ?? decoded)
            : decoded;

        if (campaignsData is List) {
          final campaigns = campaignsData
              .map((item) => Campaign.fromJson(item as Map<String, dynamic>))
              .toList();
          await _writeCache(_cacheCampaignsKey, campaignsData);
          return campaigns;
        } else {
          return [];
        }
      } else {
        final cached = await _readCache(_cacheCampaignsKey);
        if (cached is List) {
          return cached
              .map((item) => Campaign.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        throw Exception('Failed to load campaigns: ${response.statusCode}');
      }
    } catch (e) {
      final cached = await _readCache(_cacheCampaignsKey);
      if (cached is List) {
        return cached
            .map((item) => Campaign.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Create a blood request for the logged-in donor.
  Future<Map<String, dynamic>> createBloodRequest({
    required int units,
    required String componentType,
    required String reason,
    required String hospitalName,
    required String hospitalAddress,
    required String hospitalPhone,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrL/api/donor/blood-request'),
            headers: await _getHeaders(authenticated: true),
            body: jsonEncode({
              'units': units,
              'component_type': componentType,
              'reason': reason,
              'hospital_name': hospitalName,
              'hospital_address': hospitalAddress,
              'hospital_phone': hospitalPhone,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return {
          'success': true,
          'message':
              responseBody['message'] ?? 'Blood request created successfully',
        };
      } else if (response.statusCode == 401) {
        await _handleUnauthorized();
        return {
          'success': false,
          'message': 'Session expired. Please log in again.'
        };
      } else if (response.statusCode == 403) {
        final errorBody = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorBody['error'] ??
              'Only top 10 leaderboard donors are eligible to request blood',
        };
      } else {
        final errorBody = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorBody['error'] ??
              'Failed to create blood request: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Fetch the logged-in donor's blood requests.
  /// Returns `{'requests': List<BloodRequest>, 'analytics': Map<String,int>}`
  Future<Map<String, dynamic>> fetchMyBloodRequests({
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    Map<String, int> _parseAnalytics(dynamic raw) {
      if (raw is Map) {
        int g(String k) {
          final v = raw[k];
          if (v is int) return v;
          return int.tryParse(v?.toString() ?? '') ?? 0;
        }
        return {
          'total_requests': g('total_requests'),
          'total_fulfilled': g('total_fulfilled'),
          'total_pending': g('total_pending'),
          'total_cancelled': g('total_cancelled'),
        };
      }
      return {};
    }

    List<BloodRequest> _parseList(List<dynamic> raw) =>
        raw.map((item) => BloodRequest.fromJson(item as Map<String, dynamic>)).toList();

    try {
      final queryParams = <String, String>{};
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (startDate != null && startDate.isNotEmpty) queryParams['start_date'] = startDate;
      if (endDate != null && endDate.isNotEmpty) queryParams['end_date'] = endDate;

      final uri = Uri.parse('$baseUrL/api/donor/my-requests')
          .replace(queryParameters: queryParams);

      final response = await http
          .get(uri, headers: await _getHeaders(authenticated: true))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // Scan every likely shape the backend might return:
        //   {data:{requests:[...],analytics:{...}}}
        //   {data:{data:[...],analytics:{...}}}
        //   {data:[...]}
        //   {requests:[...],analytics:{...}}
        //   [{...}]  (bare list at root)
        List<dynamic>? rawList;
        Map<String, int> analytics = {};

        if (decoded is List) {
          rawList = decoded;
        } else if (decoded['data'] is Map) {
          final d = decoded['data'] as Map;
          if (d['requests'] is List) {
            rawList = d['requests'] as List;
          } else if (d['data'] is List) {
            rawList = d['data'] as List;
          } else {
            // last resort: first List value inside data
            for (final v in d.values) {
              if (v is List) { rawList = v; break; }
            }
          }
          analytics = _parseAnalytics(d['analytics']);
        } else if (decoded['data'] is List) {
          rawList = decoded['data'] as List;
        } else if (decoded['requests'] is List) {
          rawList = decoded['requests'] as List;
          analytics = _parseAnalytics(decoded['analytics']);
        } else {
          // last resort: first List at top level
          for (final v in (decoded as Map).values) {
            if (v is List) { rawList = v; break; }
          }
        }

        final requests = _parseList(rawList ?? []);
        await _writeCache(_cacheMyRequestsKey, rawList ?? []);
        return {'requests': requests, 'analytics': analytics};
      } else if (response.statusCode == 401) {
        await _handleUnauthorized();
        final cached = await _readCache(_cacheMyRequestsKey);
        return {
          'requests': cached is List ? _parseList(cached) : <BloodRequest>[],
          'analytics': <String, int>{},
        };
      } else {
        final cached = await _readCache(_cacheMyRequestsKey);
        if (cached is List) {
          return {'requests': _parseList(cached), 'analytics': <String, int>{}};
        }
        throw Exception('Failed to load blood requests: ${response.body}');
      }
    } on TimeoutException catch (e) {
      final cached = await _readCache(_cacheMyRequestsKey);
      if (cached is List) {
        return {'requests': _parseList(cached), 'analytics': <String, int>{}};
      }
      throw Exception('Network error: ${e.toString()}');
    } on SocketException catch (e) {
      final cached = await _readCache(_cacheMyRequestsKey);
      if (cached is List) {
        return {'requests': _parseList(cached), 'analytics': <String, int>{}};
      }
      throw Exception('Network error: ${e.toString()}');
    } catch (e) {
      rethrow;
    }
  }
}
