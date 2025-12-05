import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/app_theme.dart';
import '../utils/app_theme.dart' as theme_utils;

class SettingsProvider with ChangeNotifier {
  static const supportedLocales = [Locale('en'), Locale('hi'), Locale('mr')];

  Locale? _locale;
  AppThemeMode _themeMode = AppThemeMode.light;

  Locale? get locale => _locale;
  AppThemeMode get themeMode => _themeMode;
  ThemeData get theme => theme_utils.AppTheme.getTheme(_themeMode);

  Future<void> init() async {
    final code = StorageService.getLocale();
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
    }

    final themeString = StorageService.getTheme();
    if (themeString != null && themeString.isNotEmpty) {
      _themeMode = AppThemeModeExtension.fromString(themeString);
    }

    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await StorageService.saveLocale(locale.languageCode);
    notifyListeners();
  }

  Future<void> setTheme(AppThemeMode themeMode) async {
    _themeMode = themeMode;
    await StorageService.saveTheme(themeMode.name);
    notifyListeners();
  }
}
