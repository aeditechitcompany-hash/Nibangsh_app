import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userPhoneKey = 'user_phone';
  static const String _userRoleKey = 'user_role';

  static const String _userPasswordKey = 'user_password';
  static const String _isLoggedInKey = 'is_logged_in';

  static Future<void> saveUserInfo({
    required String email,
    required String name,
    String phone = '',
    String role = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userPhoneKey, phone);
    await prefs.setString(_userRoleKey, role);

    await prefs.setBool(_isLoggedInKey, true);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPhoneKey);
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  static Future<void> saveUserPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPasswordKey, password);
  }

  static Future<String?> getUserPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPasswordKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}