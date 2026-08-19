import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ColorUtils.dart';

class Themes {
  static const Color _lightSurface = Colors.white;
  static const Color _darkSurface = Color(0xFF121212);
  static const Color _darkCard = Color(0xFF1E1E1E);

  // ------------------- LIGHT THEME -------------------
  static ThemeData get lightTheme => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    canvasColor: _lightSurface,
    cardColor: _lightSurface,

    // 👇 GLOBAL FONT FAMILY
    fontFamily: 'GramatikaTrial',

    textTheme: _lightTextTheme,
    primaryTextTheme: _lightTextTheme,

    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    shadowColor: shadowColor,
    appBarTheme: _lightAppBarTheme,
    listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.zero),
    dividerColor: dividerColor,
    dividerTheme: const DividerThemeData(color: Colors.grey),
    expansionTileTheme: const ExpansionTileThemeData(
      iconColor: primaryColor,
      textColor: primaryTextColor,
      collapsedTextColor: primaryTextColor,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
    ),
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
      surface: _lightSurface,
      error: errorColor,
      onError: errorColor,
      onSurface: Colors.black,
    ),
    iconTheme: const IconThemeData(color: primaryIconColor, size: 14),
    primaryIconTheme:
    const IconThemeData(color: primaryIconColor, size: 14),

    // ------------------- GLOBAL TEXTFIELD THEME -------------------
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],

      // 👇 FORCE GramatikaTrial in TextField
      hintStyle: const TextStyle(fontFamily: 'GramatikaTrial'),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),

    // ------------------- TEXT SELECTION -------------------
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor.withOpacity(0.2),
      selectionHandleColor: primaryColor,
    ),

    useMaterial3: true,

    iconButtonTheme: const IconButtonThemeData(
      style:
      ButtonStyle(iconColor: MaterialStatePropertyAll(primaryIconColor)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
      circularTrackColor: Color(0x1F0A6C7D),
      linearTrackColor: Color(0x1F0A6C7D),
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: primaryButtonColor,
      textTheme: ButtonTextTheme.normal,
      padding: EdgeInsets.zero,
      disabledColor: primaryButtonColor,
      focusColor: primaryButtonColor,
      layoutBehavior: ButtonBarLayoutBehavior.padded,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: _lightSurface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: _lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: _lightSurface,
      surfaceTintColor: Colors.transparent,
    ),

    brightness: Brightness.light,
  );

  // ------------------- DARK THEME -------------------
  static ThemeData get darkTheme => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: _darkSurface,
    canvasColor: _darkCard,
    cardColor: _darkCard,

    // 👇 GLOBAL FONT FAMILY
    fontFamily: 'GramatikaTrial',

    textTheme: _darkTextTheme,
    primaryTextTheme: _darkTextTheme,

    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    shadowColor: shadowColor,
    appBarTheme: _darkAppBarTheme,
    listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.zero),
    dividerColor: dividerColor,
    dividerTheme: const DividerThemeData(color: Colors.grey),
    expansionTileTheme: const ExpansionTileThemeData(
      iconColor: primaryColor,
      textColor: primaryTextColor,
      collapsedTextColor: primaryTextColor,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
    ),
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      background: _darkSurface,
      surface: _darkCard,
      error: errorColor,
      onError: errorColor,
      onSurface: Colors.white,
    ),
    iconTheme: const IconThemeData(color: primaryIconColor, size: 14),
    primaryIconTheme:
    const IconThemeData(color: primaryIconColor, size: 14),

    // ------------------- GLOBAL TEXTFIELD THEME -------------------
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[900],

      // 👇 FORCE GramatikaTrial
      hintStyle: const TextStyle(fontFamily: 'GramatikaTrial'),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),

    // ------------------- TEXT SELECTION -------------------
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor.withOpacity(0.2),
      selectionHandleColor: primaryColor,
    ),

    useMaterial3: true,

    iconButtonTheme: const IconButtonThemeData(
      style:
      ButtonStyle(iconColor: MaterialStatePropertyAll(primaryIconColor)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
      circularTrackColor: Color(0x290A6C7D),
      linearTrackColor: Color(0x290A6C7D),
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: primaryButtonColor,
      textTheme: ButtonTextTheme.normal,
      padding: EdgeInsets.zero,
      disabledColor: primaryButtonColor,
      focusColor: primaryButtonColor,
      layoutBehavior: ButtonBarLayoutBehavior.padded,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: _darkCard,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: _darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: _darkCard,
      surfaceTintColor: Colors.transparent,
    ),

    brightness: Brightness.dark,
  );

  // ------------------- SHARED TEXT THEME -------------------
  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge:
    TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Colors.black),
    displayMedium:
    TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: Colors.black),
    displaySmall:
    TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.black),
    headlineMedium:
    TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black),
    headlineSmall:
    TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
    titleLarge:
    TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
    titleMedium:
    TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
    titleSmall:
    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
    bodyLarge:
    TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
    bodyMedium:
    TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
    bodySmall:
    TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
    labelLarge:
    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
    labelSmall:
    TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black),
  );
  static const TextTheme _darkTextTheme = TextTheme(
    displayLarge:
    TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Colors.white),
    displayMedium:
    TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: Colors.white),
    displaySmall:
    TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
    headlineMedium:
    TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
    headlineSmall:
    TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
    titleLarge:
    TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
    titleMedium:
    TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    titleSmall:
    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    bodyLarge:
    TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
    bodyMedium:
    TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
    bodySmall:
    TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
    labelLarge:
    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    labelSmall:
    TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white),
  );

  // ------------------- APPBAR THEME -------------------
  static AppBarTheme get _lightAppBarTheme => const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: backgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    shadowColor: shadowColor,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'GramatikaTrial',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );
  static AppBarTheme get _darkAppBarTheme => const AppBarTheme(
    color: _darkSurface,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: _darkSurface,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: _darkSurface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
    shadowColor: shadowColor,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'GramatikaTrial',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    actionsIconTheme: IconThemeData(color: Colors.white),
  );
}
