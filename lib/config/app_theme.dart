import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// BoboNyenyak design system — colour palette, typography, and theme data.
class AppTheme {
  AppTheme._();

  // ─── Brand Colours ──────────────────────────────────────────────────
  static const Color midnightBlue = Color(0xFF1B2A4A);
  static const Color navyDark = Color(0xFF0F1B33);
  static const Color softLavender = Color(0xFFB8A9E8);
  static const Color babyBlue = Color(0xFFA8D4F0);
  static const Color warmCream = Color(0xFFFFF8F0);
  static const Color softWhite = Color(0xFFFAFAFC);
  static const Color accentGold = Color(0xFFFFD685);
  static const Color errorRed = Color(0xFFE57373);
  static const Color successGreen = Color(0xFF81C784);
  static const Color textPrimary = Color(0xFF1B2A4A);
  static const Color textSecondary = Color(0xFF5C6B8A);
  static const Color textLight = Color(0xFF8E99AF);
  static const Color divider = Color(0xFFE8ECF4);
  static const Color cardShadow = Color(0x1A1B2A4A);

  // ─── Gradients ──────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [midnightBlue, Color(0xFF2A3F6A)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F1B33), Color(0xFF1B2A4A), Color(0xFF2A3F6A)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF0F4FF), Color(0xFFF8F6FF)],
  );

  // ─── Spacing & Radii ───────────────────────────────────────────────
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusRound = 50.0;

  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // ─── Helper: Google Fonts dengan inherit: true ─────────────────────
  // Fungsi bantuan agar kita tidak perlu menulis .copyWith(inherit: true)
  // berulang kali.
  static TextStyle _poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    ).copyWith(inherit: true);
  }

  // ─── Helper TextTheme (Struktur identik untuk light & dark) ────────
  static TextTheme _buildTextTheme({
    required Color primaryColor,
    required Color secondaryColor,
    required Color lightColor,
    required Color labelColor,
  }) {
    return GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppinsTextTheme().displayLarge?.copyWith(
        color: primaryColor,
        inherit: true,
      ),
      displayMedium: GoogleFonts.poppinsTextTheme().displayMedium?.copyWith(
        color: primaryColor,
        inherit: true,
      ),
      headlineLarge: GoogleFonts.poppinsTextTheme().headlineLarge?.copyWith(
        color: primaryColor,
        inherit: true,
      ),
      headlineMedium: GoogleFonts.poppinsTextTheme().headlineMedium?.copyWith(
        color: primaryColor,
        inherit: true,
      ),
      titleLarge: GoogleFonts.poppinsTextTheme().titleLarge?.copyWith(
        color: primaryColor,
        inherit: true,
      ),
      titleMedium: GoogleFonts.poppinsTextTheme().titleMedium?.copyWith(
        color: primaryColor,
        inherit: true,
      ),
      bodyLarge: GoogleFonts.poppinsTextTheme().bodyLarge?.copyWith(
        color: primaryColor,
        inherit: true,
      ),
      bodyMedium: GoogleFonts.poppinsTextTheme().bodyMedium?.copyWith(
        color: secondaryColor,
        inherit: true,
      ),
      bodySmall: GoogleFonts.poppinsTextTheme().bodySmall?.copyWith(
        color: lightColor,
        inherit: true,
      ),
      labelLarge: GoogleFonts.poppinsTextTheme().labelLarge?.copyWith(
        color: labelColor,
        inherit: true,
      ),
    );
  }

  // ─── ThemeData Light ──────────────────────────────────────────────
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF6F8FC),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1B2A4A),
      secondary: Color(0xFF818CF8),
      tertiary: Color(0xFFFBBF24),
      surface: Colors.white,
      error: errorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1B2A4A),
      onError: Colors.white,
    ),
    textTheme: _buildTextTheme(
      primaryColor: textPrimary,
      secondaryColor: textSecondary,
      lightColor: textLight,
      labelColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFBBF24),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: _poppins(fontSize: 16, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1B2A4A),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        side: const BorderSide(color: Color(0xFF1B2A4A), width: 1.5),
        textStyle: _poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: divider, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: divider, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: midnightBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: errorRed, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      hintStyle: _poppins(fontSize: 14, color: textLight),
      errorStyle: _poppins(fontSize: 12, color: errorRed),
      labelStyle: _poppins(fontSize: 14, color: textSecondary),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        side: const BorderSide(color: divider, width: 1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: _poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      iconTheme: const IconThemeData(color: textPrimary),
    ),
  );

  // ─── ThemeData Dark ───────────────────────────────────────────────
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F1528),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFBBF24),
      secondary: Color(0xFF818CF8),
      tertiary: Color(0xFF34D399),
      surface: Color(0xFF182238),
      error: Color(0xFFEF4444),
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    textTheme: _buildTextTheme(
      primaryColor: Colors.white,
      secondaryColor: const Color(0xFFB0BEC5),
      lightColor: const Color(0xFF7B8BA8),
      labelColor: Colors.black,
    ),
    // ✅ WAJIB: Samakan ElevatedButtonTheme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFBBF24),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: _poppins(fontSize: 16, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),
    // ✅ WAJIB: Samakan OutlinedButtonTheme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        side: const BorderSide(color: Colors.white, width: 1.5),
        textStyle: _poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    // ✅ WAJIB: Samakan InputDecorationTheme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF182238),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: Color(0xFF1E2846), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: Color(0xFF1E2846), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: Color(0xFFFBBF24), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      hintStyle: _poppins(fontSize: 14, color: const Color(0xFF7B8BA8)),
      errorStyle: _poppins(fontSize: 12, color: const Color(0xFFEF4444)),
      labelStyle: _poppins(fontSize: 14, color: const Color(0xFFB0BEC5)),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF182238),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        side: const BorderSide(color: Color(0xFF1E2846), width: 1),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: _poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
  );
}
