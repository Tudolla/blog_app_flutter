import 'package:blog/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
      );
  static final lightThemeMode = ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppPallete.backgroundColor,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.all(25),
        enabledBorder: _border(AppPallete.borderColor),
        focusedBorder: _border(AppPallete.gradient1),
        errorBorder: _border(AppPallete.errorColor),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPallete.backgroundColor,
      ),
      chipTheme: const ChipThemeData(
        color: WidgetStatePropertyAll(
          Color.fromARGB(255, 222, 228, 227),
        ),
        side: BorderSide.none,
      ));
}
