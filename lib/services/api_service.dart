import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bloodlink_donor_mobile_app/models/campaign.dart';
import 'package:bloodlink_donor_mobile_app/models/donation.dart';
import 'package:bloodlink_donor_mobile_app/models/test_result.dart';
import 'package:bloodlink_donor_mobile_app/models/badge.dart';
import 'package:bloodlink_donor_mobile_app/models/leaderboard_entry.dart';
import 'package:bloodlink_donor_mobile_app/models/emergency.dart';

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
          'birth_date': "${birthDate.year.toString().padLeft(4, '0')}-"
              "${birthDate.month.toString().padLeft(2, '0')}-"
              "${birthDate.day.toString().padLeft(2, '0')}T00:00:00Z",
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

  /// Forgot password
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrL/api/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseBody['message'] ?? 'Password reset email sent',
        };
      } else {
        final errorBody = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorBody['message'] ?? 'Failed to send reset email',
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

  /// Retrieve the current user's profile from the backend.
  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final token = await getAccessToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'User is not authenticated.',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrL/api/protected/profile'),
        headers: await _getHeaders(authenticated: true),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return {
          'success': true,
          'profile': decoded is Map<String, dynamic> && decoded.containsKey('data')
              ? decoded['data']
              : decoded,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to load profile: ${response.statusCode}',
        };
      }
    } catch (e) {
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

      final response = await http.patch(
        Uri.parse('$baseUrL/api/protected/profile'),
        headers: await _getHeaders(authenticated: true),
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return {
          'success': true,
          'message': decoded['message'] ?? 'Profile updated successfully',
          'profile': decoded is Map<String, dynamic> && decoded.containsKey('data')
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
      final response = await http.get(
        Uri.parse('$baseUrL/api/donor/donations'),
        headers: await _getHeaders(authenticated: true),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded
              .map((item) => Donation.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Retrieve the top donor leaderboard for the current donor role.
  Future<List<LeaderboardEntry>> fetchLeaderboard({int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrL/api/donor/leaderboard?limit=$limit'),
        headers: await _getHeaders(authenticated: true),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final leaderboardData = decoded is Map<String, dynamic> && decoded.containsKey('leaderboard')
            ? decoded['leaderboard']
            : [];

        if (leaderboardData is List) {
          return leaderboardData
              .map((item) => LeaderboardEntry.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Retrieve the current user's awarded badges.
  Future<List<Badge>> fetchBadges() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrL/api/donor/badges'),
        headers: await _getHeaders(authenticated: true),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final badgeData = decoded is Map<String, dynamic> && decoded.containsKey('badges')
            ? decoded['badges']
            : [];

        if (badgeData is List) {
          return badgeData
              .map((item) => Badge.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Retrieve the current user's latest test result.
  Future<TestResult?> fetchLatestTestResult() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrL/api/donor/test-result/latest'),
        headers: await _getHeaders(authenticated: true),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return TestResult.fromJson(decoded);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fetch emergencies for the logged-in donor from the backend.
  Future<List<Emergency>> fetchEmergencies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrL/api/donor/emergencies'),
        headers: await _getHeaders(authenticated: true),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.map((item) => Emergency.fromJson(item as Map<String, dynamic>)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load emergencies: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Fetch nearby emergencies based on donor's location.
  Future<List<Emergency>> fetchNearbyEmergencies(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrL/api/donor/emergencies/nearby?lat=$latitude&lng=$longitude'),
        headers: await _getHeaders(authenticated: true),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.map((item) => Emergency.fromJson(item as Map<String, dynamic>)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load nearby emergencies: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Fetch public campaigns from the backend.
  Future<List<Campaign>> fetchCampaigns() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrL/api/campaigns/'),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final campaignsData = decoded is Map<String, dynamic> && decoded.containsKey('data')
            ? decoded['data']
            : decoded;

        if (campaignsData is List) {
          return campaignsData.map((item) => Campaign.fromJson(item as Map<String, dynamic>)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load campaigns: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
