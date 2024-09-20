import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // Default theme
  int _customThemeIndex = 0; // 0: Light, 1: Dark, 2: Blue, 3: Pink

  ThemeMode get themeMode => _themeMode;
  int get customThemeIndex => _customThemeIndex;

  ThemeNotifier() {
    _loadThemeFromPreferences(); // Load theme from preferences on creation
  }

  void toggleTheme(int index) async {
    _customThemeIndex = index;

    if (index == 0) {
      _themeMode = ThemeMode.light;
    } else if (index == 1) {
      _themeMode = ThemeMode.dark;
    } else if (index == 2) {
      _themeMode = ThemeMode.system; // You can treat system as the blue theme
    } else if (index == 3) {
      // Pink theme logic will be handled in the UI using the index
      _themeMode = ThemeMode.light; // This is just a placeholder
    }

    notifyListeners();
    await _saveThemeToPreferences(); // Save selected theme
  }

  // Load the saved theme from SharedPreferences
  Future<void> _loadThemeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _customThemeIndex = prefs.getInt('themeMode') ?? 0;

    toggleTheme(_customThemeIndex); // Apply saved theme
  }

  // Save the current theme in SharedPreferences
  Future<void> _saveThemeToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', _customThemeIndex); // Save the theme index
  }
}
