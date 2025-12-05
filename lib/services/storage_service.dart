import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await _prefs?.setString(StorageKeys.token, token);
  }

  static String? getToken() {
    return _prefs?.getString(StorageKeys.token);
  }

  static Future<void> removeToken() async {
    await _prefs?.remove(StorageKeys.token);
  }

  static Future<void> saveUser(String userJson) async {
    await _prefs?.setString(StorageKeys.user, userJson);
  }

  static String? getUser() {
    return _prefs?.getString(StorageKeys.user);
  }

  static Future<void> removeUser() async {
    await _prefs?.remove(StorageKeys.user);
  }

  static Future<void> saveLocale(String code) async {
    await _prefs?.setString(StorageKeys.locale, code);
  }

  static String? getLocale() {
    return _prefs?.getString(StorageKeys.locale);
  }

  static Future<void> saveTheme(String theme) async {
    await _prefs?.setString(StorageKeys.theme, theme);
  }

  static String? getTheme() {
    return _prefs?.getString(StorageKeys.theme);
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
