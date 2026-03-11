import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Token ──────────────────────────────────────────────
  static Future<void> saveToken(String token) async {
    await _prefs?.setString(AppConstants.tokenKey, token);
  }

  static String? getToken() => _prefs?.getString(AppConstants.tokenKey);

  // ── User ───────────────────────────────────────────────
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs?.setString(AppConstants.userKey, jsonEncode(user));
  }

  static Map<String, dynamic>? getUser() {
    final raw = _prefs?.getString(AppConstants.userKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static bool get isLoggedIn => getToken() != null;

  // ── Theme ──────────────────────────────────────────────
  static Future<void> saveThemeMode(bool isDark) async {
    await _prefs?.setBool(AppConstants.themeModeKey, isDark);
  }

  static bool getThemeMode() => _prefs?.getBool(AppConstants.themeModeKey) ?? false;

  // ── Clear ──────────────────────────────────────────────
  static Future<void> clearAll() async {
    await _prefs?.remove(AppConstants.tokenKey);
    await _prefs?.remove(AppConstants.userKey);
  }
}
