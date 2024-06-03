
import 'package:blog/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme{
  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
  );
}