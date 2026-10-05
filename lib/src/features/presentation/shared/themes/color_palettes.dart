import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.low,
    required this.danger,
    required this.border,
  });

  final Color background;
  final Color surface;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color tertiary;
  final Color onTertiary;
  final Color textPrimary;
  final Color textSecondary;
  final Color success;
  final Color warning;
  final Color low;
  final Color danger;
  final Color border;


  // main light palette: light blue, cyan, light yellow

  // static const light = AppColors(
  //   background: Color.fromARGB(255, 214, 232, 232),
  //   surface: Color.fromARGB(255, 120, 214, 99),
  //   primary:  Color.fromARGB(255, 4, 111, 154),
  //   secondary: Color.fromARGB(255, 82, 185, 244),
  //   textPrimary: Color(0xFF111111),
  //   textSecondary: Color(0xFF6B7280),
  //   success: Color.fromARGB(255, 15, 201, 242),
  //   warning: Color.fromARGB(255, 233, 154, 7),
  //   danger: Color.fromARGB(255, 245, 33, 33),
  //   border: Color(0xFFE5E7EB),
  // );

  static const light = AppColors(
    background: Color(0xFFFAFAFA),
    surface: Color.fromARGB(255, 255, 255, 255),
    primary:  Color(0xFFE4EC81),
    onPrimary:  Color(0xFF9BC43C),
    secondary: Color(0xFF56992F),
    onSecondary: Color(0xFF1B693C),
    tertiary: Color(0xFF115566),
    onTertiary: Color.fromARGB(255, 228, 190, 38),
    textPrimary: Color(0xFF111111),
    textSecondary: Color(0xFFFAFCFD),
    success: Color.fromARGB(255, 21, 145, 33),
    warning: Color.fromARGB(255, 209, 145, 25),
    low: Colors.blue,
    danger: Color.fromARGB(255, 200, 25, 25),
    border: Color(0xFFE5E7EB),
  );

  static const dark = AppColors(
    background: Color(0xFF151912),
    surface: Color(0xFF212121),
    primary: Color.fromARGB(255, 5, 98, 50),
    onPrimary: Color.fromARGB(255, 0, 165, 20),
    secondary: Color.fromARGB(255, 22, 171, 156),
    onSecondary: Color.fromARGB(255, 9, 98, 78),
    tertiary: Color.fromARGB(255, 13, 72, 131),
    onTertiary: Color.fromARGB(255, 11, 18, 91),
    textPrimary: Color(0xFFE7E0D0),
    textSecondary: Color.fromARGB(255, 197, 197, 197),
    success: Color.fromARGB(255, 88, 157, 24),
    warning: Color.fromARGB(255, 178, 117, 52),
    low: Color.fromARGB(255, 52, 144, 178),
    danger: Color.fromARGB(255, 157, 62, 43),
    border: Color.fromARGB(255, 199, 199, 199),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? onSurface,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? tertiary,
    Color? onTertiary,
    Color? textPrimary,
    Color? textSecondary,
    Color? success,
    Color? warning,
    Color? low,
    Color? danger,
    Color? border,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      onPrimary: primary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: secondary ?? this.onSecondary,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      low: low ?? this.low,
      danger: danger ?? this.danger,
      border: border ?? this.border,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      low: Color.lerp(low, other.low, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}