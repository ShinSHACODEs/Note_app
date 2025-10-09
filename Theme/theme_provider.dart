import 'package:flutter/material.dart';
import 'package:note_app/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode; // default theme
  ThemeData get themeData => _themeData; // getter
  bool get isDarkMode => _themeData == darkMode; // check mode
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = (_themeData == lightMode) ? darkMode : lightMode;
    notifyListeners();
  }
}
