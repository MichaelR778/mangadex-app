import 'package:flutter/material.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class AppTheme {
  static final appTheme = ThemeData(
    primaryColor: AppColors.primary,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
  );
}
