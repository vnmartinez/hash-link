import 'package:flutter/material.dart';

/// AppColors defines the color palette used throughout the application.
/// This class provides a centralized way to manage and access all color values.
class AppColors {
  /// Primary Colors
  /// These colors form the main brand identity of the application
  static const primary = Color(0xFF00ADB5); // Turquoise blue - Main brand color
  static const secondary =
      Color(0xFF393E46); // Dark grey - Secondary brand color
  static const accent = Color(0xFF222831); // Darker grey - Accent color

  /// State Colors
  /// Used to represent different states and feedback in the application
  static const success =
      Color(0xFF34A853); // Green - Indicates successful actions
  static const error = Color(0xFFEA4335); // Red - Indicates errors or failures
  static const warning = Color(0xFFFBBC04); // Yellow - Indicates warnings
  static const info =
      Color(0xFF00ADB5); // Matches primary - Used for informational elements

  /// Grey Scale
  /// A comprehensive set of grey shades for various UI elements
  static const grey50 = Color(0xFFFAFAFA); // Lightest grey
  static const grey100 = Color(0xFFF5F5F5);
  static const grey200 = Color(0xFFEEEEEE);
  static const grey300 = Color(0xFFE0E0E0);
  static const grey500 = Color(0xFF9E9E9E); // Medium grey
  static const grey700 = Color(0xFF616161);
  static const grey900 = Color(0xFF212121); // Darkest grey

  /// Surface Colors
  /// Used for different surface levels and backgrounds in the application
  static const background = Color(0xFFEEEEEE); // Light grey background
  static const surface = Color(0xFFEEEEEE); // Matches background
  static const surfaceVariant = Color(0xFF393E46); // Dark grey surface
  static const surfaceDark = Color(0xFF222831); // Darker grey surface
}
