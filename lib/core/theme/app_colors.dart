import 'package:flutter/material.dart';

class AppColors {
  // Primary Background
  static const Color background = Color(0xFF0D1650);
  static const Color backgroundDark = Color(0xFF090E35);
  static const Color backgroundLight = Color(0xFF162157);

  // Surface
  static const Color surface = Color(0xFF1A2766);
  static const Color surfaceLight = Color(0xFF1F2F7A);
  static const Color card = Color(0xFF1E2D70);

  // Accent - Rose Gold
  static const Color accent = Color(0xFFC9956B);
  static const Color accentLight = Color(0xFFDFB896);
  static const Color accentDark = Color(0xFFAA7550);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0AABF);
  static const Color textHint = Color(0xFF6B7A9F);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);

  // Misc
  static const Color divider = Color(0xFF2A3680);
  static const Color shimmerBase = Color(0xFF1E2D70);
  static const Color shimmerHighlight = Color(0xFF2A3A8A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D1650), Color(0xFF090E35)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC9956B), Color(0xFFAA7550)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E2D70), Color(0xFF162157)],
  );

  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xDD090E35)],
  );
}
