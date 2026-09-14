import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_constants.dart';
import 'token_storage_service.dart';

class ApiService {
  const ApiService();

  // ============================================================
  // TOKEN REFRESH
  // ============================================================

  Future<bool> _tryRefreshToken() async {
    final refreshToken =
    await TokenStorageService.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final response = await http
          .post(
        Uri.parse(ApiConstants.refresh),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "refresh": refreshToken,
        }),
      )
          .timeout(
        const Duration(seconds: 30),
      );

      debugPrint("========== TOKEN REFRESH ==========");
      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");
      debugPrint("===================================");

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        return false;
      }

      if (response.body.isEmpty) {
        return false;
      }

      final data =
      jsonDecode(response.body) as Map<String, dynamic>;

      final newAccess =
      data["access"] as String?;

      if (newAccess == null || newAccess.isEmpty) {
        return false;
      }

      // Because ROTATE_REFRESH_TOKENS may be enabled,
      // Django may return a new refresh token.
      final newRefresh =
          (data["refresh"] as String?) ?? refreshToken;

      await TokenStorageService.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );

      return true;
    } catch (e) {
      debugPrint(
        "TOKEN REFRESH ERROR: $e",
      );
      return false;
    }
  }

  // ============================================================
  // RESTORE SESSION
  // ============================================================

  Future<bool> restoreSession() async {
    final accessToken =
    await TokenStorageService.getAccessToken();

    final refreshToken =
    await TokenStorageService.getRefreshToken();

    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }

    if (refreshToken == null || refreshToken.isEmpty) {
      return true;
    }

    return true;
  }

  // ============================================================
  // AUTH HEADERS
  // ============================================================

  Future<Map<String, String>> _authHeaders() async {
    final accessToken =
    await TokenStorageService.getAccessToken();

    return {
      "Content-Type": "application/json",
      if (accessToken != null && accessToken.isNotEmpty)
        "Authorization": "Bearer $accessToken",
    };
  }

  // ============================================================
  // JSON DECODER
  // ============================================================

  dynamic _decodeOrThrow(
      http.Response response,
      ) {
    if (response.body.isEmpty) {
      return null;
    }

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

  // ============================================================
  // ERROR HANDLER
  // ============================================================

  Never _throwFromErrorBody(
      http.Response response,
      dynamic data,
      ) {
    if (data is Map) {
      final buffer = StringBuffer();

      data.forEach((key, value) {
        buffer.writeln("$key : $value");
      });

      final message = buffer.toString().trim();

      throw Exception(
        message.isNotEmpty
            ? message
            : "Unknown server error.",
      );
    }

    throw Exception(
      "Request failed.\n"
          "Status Code: ${response.statusCode}\n"
          "Body:\n${response.body}",
    );
  }

  // ============================================================
  // JSON REQUEST
  // ============================================================

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

    late http.Response response;

    final uri = Uri.parse(url);

    final encodedBody =
    body != null ? jsonEncode(body) : null;

    try {
      switch (method) {
        case "POST":
          response = await http
              .post(
            uri,
            headers: mergedHeaders,
            body: encodedBody,
          )
              .timeout(
            const Duration(seconds: 60),
          );
          break;

        case "PATCH":
          response = await http
              .patch(
            uri,
            headers: mergedHeaders,
            body: encodedBody,
          )
              .timeout(
            const Duration(seconds: 60),
          );
          break;

        case "GET":
          response = await http
              .get(
            uri,
            headers: mergedHeaders,
          )
              .timeout(
            const Duration(seconds: 60),
          );
          break;

        default:
          throw ArgumentError(
            "Unsupported method: $method",
          );
      }
    } catch (e) {
      debugPrint(
        "$method REQUEST ERROR: $e",
      );

      rethrow;
    }

    debugPrint("====================================");
    debugPrint("$method URL: $url");

    if (body != null) {
      debugPrint("REQUEST BODY: $body");
    }

    debugPrint(
      "STATUS CODE: ${response.statusCode}",
    );

    debugPrint(
      "RESPONSE BODY: ${response.body}",
    );

    debugPrint("====================================");

    // ==========================================================
    // SUCCESS
    // ==========================================================

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      if (response.body.isEmpty) {
        return method == "GET" ? [] : {};
      }

      return _decodeOrThrow(response);
    }

    // ==========================================================
    // ACCESS TOKEN EXPIRED
    // ==========================================================

    if (response.statusCode == 401 &&
        authenticated) {
      final accessToken =
      await TokenStorageService.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception(
          "Not logged in — no access token found. "
              "Please log in again.",
        );
      }

      if (!isRetryAttempt) {
        debugPrint(
          "JWT expired. Attempting token refresh...",
        );

        final refreshed =
        await _tryRefreshToken();

        if (refreshed) {
          debugPrint(
            "Token refreshed successfully. Retrying request...",
          );

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

      throw Exception(
        "Session expired. Please log in again.",
      );
    }

    // ==========================================================
    // SERVER ERROR
    // ==========================================================

    final data = _decodeOrThrow(response);

    _throwFromErrorBody(
      response,
      data,
    );
  }

  // ============================================================
  // POST JSON
  // ============================================================

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

    if (result is Map) {
      return Map<String, dynamic>.from(result);
    }

    return {};
  }

  // ============================================================
  // PATCH JSON
  // ============================================================

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

    if (result is Map) {
      return Map<String, dynamic>.from(result);
    }

    return {};
  }

  // ============================================================
  // GET
  // ============================================================

  Future<dynamic> get({
    required String url,
    Map<String, String>? headers,
    bool authenticated = true,
  }) async {
    return _sendJson(
      method: "GET",
      url: url,
      headers: headers,
      authenticated: authenticated,
    );
  }

  // ============================================================
  // POST MULTIPART
  // ============================================================

  Future<Map<String, dynamic>> postMultipart({
    required String url,
    required Map<String, String> fields,
    Map<String, File> files = const {},
    bool authenticated = true,
    bool isRetryAttempt = false,
  }) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(url),
      );

      // --------------------------------------------------------
      // AUTHORIZATION
      // --------------------------------------------------------

      if (authenticated) {
        final accessToken =
        await TokenStorageService.getAccessToken();

        if (accessToken != null &&
            accessToken.isNotEmpty) {
          request.headers["Authorization"] =
          "Bearer $accessToken";
        }
      }

      // --------------------------------------------------------
      // FIELDS
      // --------------------------------------------------------

      request.fields.addAll(fields);

      // --------------------------------------------------------
      // FILES
      // --------------------------------------------------------

      for (final entry in files.entries) {
        final fieldName = entry.key;
        final file = entry.value;

        if (!await file.exists()) {
          throw Exception(
            "File does not exist: ${file.path}",
          );
        }

        final size = await file.length();

        debugPrint(
          "Uploading $fieldName: "
              "${(size / 1024 / 1024).toStringAsFixed(2)} MB",
        );

        request.files.add(
          await http.MultipartFile.fromPath(
            fieldName,
            file.path,
          ),
        );
      }

      debugPrint("====================================");
      debugPrint("MULTIPART POST START");
      debugPrint("URL: $url");
      debugPrint("FIELDS: $fields");
      debugPrint(
        "FILES: ${files.map(
              (key, value) => MapEntry(
            key,
            value.path,
          ),
        )}",
      );
      debugPrint("====================================");

      final streamedResponse = await request
          .send()
          .timeout(
        const Duration(minutes: 2),
      );

      final response =
      await http.Response.fromStream(
        streamedResponse,
      );

      debugPrint("====================================");
      debugPrint("MULTIPART POST RESPONSE");
      debugPrint(
        "STATUS: ${response.statusCode}",
      );
      debugPrint(
        "BODY: ${response.body}",
      );
      debugPrint("====================================");

      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        if (response.body.isEmpty) {
          return {};
        }

        final data = jsonDecode(
          response.body,
        );

        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }

        return {};
      }

      // --------------------------------------------------------
      // TOKEN EXPIRED
      // --------------------------------------------------------

      if (response.statusCode == 401 &&
          authenticated &&
          !isRetryAttempt) {
        debugPrint(
          "Multipart POST received 401. "
              "Refreshing token...",
        );

        final refreshed =
        await _tryRefreshToken();

        if (refreshed) {
          return postMultipart(
            url: url,
            fields: fields,
            files: files,
            authenticated: authenticated,
            isRetryAttempt: true,
          );
        }

        await TokenStorageService.clearStorage();

        throw Exception(
          "Session expired. Please log in again.",
        );
      }

      // --------------------------------------------------------
      // ERROR
      // --------------------------------------------------------

      dynamic data;

      try {
        data = jsonDecode(response.body);
      } catch (_) {
        throw Exception(
          "Upload failed.\n"
              "Status Code: ${response.statusCode}\n"
              "Body:\n${response.body}",
        );
      }

      _throwFromErrorBody(
        response,
        data,
      );
    } catch (e) {
      debugPrint("====================================");
      debugPrint("MULTIPART POST ERROR");
      debugPrint("$e");
      debugPrint("====================================");

      rethrow;
    }
  }

  // ============================================================
  // PATCH MULTIPART
  // ============================================================

  Future<Map<String, dynamic>> patchMultipart({
    required String url,
    required Map<String, String> fields,
    Map<String, File> files = const {},
    bool authenticated = true,
    bool isRetryAttempt = false,
  }) async {
    try {
      final request = http.MultipartRequest(
        "PATCH",
        Uri.parse(url),
      );

      // --------------------------------------------------------
      // AUTHORIZATION
      // --------------------------------------------------------

      if (authenticated) {
        final accessToken =
        await TokenStorageService.getAccessToken();

        if (accessToken != null &&
            accessToken.isNotEmpty) {
          request.headers["Authorization"] =
          "Bearer $accessToken";
        }
      }

      // --------------------------------------------------------
      // FIELDS
      // --------------------------------------------------------

      request.fields.addAll(fields);

      // --------------------------------------------------------
      // FILES
      // --------------------------------------------------------

      for (final entry in files.entries) {
        final fieldName = entry.key;
        final file = entry.value;

        if (!await file.exists()) {
          throw Exception(
            "File does not exist: ${file.path}",
          );
        }

        final fileSize = await file.length();

        debugPrint(
          "Uploading $fieldName: "
              "${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB",
        );

        request.files.add(
          await http.MultipartFile.fromPath(
            fieldName,
            file.path,
          ),
        );
      }

      debugPrint("====================================");
      debugPrint("MULTIPART PATCH START");
      debugPrint("URL: $url");
      debugPrint("FIELDS: $fields");
      debugPrint(
        "FILES: ${files.map(
              (key, value) => MapEntry(
            key,
            value.path,
          ),
        )}",
      );
      debugPrint("====================================");

      // --------------------------------------------------------
      // SEND
      // --------------------------------------------------------

      final streamedResponse = await request
          .send()
          .timeout(
        const Duration(minutes: 2),
      );

      final response =
      await http.Response.fromStream(
        streamedResponse,
      );

      debugPrint("====================================");
      debugPrint("MULTIPART PATCH RESPONSE");
      debugPrint(
        "STATUS: ${response.statusCode}",
      );
      debugPrint(
        "BODY: ${response.body}",
      );
      debugPrint("====================================");

      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        if (response.body.isEmpty) {
          return {};
        }

        dynamic data;

        try {
          data = jsonDecode(response.body);
        } catch (_) {
          throw Exception(
            "Server returned an invalid response.",
          );
        }

        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }

        return {};
      }

      // --------------------------------------------------------
      // TOKEN EXPIRED
      // --------------------------------------------------------

      if (response.statusCode == 401 &&
          authenticated &&
          !isRetryAttempt) {
        debugPrint(
          "Multipart PATCH received 401. "
              "Refreshing token...",
        );

        final refreshed =
        await _tryRefreshToken();

        if (refreshed) {
          debugPrint(
            "Token refreshed. Retrying PATCH...",
          );

          return patchMultipart(
            url: url,
            fields: fields,
            files: files,
            authenticated: authenticated,
            isRetryAttempt: true,
          );
        }

        await TokenStorageService.clearStorage();

        throw Exception(
          "Session expired. Please log in again.",
        );
      }

      // --------------------------------------------------------
      // ERROR
      // --------------------------------------------------------

      dynamic data;

      try {
        data = jsonDecode(response.body);
      } catch (_) {
        throw Exception(
          "Upload failed.\n"
              "Status Code: ${response.statusCode}\n"
              "Body:\n${response.body}",
        );
      }

      _throwFromErrorBody(
        response,
        data,
      );
    } catch (e) {
      debugPrint("====================================");
      debugPrint("MULTIPART PATCH ERROR");
      debugPrint("$e");
      debugPrint("====================================");

      rethrow;
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> delete({
    required String url,
    Map<String, String>? headers,
    bool authenticated = true,
    bool isRetryAttempt = false,
  }) async {
    final mergedHeaders = <String, String>{
      if (authenticated) ...await _authHeaders(),
      ...?headers,
    };

    final uri = Uri.parse(url);

    final response = await http
        .delete(
      uri,
      headers: mergedHeaders,
    )
        .timeout(
      const Duration(seconds: 60),
    );

    debugPrint("====================================");
    debugPrint("DELETE URL: $url");
    debugPrint(
      "STATUS CODE: ${response.statusCode}",
    );
    debugPrint(
      "RESPONSE BODY: ${response.body}",
    );
    debugPrint("====================================");

    // ----------------------------------------------------------
    // SUCCESS
    // ----------------------------------------------------------

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return;
    }

    // ----------------------------------------------------------
    // TOKEN EXPIRED
    // ----------------------------------------------------------

    if (response.statusCode == 401 &&
        authenticated &&
        !isRetryAttempt) {
      debugPrint(
        "DELETE received 401. Refreshing token...",
      );

      final refreshed =
      await _tryRefreshToken();

      if (refreshed) {
        return delete(
          url: url,
          headers: headers,
          authenticated: authenticated,
          isRetryAttempt: true,
        );
      }

      await TokenStorageService.clearStorage();

      throw Exception(
        "Session expired. Please log in again.",
      );
    }

    // ----------------------------------------------------------
    // ERROR
    // ----------------------------------------------------------

    dynamic data;

    try {
      data = _decodeOrThrow(response);
    } catch (_) {
      throw Exception(
        "Delete failed.\n"
            "Status Code: ${response.statusCode}\n"
            "Body:\n${response.body}",
      );
    }

    _throwFromErrorBody(
      response,
      data,
    );
  }
}