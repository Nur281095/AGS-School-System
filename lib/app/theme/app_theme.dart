import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appThemeProvider = Provider<AppThemeData>((ref) {
  return AppThemeData(
    light: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1F6FEB),
        brightness: Brightness.light,
      ),
      textTheme: Typography.englishLike2021.apply(fontFamily: 'Roboto'),
    ),
    dark: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1F6FEB),
        brightness: Brightness.dark,
      ),
      textTheme: Typography.englishLike2021.apply(fontFamily: 'Roboto'),
    ),
    primaryColor: const Color(0xFF1F6FEB),
    navBackground: const Color(0xFFF7F9FD),
    scaffoldBackground: const Color(0xFFFDFDFE),
    surfaceContainer: const Color(0xFFF1F3F9),
  );
});

class AppThemeData {
  const AppThemeData({
    required this.light,
    required this.dark,
    required this.primaryColor,
    required this.navBackground,
    required this.scaffoldBackground,
    required this.surfaceContainer,
  });

  final ThemeData light;
  final ThemeData dark;
  final Color primaryColor;
  final Color navBackground;
  final Color scaffoldBackground;
  final Color surfaceContainer;
}
