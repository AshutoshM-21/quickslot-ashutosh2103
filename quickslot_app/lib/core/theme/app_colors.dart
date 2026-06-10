import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF111827);

  // Cult.fit-inspired dark teal palette
  static const Color background = Color(0xFF121F21);
  static const Color backgroundDeep = Color(0xFF0D1618);
  static const Color surface = Color(0xFF1A2B33);
  static const Color surfaceElevated = Color(0xFF243338);
  static const Color border = Color(0xFF2D4248);
  static const Color borderLight = Color(0xFF1E2E32);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8BA3AD);
  static const Color textTertiary = Color(0xFF5C7B8A);

  static const Color primary = Color(0xFF5C8A9A);
  static const Color primaryDark = Color(0xFF4A606B);
  static const Color primaryLight = Color(0xFF243338);
  static const Color primaryMuted = Color(0xFF3E565B);

  static const Color chipSelected = Color(0xFFFFFFFF);
  static const Color chipSelectedText = Color(0xFF111827);
  static const Color dateSelected = Color(0xFF3E565B);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFF2D1F1F);

  static const Color available = Color(0xFF5C8A9A);
  static const Color availableLight = Color(0xFF2A3F45);
  static const Color booked = Color(0xFF5C7B8A);
  static const Color bookedLight = Color(0xFF1E2E32);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, backgroundDeep],
  );

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}
