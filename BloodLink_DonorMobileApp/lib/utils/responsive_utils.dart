import 'package:flutter/material.dart';

/// Responsive utilities for mobile app UI scaling across different screen sizes.
/// 
/// This class provides helper methods to scale UI elements based on screen dimensions,
/// ensuring a consistent and responsive experience across devices.
class ResponsiveUtils {
  /// Screen width (dp)
  final double screenWidth;

  /// Screen height (dp)
  final double screenHeight;

  /// Device pixel ratio
  final double devicePixelRatio;

  /// Orientation
  final Orientation orientation;

  ResponsiveUtils({
    required this.screenWidth,
    required this.screenHeight,
    required this.devicePixelRatio,
    required this.orientation,
  });

  /// Factory constructor from BuildContext
  factory ResponsiveUtils.of(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return ResponsiveUtils(
      screenWidth: mediaQuery.size.width,
      screenHeight: mediaQuery.size.height,
      devicePixelRatio: mediaQuery.devicePixelRatio,
      orientation: mediaQuery.orientation,
    );
  }

  /// Get responsive width as percentage of screen width
  double getWidth(double percentage) => screenWidth * (percentage / 100);

  /// Get responsive height as percentage of screen height
  double getHeight(double percentage) => screenHeight * (percentage / 100);

  /// Get responsive padding/margin
  double getPadding(double baseValue) {
    if (screenWidth < 360) return baseValue * 0.7; // Extra small
    if (screenWidth < 600) return baseValue * 0.9; // Small
    if (screenWidth < 900) return baseValue; // Medium
    return baseValue * 1.2; // Large
  }

  /// Get responsive font size based on screen width
  /// 
  /// Small devices (< 360): 0.7x base
  /// Small devices (360-600): 0.9x base
  /// Medium devices (600-900): 1.0x base
  /// Large devices (900+): 1.2x base
  double getFont(double baseSize) {
    if (screenWidth < 360) return baseSize * 0.7;
    if (screenWidth < 600) return baseSize * 0.9;
    if (screenWidth < 900) return baseSize;
    return baseSize * 1.2;
  }

  /// Get responsive icon size
  double getIconSize(double baseSize) => getFont(baseSize);

  /// Get responsive border radius
  double getBorderRadius(double baseRadius) {
    if (screenWidth < 360) return baseRadius * 0.8;
    if (screenWidth < 600) return baseRadius * 0.9;
    if (screenWidth < 900) return baseRadius;
    return baseRadius * 1.1;
  }

  /// Get responsive elevation/shadow
  double getElevation(double baseElevation) {
    if (screenWidth < 600) return baseElevation * 0.8;
    return baseElevation;
  }

  /// Check if device is small (phone)
  bool get isSmallScreen => screenWidth < 600;

  /// Check if device is medium (tablet portrait)
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 900;

  /// Check if device is large (tablet landscape or large phone)
  bool get isLargeScreen => screenWidth >= 900;

  /// Check if in portrait orientation
  bool get isPortrait => orientation == Orientation.portrait;

  /// Check if in landscape orientation
  bool get isLandscape => orientation == Orientation.landscape;

  /// Get safe area padding considering notches/system UI
  EdgeInsets getSafeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return EdgeInsets.only(
      top: mediaQuery.padding.top,
      bottom: mediaQuery.padding.bottom,
      left: mediaQuery.padding.left,
      right: mediaQuery.padding.right,
    );
  }

  /// Get responsive horizontal padding
  EdgeInsets getHorizontalPadding(double baseHPadding, {double? verticalPadding}) {
    return EdgeInsets.symmetric(
      horizontal: getPadding(baseHPadding),
      vertical: verticalPadding != null ? getPadding(verticalPadding) : 0,
    );
  }

  /// Get responsive symmetric padding
  EdgeInsets getSymmetricPadding({
    required double horizontal,
    required double vertical,
  }) {
    return EdgeInsets.symmetric(
      horizontal: getPadding(horizontal),
      vertical: getPadding(vertical),
    );
  }

  /// Get responsive all-sides padding
  EdgeInsets getAllPadding(double value) {
    return EdgeInsets.all(getPadding(value));
  }

  /// Get responsive container height for form inputs
  double getInputHeight() {
    if (screenWidth < 360) return 45;
    if (screenWidth < 600) return 50;
    return 56;
  }

  /// Get responsive button height
  double getButtonHeight() {
    if (screenWidth < 360) return 42;
    if (screenWidth < 600) return 48;
    return 54;
  }

  /// Get responsive spacing between elements
  double getSpacing({double small = 8, double medium = 16, double large = 24}) {
    if (screenWidth < 360) return small * 0.75;
    if (screenWidth < 600) return small;
    if (screenWidth < 900) return medium;
    return large;
  }

  /// Get max width for content on large screens (prevents content from being too wide)
  double getMaxContentWidth() {
    if (isSmallScreen) return screenWidth;
    if (isMediumScreen) return screenWidth * 0.9;
    return 600; // Max width on large screens
  }

  /// Calculate number of columns based on screen size
  int getGridColumns() {
    if (screenWidth < 360) return 1;
    if (screenWidth < 600) return 2;
    if (screenWidth < 900) return 3;
    return 4;
  }

  /// Get responsive image height
  double getImageHeight(double baseHeight) => getHeight(baseHeight);

  /// Get responsive max lines for text
  int getMaxLines(int defaultLines) {
    if (screenWidth < 360) return (defaultLines * 0.8).ceil();
    return defaultLines;
  }
}

/// Extension on BuildContext for easy access to responsive utilities
extension ResponsiveX on BuildContext {
  ResponsiveUtils get responsive => ResponsiveUtils.of(this);

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isSmallScreen => screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 900;
  bool get isLargeScreen => screenWidth >= 900;
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;
}

/// LayoutBuilder wrapper for easier responsive design
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveUtils responsive) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaQuery = MediaQuery.of(context);
        final responsive = ResponsiveUtils(
          screenWidth: constraints.maxWidth,
          screenHeight: constraints.maxHeight,
          devicePixelRatio: mediaQuery.devicePixelRatio,
          orientation: mediaQuery.orientation,
        );
        return builder(context, responsive);
      },
    );
  }
}
