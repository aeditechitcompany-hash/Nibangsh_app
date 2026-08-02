class ApiConstants {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  static const String register =
      "$baseUrl/accounts/auth/register/";

  static const String login =
      "$baseUrl/accounts/auth/login/";

  static const String refresh =
      "$baseUrl/accounts/auth/token/refresh/";
}