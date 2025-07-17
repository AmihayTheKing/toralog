import 'package:flutter/material.dart';

final ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 65, 37),
).copyWith(error: Colors.red);

final ThemeData lightTheme = ThemeData().copyWith(
  colorScheme: kColorScheme,
  iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle().copyWith(
    iconColor: WidgetStateProperty.all(kColorScheme.primary),
  )),
  appBarTheme: AppBarTheme().copyWith(
    backgroundColor: kColorScheme.primary,
    foregroundColor: kColorScheme.onPrimary,
    actionsIconTheme: IconThemeData().copyWith(color: kColorScheme.onPrimary),
    iconTheme: IconThemeData().copyWith(color: kColorScheme.onPrimary),
    titleTextStyle: TextStyle().copyWith(
      color: kColorScheme.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
    backgroundColor: kColorScheme.primary,
    foregroundColor: kColorScheme.onPrimary,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(kColorScheme.primary),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(kColorScheme.primary),
      foregroundColor: WidgetStateProperty.all(kColorScheme.onPrimary),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(),
  cardTheme: CardThemeData().copyWith(
    color: kColorScheme.surfaceContainer,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData().copyWith(
    backgroundColor: kColorScheme.primary,
    selectedItemColor: kColorScheme.onPrimary,
    unselectedItemColor: kColorScheme.onPrimary.withOpacity(0.5),
  ),
  scaffoldBackgroundColor: kColorScheme.surface,
  snackBarTheme: SnackBarThemeData().copyWith(
      backgroundColor: kColorScheme.surface,
      contentTextStyle: TextStyle().copyWith(
        color: kColorScheme.onSurface,
      ),
      actionTextColor: kColorScheme.primary),
  textTheme: Typography.material2021().black.apply(
        bodyColor: kColorScheme.primary,
        displayColor: kColorScheme.primary,
      ),
);
