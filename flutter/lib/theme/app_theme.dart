import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors_ext.dart';

class AppTheme {
  AppTheme._();

  static TextStyle mono({double size = 13, FontWeight weight = FontWeight.w500, Color color = const Color(0xFF6B7078)}) {
    return GoogleFonts.ibmPlexMono(fontSize: size, fontWeight: weight, color: color);
  }

  static ThemeData _build({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = isDark
        ? const ColorScheme.dark(
      primary: Color(0xFF3DDC97),
      onPrimary: Color(0xFF06110C),
      surface: Color(0xFF181B20),
      onSurface: Color(0xFFE8E6DF),
      onSurfaceVariant: Color(0xFFA6ABB1),
      outline: Color(0xFF4A5057),
      outlineVariant: Color(0xFF33383F),
      secondary: Color(0xFFE8A33D),
    )
        : const ColorScheme.light(
      primary: Color(0xFF0F9D6C),
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF14171B),
      onSurfaceVariant: Color(0xFF5B5F63),
      outline: Color(0xFFC7C5BB),
      outlineVariant: Color(0xFFDEDCD3),
      secondary: Color(0xFFB4780F),
    );

    final scaffoldBg = isDark ? const Color(0xFF0B0D10) : const Color(0xFFF7F7F5);

    final baseTextTheme = GoogleFonts.interTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );

    final textTheme = baseTextTheme.copyWith(
      displaySmall: GoogleFonts.spaceGrotesk(fontSize: 26, fontWeight: FontWeight.w500, color: colorScheme.onSurface),
      headlineSmall: GoogleFonts.spaceGrotesk(fontSize: 19, fontWeight: FontWeight.w500, color: colorScheme.onSurface),
      titleMedium: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: colorScheme.onSurface),
      bodySmall: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: colorScheme.onSurfaceVariant),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      textTheme: textTheme,
      extensions: [isDark ? AppColorsExt.dark : AppColorsExt.light],
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w500, color: colorScheme.onSurface),
        iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outlineVariant, thickness: 1, space: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.1),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outline),
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: UnderlineInputBorder(borderSide: BorderSide(color: colorScheme.outlineVariant)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorScheme.outlineVariant)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorScheme.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
    );
  }

  static ThemeData get light => _build(brightness: Brightness.light);
  static ThemeData get dark => _build(brightness: Brightness.dark);
}