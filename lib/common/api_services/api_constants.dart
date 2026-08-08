class ApiConstants {
  static const String baseUrl = "http://192.168.101.14:8000/api";

  static const String register =
      "$baseUrl/accounts/auth/register/";

  static const String login =
      "$baseUrl/accounts/auth/login/";

  static const String refresh =
      "$baseUrl/accounts/auth/token/refresh/";

  static const String students =
      "$baseUrl/accounts/users/";
}