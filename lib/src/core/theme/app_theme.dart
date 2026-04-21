import 'package:flutter/material.dart';

import 'package:aura_pet/src/core/theme/design_tokens.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4B5AA3)),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    scaffoldBackgroundColor: const Color(0xFFF8FAFF),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.86),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.space12,
        vertical: DesignTokens.space12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
        borderSide: const BorderSide(color: Color(0xFFD5DBEE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius12),
        borderSide: const BorderSide(color: Color(0xFF4B5AA3), width: 1.5),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: DesignTokens.elevation0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius16),
      ),
      margin: const EdgeInsets.all(0),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, DesignTokens.buttonHeightRegular),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, DesignTokens.buttonHeightRegular),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radius12),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: DesignTokens.elevation0,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final base = const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
        if (states.contains(WidgetState.selected)) {
          return base;
        }
        return base.copyWith(fontWeight: FontWeight.w500);
      }),
    ),
  );
}
