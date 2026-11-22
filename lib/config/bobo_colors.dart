import 'package:flutter/material.dart';

/// AppThemeMode provides global reactive ThemeMode state across BoboNyenyak.
class AppThemeMode extends ChangeNotifier {
  static final AppThemeMode instance = AppThemeMode._internal();

  AppThemeMode._internal();

  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

/// Dynamic Theme Palette based on Dark or Light mode.
class BoboColors {
  final bool isDark;

  const BoboColors(this.isDark);

  static BoboColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoboColors(isDark);
  }

  // Backgrounds
  Color get bg => isDark ? const Color(0xFF0F1528) : const Color(0xFFF6F8FC);
  Color get cardBg => isDark ? const Color(0xFF182238) : Colors.white;
  Color get cardSecondaryBg => isDark ? const Color(0xFF222C46) : const Color(0xFFEDF2F9);
  Color get bottomNavBg => isDark ? const Color(0xFF0F1528) : Colors.white;

  // Text
  Color get textPrimary => isDark ? Colors.white : const Color(0xFF1B2A4A);
  Color get textSecondary => isDark ? Colors.white70 : const Color(0xFF5C6B8A);
  Color get textMuted => isDark ? Colors.white.withValues(alpha: 0.5) : const Color(0xFF8E99AF);

  // Borders & Dividers
  Color get border => isDark ? const Color(0xFF1E2846) : const Color(0xFFE2E8F0);
  Color get divider => isDark ? Colors.white10 : const Color(0xFFE2E8F0);

  // Accents (Consistent brand anchors across modes)
  Color get accentYellow => const Color(0xFFFBBF24);
  Color get accentPurple => const Color(0xFF818CF8);
  Color get accentGreen => const Color(0xFF34D399);
  Color get accentRed => const Color(0xFFEF4444);
  Color get accentGray => isDark ? const Color(0xFF263255) : const Color(0xFFCBD5E1);

  // Pill / Tag background
  Color get pillBg => isDark ? const Color(0xFF263255) : const Color(0xFFE8EEF8);
}
