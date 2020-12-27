import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<void> saveString(String key, String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  static Future<void> saveMap(String key, Map<String, dynamic> map) async {
    saveString(key, json.encode(map));
  }

  static Future<String> getString(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key);
  }

  static Future<Map<String, dynamic>> getMap(String key) async {
    try {
      Map<String, dynamic> map = json.decode(await getString(key));
      return map;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> remove(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(key);
  }
}
