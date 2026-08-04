import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userPhoneKey = 'user_phone';
  static const String _userRoleKey = 'user_role';

  static const String _userPasswordKey = 'user_password';
  static const String _isLoggedInKey = 'is_logged_in';

  // Academic details
  static const String _academicCountryKey = 'academic_country';
  static const String _academicGpaKey = 'academic_gpa';
  static const String _academicPassoutYearKey = 'academic_passout_year';
  static const String _academicDegreeKey = 'academic_degree';
  static const String _academicDetailsCompleteKey = 'academic_details_complete';

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

  // ── Academic details ──
  static Future<void> saveAcademicDetails({
    required String country,
    required String gpa,
    required String passoutYear,
    required String degree,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_academicCountryKey, country);
    await prefs.setString(_academicGpaKey, gpa);
    await prefs.setString(_academicPassoutYearKey, passoutYear);
    await prefs.setString(_academicDegreeKey, degree);
    await prefs.setBool(_academicDetailsCompleteKey, true);
  }

  static Future<Map<String, String>> getAcademicDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'country': prefs.getString(_academicCountryKey) ?? '',
      'gpa': prefs.getString(_academicGpaKey) ?? '',
      'passoutYear': prefs.getString(_academicPassoutYearKey) ?? '',
      'degree': prefs.getString(_academicDegreeKey) ?? '',
    };
  }

  // True once the user has completed the academic details form at least once.
  static Future<bool> hasAcademicDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_academicDetailsCompleteKey) ?? false;
  }

  // Wipes only the academic-details keys (and the completion flag), without
  // touching auth tokens or anything else. Used when a different user logs
  // in on the same device so they don't inherit the previous user's data.
  static Future<void> clearAcademicDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_academicCountryKey);
    await prefs.remove(_academicGpaKey);
    await prefs.remove(_academicPassoutYearKey);
    await prefs.remove(_academicDegreeKey);
    await prefs.remove(_academicDetailsCompleteKey);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}