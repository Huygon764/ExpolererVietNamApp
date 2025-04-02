import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _useSystemTheme = false;

  bool get isDarkMode =>
      _useSystemTheme
          ? WidgetsBinding.instance.window.platformBrightness == Brightness.dark
          : _isDarkMode;

  bool get useSystemTheme => _useSystemTheme;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemeToPrefs();
    notifyListeners();
  }

  void setUseSystemTheme(bool value) {
    _useSystemTheme = value;
    _saveThemeToPrefs();
    notifyListeners();
  }

  // Tải trạng thái theme từ bộ nhớ
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  // Lưu trạng thái theme vào bộ nhớ
  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }
}
