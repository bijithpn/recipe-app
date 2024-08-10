import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../core.dart';

class ThemeManager extends ChangeNotifier {
  static const String _themeKey = 'isDarkTheme';

  Box box = Hive.box(StorageStrings.settingDB);

  bool get isDarkTheme => box.get(_themeKey, defaultValue: false);

  void toggleTheme(bool isDark) {
    box.put(_themeKey, isDark);
    notifyListeners();
  }

  ThemeData get currentTheme {
    return isDarkTheme ? darkTheme : lightTheme;
  }

  ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorPalette.primary,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorPalette.scaffoldBg,
    appBarTheme: AppBarTheme(
        backgroundColor: ColorPalette.scaffoldBg,
        foregroundColor: ColorPalette.scaffoldBg,
        surfaceTintColor: ColorPalette.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0),
    textTheme: GoogleFonts.poppinsTextTheme(),
  );

  ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorPalette.primary,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    brightness: Brightness.dark,
    iconTheme: const IconThemeData(color: Colors.white),
    scaffoldBackgroundColor: ColorPalette.black,
    appBarTheme: AppBarTheme(
        backgroundColor: ColorPalette.black,
        foregroundColor: ColorPalette.black,
        surfaceTintColor: ColorPalette.black,
        elevation: 0,
        scrolledUnderElevation: 0),
    textTheme: GoogleFonts.poppinsTextTheme()
        .apply(bodyColor: Colors.white, displayColor: Colors.white),
  );
}
