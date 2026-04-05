import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Color(0xFF192232),
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2A3A4D),
  );

  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Color(0xFF162231),
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF5B6777),
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF4C5A6A),
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Color(0xFF7A8A9F),
  );

  static const TextTheme textTheme = TextTheme(
    displayLarge: heading,
    headlineSmall: subheading,
    titleLarge: title,
    titleMedium: subtitle,
    bodyLarge: body,
    bodyMedium: label,
  );
}
