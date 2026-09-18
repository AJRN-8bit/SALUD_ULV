import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/color_palettes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/icon_sizes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/shadows.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/spacers.dart';

TextTheme textTheme = GoogleFonts.aBeeZeeTextTheme();

class AppTheme {
  AppTheme._();

  static ThemeData light = ThemeData(
    useMaterial3: true,
    textTheme: textTheme,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.light.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.light.primary,
      onPrimary: AppColors.light.secondary,
      secondary: AppColors.light.secondary,
      onSecondary: AppColors.light.onSecondary,
      tertiary: AppColors.light.tertiary,
      onTertiary: AppColors.light.onTertiary,
      surface: AppColors.light.surface,
      error: AppColors.light.danger,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      focusColor: AppColors.light.primary,
      fillColor: AppColors.light.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      )),








    extensions: const [
      AppColors.light,
      AppSpacing.standard,
      AppFonts.standard,
      AppIconSizes.standard,
      AppShadows.standard,
    ],
  );





  static ThemeData dark = ThemeData(
    useMaterial3: true,
    textTheme: textTheme,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
    colorScheme: ColorScheme.dark(
      surface: AppColors.dark.surface,
      primary: AppColors.dark.primary,
      onPrimary: AppColors.dark.secondary,
      secondary: AppColors.dark.secondary,
      onSecondary: AppColors.dark.onSecondary,
      tertiary: AppColors.dark.tertiary,
      onTertiary: AppColors.dark.onTertiary,
      error: AppColors.dark.danger,
    ),

    

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      focusColor: AppColors.dark.primary,
      fillColor: AppColors.dark.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      )),

      primaryTextTheme: TextTheme(
        
      ),






    extensions: const [
      AppColors.dark,
      AppSpacing.standard,
      AppFonts.standard,
      AppIconSizes.standard,
      // AppShadows.standard,
    ],
  );
}

/// ---------------------------------------------------------------------
/// 4. CONVENIENCE ACCESSORS
/// ---------------------------------------------------------------------
extension ThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  AppSpacing get spacing => Theme.of(this).extension<AppSpacing>()!;
  AppFonts get fonts => Theme.of(this).extension<AppFonts>()!;
  AppIconSizes get iconSize => Theme.of(this).extension<AppIconSizes>()!;
}









// class ThemeController extends ChangeNotifier {
//   ThemeController() {
//     _loadFromPrefs();
//   }

//   ThemeMode _mode = ThemeMode.system;
//   ThemeMode get mode => _mode;

//   static const _prefsKey = 'theme_mode';

//   Future<void> _loadFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     final saved = prefs.getString(_prefsKey);
//     if (saved == 'light') _mode = ThemeMode.light;
//     if (saved == 'dark') _mode = ThemeMode.dark;
//     notifyListeners();
//   }

//   Future<void> setMode(ThemeMode mode) async {
//     _mode = mode;
//     notifyListeners();
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_prefsKey, mode.name);
//   }

//   Future<void> toggle() async {
//     final isDark = _mode == ThemeMode.dark;
//     await setMode(isDark ? ThemeMode.light : ThemeMode.dark);
//   }
// }