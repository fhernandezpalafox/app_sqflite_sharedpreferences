import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _preferences;

  static Future<SharedPreferences> get instance async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  static Future<bool> setDarkMode(bool value) async {
    final prefs = await instance;
    return await prefs.setBool('darkMode', value);
  }

  static Future<bool> getDarkMode() async {
    final prefs = await instance;
    return prefs.getBool('darkMode') ?? false;
  }
}
