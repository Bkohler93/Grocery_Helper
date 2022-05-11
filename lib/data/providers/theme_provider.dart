import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void setLight() {
    if (themeMode != ThemeMode.light) {
      themeMode = ThemeMode.light;
      notifyListeners();
    }
  }

  void setDark() {
    if (themeMode != ThemeMode.dark) {
      themeMode = ThemeMode.dark;
      notifyListeners();
    }
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 48, 48, 48),
    colorScheme: ColorScheme.dark(
      primary: Colors.green.shade400,
      secondary: Colors.green,
      secondaryContainer: Colors.green.shade200,
      tertiaryContainer: Colors.green.shade100,
    ),
  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade50,
    colorScheme: ColorScheme.light(
      primary: Colors.green,
      secondary: Colors.green,
      secondaryContainer: Colors.green.shade200,
      tertiaryContainer: Colors.green.shade100,
    ),
  );
}
