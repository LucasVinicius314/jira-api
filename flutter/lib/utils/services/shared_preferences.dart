import 'package:shared_preferences/shared_preferences.dart' as prefs;

enum Keys { authorization }

class SharedPreferences {
  static Future<prefs.SharedPreferences> get instance =>
      prefs.SharedPreferences.getInstance();

  static Future<String?> get authorization async {
    final key = Keys.authorization.toString();

    final prefs = await instance;

    return prefs.getString(key);
  }

  static Future<void> setAuthorization(String? value) async {
    final key = Keys.authorization.toString();

    final prefs = await instance;

    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value);
    }
  }
}
