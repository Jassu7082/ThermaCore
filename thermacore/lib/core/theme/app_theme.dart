import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.critical,
    ),
    fontFamily: 'SpaceMono',
    dividerColor: AppColors.border,
    cardColor: AppColors.surface,
    useMaterial3: true,
    cardTheme: CardTheme(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      elevation: 0,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.primary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.muted,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? AppColors.primary : AppColors.muted),
      trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
              ? AppColors.primary.withOpacity(0.3)
              : AppColors.border),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.primary,
      thumbColor: AppColors.primary,
      overlayColor: Color(0x2200E5FF),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Orbitron',
        fontWeight: FontWeight.w800,
        color: AppColors.primary,
        letterSpacing: 2,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Orbitron',
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Orbitron',
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 1,
      ),
      bodyMedium: TextStyle(color: Colors.white70),
      bodySmall: TextStyle(color: AppColors.muted, fontSize: 11),
      labelSmall: TextStyle(
        fontFamily: 'SpaceMono',
        letterSpacing: 2,
        color: AppColors.muted,
        fontSize: 10,
      ),
    ),
  );

  // True black AMOLED variant
  static ThemeData get amoled => dark.copyWith(
    scaffoldBackgroundColor: Colors.black,
    cardColor: const Color(0xFF0A0A0A),
  );
}
