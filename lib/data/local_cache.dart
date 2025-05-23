import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/language/cubit/language_cubit.dart';
import '../core/language/inherited_language_widget.dart';
import '../core/theme/cubit/theme_cubit.dart';
import '../core/theme/inherited_theme_widget.dart';

class LocalCache {
  LocalCache._();

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static Future<bool> getBool(String key) async {
    return _prefs?.getBool(key) ?? false;
  }

  static Future<String> getString(String key) async {
    return _prefs?.getString(key) ?? '';
  }
}

class StringCache {
  StringCache._();

  static String theme = 'cached_theme';
  static String language = 'cached_language';
  static String email = 'cached_email';
  static String password = 'cached_password';
  static String rememberMe = 'cache_remember_me';
  static String accessToken = 'cached_access_token';
  static String refreshToken = 'cached_refresh_token';
}
