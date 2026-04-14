import 'package:flutter/material.dart';

import 'package:aura_pet/src/core/theme/design_tokens.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4B5AA3)),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    scaffoldBackgroundColor: const Color(0xFFF8FAFF),
    cardTheme: CardThemeData(
      elevation: DesignTokens.elevation0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radius16),
      ),
      margin: const EdgeInsets.all(0),
    ),
    navigationBarTheme: NavigationBarThemeData(
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
