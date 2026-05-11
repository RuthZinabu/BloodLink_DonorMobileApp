import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bloodlink_donor_mobile_app/models/app_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static const String baseUrl = 'https://bloodlink-backend-bpll.onrender.com';
  static const String _tokenKey = 'access_token';
  static const String _fcmTokenKey = 'fcm_token';

  final FlutterSecureStorage _secureStorage;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  NotificationService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Get stored access token
  Future<String?> _getAccessToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  /// Get authentication headers
  Future<Map<String, String>> _getHeaders({bool authenticated = false}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authenticated) {
      final token = await _getAccessToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication required');
      }
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Fetch all notifications for the current user
  Future<List<AppNotification>> fetchNotifications() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/notifications/'),
            headers: await _getHeaders(authenticated: true),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        List<dynamic> data;

        if (body is List<dynamic>) {
          data = body;
        } else if (body is Map<String, dynamic> &&
            body['data'] is List<dynamic>) {
          data = body['data'] as List<dynamic>;
        } else {
          throw Exception('Unexpected notifications response format');
        }

        return data
            .map((json) =>
                AppNotification.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 204) {
        return [];
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Authentication required');
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Mark a specific notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/api/notifications/$notificationId/read'),
            headers: await _getHeaders(authenticated: true),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark notification as read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllNotificationsAsRead() async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/api/notifications/read-all'),
            headers: await _getHeaders(authenticated: true),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark all notifications as read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Get unread notification count
  Future<int> getUnreadNotificationCount() async {
    try {
      final notifications = await fetchNotifications();
      return notifications.where((notification) => !notification.isRead).length;
    } catch (e) {
      return 0; // Return 0 on error to avoid breaking the UI
    }
  }
}
