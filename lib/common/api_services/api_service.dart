import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'token_storage_service.dart';

class ApiService {
  const ApiService();

  // Access tokens expire after 60 minutes (SIMPLE_JWT.ACCESS_TOKEN_LIFETIME on
  // the backend). Without this, any request made after expiry keeps sending
  // the stale token and permanently 401s until the user logs out and back in.
  Future<bool> _tryRefreshToken() async {
    final refreshToken = await TokenStorageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.refresh),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refresh": refreshToken}),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return false;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final newAccess = data["access"] as String?;
      if (newAccess == null || newAccess.isEmpty) return false;

      // ROTATE_REFRESH_TOKENS is on, so a new refresh token may come back too.
      final newRefresh = (data["refresh"] as String?) ?? refreshToken;

      await TokenStorageService.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> restoreSession() async {
    final accessToken = await TokenStorageService.getAccessToken();
    final refreshToken = await TokenStorageService.getRefreshToken();

    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }

    // We already have an access token.
    // It may still be valid, so let the caller use it.
    if (refreshToken == null || refreshToken.isEmpty) {
      return true;
    }

    return true;
  }

  Future<Map<String, String>> _authHeaders() async {
    final accessToken = await TokenStorageService.getAccessToken();
    return {
      "Content-Type": "application/json",
      if (accessToken != null && accessToken.isNotEmpty)
        "Authorization": "Bearer $accessToken",
    };
  }

  dynamic _decodeOrThrow(http.Response response) {
    if (response.body.isEmpty) return null;
    try {
      return jsonDecode(response.body);
    } catch (_) {
      throw Exception(
        "Server returned non-JSON response.\n"
        "Status Code: ${response.statusCode}\n"
        "Body:\n${response.body}",
      );
    }
  }

  Never _throwFromErrorBody(http.Response response, dynamic data) {
    if (data is Map) {
      final buffer = StringBuffer();
      data.forEach((key, value) {
        buffer.writeln("$key : $value");
      });
      throw Exception(
        buffer.toString().isNotEmpty ? buffer.toString() : "Unknown Error",
      );
    }
    throw Exception(
      "Request failed.\n"
      "Status Code: ${response.statusCode}\n"
      "Body:\n${response.body}",
    );
  }

  Future<dynamic> _sendJson({
    required String method,
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool authenticated = false,
    bool isRetryAttempt = false,
  }) async {
    final mergedHeaders = <String, String>{
      "Content-Type": "application/json",
      if (authenticated) ...await _authHeaders(),
      ...?headers,
    };

    late final http.Response response;
    final uri = Uri.parse(url);
    final encodedBody = body != null ? jsonEncode(body) : null;

    switch (method) {
      case "POST":
        response = await http.post(uri, headers: mergedHeaders, body: encodedBody);
        break;
      case "PATCH":
        response = await http.patch(uri, headers: mergedHeaders, body: encodedBody);
        break;
      case "GET":
        response = await http.get(uri, headers: mergedHeaders);
        break;
      default:
        throw ArgumentError("Unsupported method: $method");
    }

    print("$method URL: $url");
    if (body != null) print("REQUEST BODY: $body");
    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return method == "GET" ? [] : {};
      return _decodeOrThrow(response);
    }

    if (response.statusCode == 401 && authenticated) {
      final accessToken = await TokenStorageService.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception(
          "Not logged in — no access token found. Log in again before "
          "trying this action.",
        );
      }

      if (!isRetryAttempt) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          return _sendJson(
            method: method,
            url: url,
            body: body,
            headers: headers,
            authenticated: authenticated,
            isRetryAttempt: true,
          );
        }
      }

      await TokenStorageService.clearStorage();
      throw Exception("Session expired. Please log in again.");
    }

    final data = _decodeOrThrow(response);
    _throwFromErrorBody(response, data);
  }

  Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    bool authenticated = false,
  }) async {
    final result = await _sendJson(
      method: "POST",
      url: url,
      body: body,
      headers: headers,
      authenticated: authenticated,
    );
    return (result as Map?)?.cast<String, dynamic>() ?? {};
  }

  Future<Map<String, dynamic>> patch({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    bool authenticated = true,
  }) async {
    final result = await _sendJson(
      method: "PATCH",
      url: url,
      body: body,
      headers: headers,
      authenticated: authenticated,
    );
    return (result as Map?)?.cast<String, dynamic>() ?? {};
  }

  Future<dynamic> get({
    required String url,
    Map<String, String>? headers,
  }) async {
    return _sendJson(
      method: "GET",
      url: url,
      headers: headers,
      authenticated: true,
    );
  }
}