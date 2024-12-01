import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  String themeMode = "System";
  void ChangeTheme(String mode) {
    themeMode = mode;
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    if (themeMode == "Dark") {
      return ThemeMode.dark;
    }
    if (themeMode == "Light") {
      return ThemeMode.light;
    }
    return ThemeMode.system;
  }
}