class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      "http://192.168.254.13:8000/api";

  static const String register =
      "$baseUrl/accounts/auth/register/";

  static const String login =
      "$baseUrl/accounts/auth/login/";

  static const String refresh =
      "$baseUrl/accounts/auth/token/refresh/";
}