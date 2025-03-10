import 'package:flutter/material.dart';

final ColorScheme kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 181, 140, 105),
  brightness: Brightness.dark,
).copyWith(error: Colors.red);

final ThemeData darkTheme = ThemeData().copyWith(
  colorScheme: kDarkColorScheme,
  iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle().copyWith(
    iconColor: WidgetStateProperty.all(kDarkColorScheme.primary),
  )),
  appBarTheme: AppBarTheme().copyWith(
    backgroundColor: kDarkColorScheme.primary,
    foregroundColor: kDarkColorScheme.onPrimary,
    actionsIconTheme:
        IconThemeData().copyWith(color: kDarkColorScheme.onPrimary),
    iconTheme: IconThemeData().copyWith(color: kDarkColorScheme.onPrimary),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
    backgroundColor: kDarkColorScheme.primary,
    foregroundColor: kDarkColorScheme.onPrimary,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(kDarkColorScheme.primary),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(kDarkColorScheme.primary),
      foregroundColor: WidgetStateProperty.all(kDarkColorScheme.onPrimary),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme().copyWith(),
  dropdownMenuTheme: DropdownMenuThemeData().copyWith(
    inputDecorationTheme: InputDecorationTheme().copyWith(
      fillColor: kDarkColorScheme.surface,
    ),
    menuStyle: MenuStyle().copyWith(
      surfaceTintColor: WidgetStateProperty.all(kDarkColorScheme.surface),
      backgroundColor: WidgetStateProperty.all(kDarkColorScheme.surface),
    ),
  ),
  cardTheme: CardTheme().copyWith(
    color: kDarkColorScheme.surfaceContainer,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData().copyWith(
    backgroundColor: kDarkColorScheme.primary,
    selectedItemColor: kDarkColorScheme.onPrimary,
    // ignore: deprecated_member_use
    unselectedItemColor: kDarkColorScheme.onPrimary.withOpacity(0.5),
  ),
  scaffoldBackgroundColor: kDarkColorScheme.surface,
  textTheme: TextTheme().copyWith(),
  snackBarTheme: SnackBarThemeData().copyWith(
      backgroundColor: kDarkColorScheme.surface,
      contentTextStyle: TextStyle().copyWith(
        color: kDarkColorScheme.onSurface,
      ),
      actionTextColor: kDarkColorScheme.primary),
);
