import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? preferences;

  static const _keyUsername = 'username';
  static const _keyUserEmail = 'userEmail';

  static Future<SharedPreferences> init() async =>
      preferences = await SharedPreferences.getInstance();

  static Future<bool?> setUsername(String username) async =>
      await preferences?.setString(_keyUsername, username);

  static String? getUsername() => preferences?.getString(_keyUsername);

  static Future<bool?> setUserEmail(String userEmail) async =>
      await preferences?.setString(_keyUserEmail, userEmail);

  static String? getUserEmail() => preferences?.getString(_keyUserEmail);
}
