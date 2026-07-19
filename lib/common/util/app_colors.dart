import 'package:flutter/material.dart';

class AppColors {
  // Primary Red
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color lightRed = Color(0xFFEF5350);
  static const Color darkRed = Color(0xFFB71C1C);

  // Primary Blue
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF1E88E5);
  static const Color darkBlue = Color(0xFF0D47A1);

  // Navy Shades
  static final Color navyDark =
  Color.lerp(primaryBlue, Colors.black, 0.62)!;

  static final Color navyLight =
  Color.lerp(primaryBlue, Colors.black, 0.35)!;

  // Accent
  static const Color accentRed = Color(0xFFFF1744);
  static const Color accentBlue = Color(0xFF2979FF);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryRed, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient redGradient = LinearGradient(
    colors: [lightRed, darkRed],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF212121);
  static const Color textGrey = Color(0xFF757575);
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color errorColor = Color(0xFFC62828);
}