import 'package:flutter/material.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class AppTheme {
  static final appTheme = ThemeData(
    // colorScheme: ColorScheme.fromSwatch().copyWith(
    //   primary: AppColors.primary,
    //   onSurface: Colors.white,
    //   brightness: Brightness.dark,
    // ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
    ),
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.primary,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      hintStyle: const TextStyle(
        color: Color(0x33FFFFFF),
      ),
      filled: true,
      fillColor: const Color(0xff2B2B2B),
    ),
  );
}
