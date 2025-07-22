import 'package:flutter/material.dart';

class AppColors {
  // Netflix kırmızısı
  static const Color primary = Color(0xFFE50914);

  // Dark theme colors
  static const Color background = Color(0xff090909);
  static const Color surface = Color(0xFF2A2A2A);
  static const Color onSurface = Colors.white;
  static const Color onSurfaceVariant = Color(0xFF9E9E9E);

  // Gradient colors
  static const Color gradientStart = Color(0xFFE53E3E);
  static const Color gradientEnd = Color(0xFFD53F8C);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textHint = Color(0xFF757575);

  // Status colors
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;

  // Button gradients
  static const Color primaryGradient = Color(0xffE50914);

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
