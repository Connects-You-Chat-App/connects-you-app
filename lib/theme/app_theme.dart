import 'package:flutter/material.dart';

class AppTheme {
  static const gradientColors = [
    Color.fromRGBO(0, 100, 255, 2),
    Color.fromRGBO(0, 125, 255, 1),
    Color.fromRGBO(0, 150, 255, 1),
    Color.fromRGBO(0, 100, 255, 1)
  ];

  static const lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      color: Colors.black,
      fontSize: 96.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    displayMedium: TextStyle(
      color: Colors.black,
      fontSize: 60.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    displaySmall: TextStyle(
      color: Colors.black,
      fontSize: 48.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    headlineMedium: TextStyle(
      color: Colors.black,
      fontSize: 34.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    headlineSmall: TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    titleMedium: TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    bodyMedium: TextStyle(
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    labelLarge: TextStyle(
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    bodySmall: TextStyle(
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    labelSmall: TextStyle(
      color: Colors.black,
      fontSize: 10.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    headlineLarge: TextStyle(
      color: Colors.black,
      fontSize: 48.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    labelMedium: TextStyle(
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
  );

  static const darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 96.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 60.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    displaySmall: TextStyle(
      color: Colors.white,
      fontSize: 48.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    headlineMedium: TextStyle(
      color: Colors.white,
      fontSize: 34.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    headlineSmall: TextStyle(
      color: Colors.white,
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    labelSmall: TextStyle(
      color: Colors.white,
      fontSize: 10.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    headlineLarge: TextStyle(
      color: Colors.white,
      fontSize: 48.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
    labelMedium: TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'QuickSand',
    ),
  );

  static final appThemeLight = ThemeData(
    fontFamily: 'QuickSand',
    primaryColor: Colors.blue,
    textTheme: lightTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.blue,
        size: 24.0,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.blue,
        size: 24.0,
      ),
      titleTextStyle: TextStyle(
        color: Colors.blue,
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'QuickSand',
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.blue,
      disabledColor: Colors.blue.shade700,
      selectedColor: Colors.blue,
      secondarySelectedColor: Colors.blue,
      padding: const EdgeInsets.all(8.0),
      shape: const StadiumBorder(),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'QuickSand',
      ),
      secondaryLabelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'QuickSand',
      ),
      brightness: Brightness.light,
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 18.0,
      ),
      checkmarkColor: Colors.white,
      deleteIconColor: Colors.white,
    ),
    shadowColor: Colors.blue,
    dividerTheme: const DividerThemeData(
      color: Colors.blue,
      thickness: 1.0,
      space: 10,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 0.0,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.blue.shade700,
      selectedIconTheme: const IconThemeData(
        color: Colors.blue,
        size: 24.0,
      ),
      unselectedIconTheme: IconThemeData(
        color: Colors.blue.shade700,
        size: 24.0,
      ),
      selectedLabelStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'QuickSand',
      ),
      unselectedLabelStyle: TextStyle(
        color: Colors.blue.shade700,
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'QuickSand',
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      elevation: 0.0,
      dragHandleColor: Colors.blue,
      showDragHandle: true,
      dragHandleSize: Size(50, 7.5),
      shadowColor: Colors.blue,
      modalElevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        disabledForegroundColor: Colors.white.withOpacity(0.38),
        disabledBackgroundColor: Colors.white.withOpacity(0.12),
        elevation: 0.0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.blue,
      size: 24.0,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Colors.white,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.blue,
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'QuickSand',
      ),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      backgroundColor: Colors.white,
      accentColor: Colors.blue,
      errorColor: const Color(0xFFFD2671),
      brightness: Brightness.light,
    ).copyWith(
      secondary: Colors.blueAccent,
      shadow: Colors.blueAccent,
    ),
  );

  static final appThemeDark = ThemeData(
    fontFamily: 'QuickSand',
    textTheme: darkTextTheme,
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0.0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.blue,
        size: 24.0,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.blue,
        size: 24.0,
      ),
      titleTextStyle: TextStyle(
        color: Colors.blue,
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'QuickSand',
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.blue,
      disabledColor: Colors.blue.shade700,
      selectedColor: Colors.blue,
      secondarySelectedColor: Colors.blue,
      padding: const EdgeInsets.all(8.0),
      shape: const StadiumBorder(),
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'QuickSand',
      ),
      secondaryLabelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'QuickSand',
      ),
      brightness: Brightness.dark,
      iconTheme: const IconThemeData(
        color: Colors.black,
        size: 18.0,
      ),
      checkmarkColor: Colors.black,
      deleteIconColor: Colors.black,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.black,
      elevation: 10,
      dragHandleColor: Colors.blue,
      showDragHandle: true,
      shadowColor: Colors.blue,
      modalElevation: 10,
      dragHandleSize: Size(50, 7.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
    ),
    shadowColor: Colors.blue,
    dividerTheme: const DividerThemeData(
      color: Colors.blue,
      thickness: 1.0,
      space: 10,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      elevation: 0.0,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.blue.shade700,
      selectedIconTheme: const IconThemeData(
        color: Colors.blue,
        size: 24.0,
      ),
      unselectedIconTheme: IconThemeData(
        color: Colors.blue.shade700,
        size: 24.0,
      ),
      selectedLabelStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'QuickSand',
      ),
      unselectedLabelStyle: TextStyle(
        color: Colors.blue.shade700,
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'QuickSand',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.blue,
        disabledForegroundColor: Colors.white.withOpacity(0.38),
        disabledBackgroundColor: Colors.white.withOpacity(0.12),
        elevation: 0.0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
    cardTheme: const CardTheme(
      color: Colors.black,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.black,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.blue,
      size: 24.0,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Colors.black,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.blue,
      contentTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'QuickSand',
      ),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8.0),
        ),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
    ),
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      backgroundColor: Colors.black,
      accentColor: Colors.blue,
      errorColor: const Color(0xFFFD2671),
      brightness: Brightness.dark,
    ).copyWith(
      secondary: Colors.blueAccent,
      shadow: Colors.blueAccent,
    ),
  );
}