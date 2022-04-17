import 'package:shared_preferences/shared_preferences.dart' as prefs;

enum Keys {
  authorization,
  members,
  title,
}

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

  static Future<String?> get members async {
    final key = Keys.members.toString();

    final prefs = await instance;

    return prefs.getString(key);
  }

  static Future<void> setMembers(String? value) async {
    final key = Keys.members.toString();

    final prefs = await instance;

    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value);
    }
  }

  static Future<String?> get title async {
    final key = Keys.title.toString();

    final prefs = await instance;

    return prefs.getString(key);
  }

  static Future<void> setTitle(String? value) async {
    final key = Keys.title.toString();

    final prefs = await instance;

    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value);
    }
  }
}
