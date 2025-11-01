import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appThemeProvider = Provider<AppTheme>((ref) {
  return AppTheme();
});

class AppTheme {
  AppTheme()
      : light = _buildLightTheme(_lightScheme),
        dark = _buildDarkTheme(_darkScheme);

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF2F5AF3),
    brightness: Brightness.light,
    background: const Color(0xFFF6F8FC),
    surface: const Color(0xFFFBFCFF),
  );

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF7AA4FF),
    brightness: Brightness.dark,
  );

  final ThemeData light;
  final ThemeData dark;

  Color get gradientStart => const Color(0xFFF3F6FF);
  Color get gradientEnd => const Color(0xFFE5ECFF);
  Color get navigationBackground => const Color(0xFFF8FAFE);
  Color get surfaceLayer => const Color(0xFFFCFDFF);
  Color get surfaceBorder => const Color(0xFFE3E8F5);
  Color get subtleText => const Color(0xFF6B7280);

  static ThemeData _buildLightTheme(ColorScheme scheme) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      textTheme: Typography.englishLike2021.apply(
        fontFamily: 'Roboto',
        bodyColor: const Color(0xFF1E293B),
        displayColor: const Color(0xFF0F172A),
      ),
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFFE3E7F1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFFE3E7F1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: base.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: base.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: base.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        selectedIconTheme: IconThemeData(color: scheme.primary, size: 26),
        unselectedIconTheme: IconThemeData(color: const Color(0xFF9CA3AF), size: 24),
        selectedLabelTextStyle: base.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: scheme.primary,
        ),
        unselectedLabelTextStyle: base.textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF94A3B8),
        ),
        indicatorColor: scheme.primary.withOpacity(0.14),
        groupAlignment: -1,
        labelType: NavigationRailLabelType.all,
      ),
      dividerTheme: const DividerThemeData(space: 1, thickness: 1),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFFEFF4FF),
        labelStyle: base.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  static ThemeData _buildDarkTheme(ColorScheme scheme) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
    );

    return base.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
