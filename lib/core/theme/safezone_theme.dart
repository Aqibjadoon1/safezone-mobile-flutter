import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'safezone_colors.dart';

class SafeZoneTheme {
  const SafeZoneTheme._();

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 58,
        fontWeight: FontWeight.w800,
        color: SafeZoneColors.white,
        height: .9,
      ),
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: SafeZoneColors.white,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: SafeZoneColors.white,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: .8,
        color: SafeZoneColors.muted,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: SafeZoneColors.voidBlack,
      colorScheme: const ColorScheme.dark(
        primary: SafeZoneColors.safe,
        secondary: SafeZoneColors.cyan,
        error: SafeZoneColors.danger,
        surface: SafeZoneColors.panel,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: SafeZoneColors.panel,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(.10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: SafeZoneColors.cyan),
        ),
      ),
    );
  }
}
