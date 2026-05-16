import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> redirectToLoginOnSessionExpiry() async {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );

    await Future.delayed(const Duration(milliseconds: 300));

    final newContext = navigatorKey.currentContext;
    if (newContext != null && newContext.mounted) {
      ScaffoldMessenger.of(newContext).showSnackBar(
        const SnackBar(
          content: Text(
            'Your session has expired. Please log in again.',
          ),
          backgroundColor: Color(0xFFE53935),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
