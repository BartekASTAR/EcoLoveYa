import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider extends ChangeNotifier {
  String selectedDate;
  bool isDarkTheme;
  bool shouldRefresh;

  DataProvider({
    this.selectedDate = "",
    this.isDarkTheme = false,
    this.shouldRefresh = false,
  }) {
    _loadTheme();
  }

  void setShouldRefresh(bool newValue) async {
    shouldRefresh = newValue;
    notifyListeners();
  }

  void changeSelectedDate({required String newSelectedDate}) async {
    selectedDate = newSelectedDate;
    notifyListeners();
  }

  void toggleTheme() async {
    isDarkTheme = !isDarkTheme;
    await _saveTheme(isDarkTheme); // Zapisz motyw w SharedPreferences
    notifyListeners();
  }

  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', isDark);
  }

  // Odczytaj stan motywu z SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkTheme = prefs.getBool('isDarkTheme') ?? false; // domyślnie false
    notifyListeners(); // Zaktualizuj widgety, gdy motyw jest załadowany
  }
}
