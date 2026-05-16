// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:bloodlink_donor_mobile_app/models/app_notification.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static const String baseUrl = 'https://bloodlink-backend-bpll.onrender.com';
//   static const String _tokenKey = 'access_token';
//   static const String _fcmTokenKey = 'fcm_token';

//   final FlutterSecureStorage _secureStorage;
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

//   NotificationService({FlutterSecureStorage? secureStorage})
//       : _secureStorage = secureStorage ?? const FlutterSecureStorage();

//   /// Initialize Firebase and local notifications
//   Future<void> initialize() async {
//     // Initialize Firebase
//     await Firebase.initializeApp();

//     // Initialize local notifications
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/launcher_icon');

//     const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     await _localNotifications.initialize(settings);

//     // Request permissions
//     await _requestPermissions();

//     // Set up background message handler
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Handle foreground messages
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

//     // Handle when app is opened from notification
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

//     // Get and store FCM token
//     await _setupFCMToken();
//   }

//   /// Request notification permissions
//   Future<void> _requestPermissions() async {
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     print('User granted permission: ${settings.authorizationStatus}');
//   }

//   /// Set up FCM token and send to backend
//   Future<void> _setupFCMToken() async {
//     try {
//       String? token = await _firebaseMessaging.getToken();
//       if (token != null) {
//         // Store locally
//         await _secureStorage.write(key: _fcmTokenKey, value: token);

//         // Send to backend
//         await _sendTokenToBackend(token);
//       }

//       // Listen for token updates
//       _firebaseMessaging.onTokenRefresh.listen((newToken) async {
//         await _secureStorage.write(key: _fcmTokenKey, value: newToken);
//         await _sendTokenToBackend(newToken);
//       });
//     } catch (e) {
//       print('Error setting up FCM token: $e');
//     }
//   }

//   /// Send FCM token to backend
//   Future<void> _sendTokenToBackend(String token) async {
//     try {
//       final accessToken = await _getAccessToken();
//       if (accessToken == null) return;

//       final response = await http.post(
//         Uri.parse('$baseUrl/api/notifications/register-device'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//         },
//         body: jsonEncode({
//           'fcm_token': token,
//           'platform': 'mobile',
//         }),
//       );

//       if (response.statusCode != 200) {
//         print('Failed to register device token: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error sending token to backend: $e');
//     }
//   }

//   /// Handle foreground messages
//   void _handleForegroundMessage(RemoteMessage message) {
//     _showLocalNotification(message);
//   }

//   /// Handle when app is opened from notification
//   void _handleMessageOpenedApp(RemoteMessage message) {
//     // Handle navigation based on notification type
//     print('App opened from notification: ${message.data}');
//   }

//   /// Show local notification
//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'bloodlink_channel',
//       'BloodLink Notifications',
//       channelDescription: 'Notifications for blood donation requests and updates',
//       importance: Importance.high,
//       priority: Priority.high,
//       icon: '@mipmap/launcher_icon',
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotifications.show(
//       message.hashCode,
//       message.notification?.title ?? 'BloodLink',
//       message.notification?.body ?? 'You have a new notification',
//       details,
//       payload: jsonEncode(message.data),
//     );
//   }

//   /// Get stored access token
//   Future<String?> _getAccessToken() async {
//     return await _secureStorage.read(key: _tokenKey);
//   }

//   /// Get authentication headers
//   Future<Map<String, String>> _getHeaders({bool authenticated = false}) async {
//     final headers = <String, String>{'Content-Type': 'application/json'};
//     if (authenticated) {
//       final token = await _getAccessToken();
//       if (token == null || token.isEmpty) {
//         throw Exception('Authentication required');
//       }
//       headers['Authorization'] = 'Bearer $token';
//     }
//     return headers;
//   }

//   /// Fetch all notifications for the current user
//   Future<List<AppNotification>> fetchNotifications() async {
//     try {
//       final response = await http
//           .get(
//             Uri.parse('$baseUrl/api/notifications/'),
//             headers: await _getHeaders(authenticated: true),
//           )
//           .timeout(const Duration(seconds: 30));

//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//         List<dynamic> data;

//         if (body is List<dynamic>) {
//           data = body;
//         } else if (body is Map<String, dynamic> &&
//             body['data'] is List<dynamic>) {
//           data = body['data'] as List<dynamic>;
//         } else {
//           throw Exception('Unexpected notifications response format');
//         }

//         return data
//             .map((json) =>
//                 AppNotification.fromJson(json as Map<String, dynamic>))
//             .toList();
//       } else if (response.statusCode == 204) {
//         return [];
//       } else if (response.statusCode == 401 || response.statusCode == 403) {
//         throw Exception('Authentication required');
//       } else {
//         throw Exception('Failed to load notifications: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Network error: ${e.toString()}');
//     }
//   }

//   /// Mark a specific notification as read
//   Future<void> markNotificationAsRead(String notificationId) async {
//     try {
//       final response = await http
//           .put(
//             Uri.parse('$baseUrl/api/notifications/$notificationId/read'),
//             headers: await _getHeaders(authenticated: true),
//           )
//           .timeout(const Duration(seconds: 30));

//       if (response.statusCode != 200) {
//         throw Exception(
//             'Failed to mark notification as read: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Network error: ${e.toString()}');
//     }
//   }

//   /// Mark all notifications as read
//   Future<void> markAllNotificationsAsRead() async {
//     try {
//       final response = await http
//           .put(
//             Uri.parse('$baseUrl/api/notifications/read-all'),
//             headers: await _getHeaders(authenticated: true),
//           )
//           .timeout(const Duration(seconds: 30));

//       if (response.statusCode != 200) {
//         throw Exception(
//             'Failed to mark all notifications as read: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Network error: ${e.toString()}');
//     }
//   }

//   /// Get unread notification count
//   Future<int> getUnreadNotificationCount() async {
//     try {
//       final notifications = await fetchNotifications();
//       return notifications.where((notification) => !notification.isRead).length;
//     } catch (e) {
//       return 0; // Return 0 on error to avoid breaking the UI
//     }
//   }
// }

// /// Background message handler for FCM
// /// This function must be a top-level function (not inside a class)
// /// and is required for handling messages when the app is in background/terminated
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Initialize Firebase if not already initialized
//   await Firebase.initializeApp();

//   print('Handling background message: ${message.messageId}');

//   // You can perform additional processing here if needed
//   // For example, update local database, send analytics, etc.
// }
