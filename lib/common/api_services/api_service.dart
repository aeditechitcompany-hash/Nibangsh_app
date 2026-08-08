import 'dart:convert';

import 'package:http/http.dart' as http;

import 'token_storage_service.dart';

class ApiService {
  const ApiService();

  Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        ...?headers,
      },
      body: jsonEncode(body),
    );

    print("================================");
    print("POST URL: $url");
    print("REQUEST BODY: $body");
    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");
    print("================================");

    Map<String, dynamic> data = {};

    try {
      if (response.body.isNotEmpty) {
        data = jsonDecode(response.body);
      }
    } catch (_) {
      throw Exception(
        "Server returned non-JSON response.\n"
        "Status Code: ${response.statusCode}\n"
        "Body:\n${response.body}",
      );
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return data;
    }

    final buffer = StringBuffer();

    data.forEach((key, value) {
      buffer.writeln("$key : $value");
    });

    throw Exception(
      buffer.toString().isNotEmpty
          ? buffer.toString()
          : "Unknown Error",
    );
  }

  Future<dynamic> get({
    required String url,
    Map<String, String>? headers,
  }) async {
    final accessToken =
        await TokenStorageService.getAccessToken();

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",

        if (accessToken != null &&
            accessToken.isNotEmpty)
          "Authorization": "Bearer $accessToken",

        ...?headers,
      },
    );

    print("================================");
    print("GET URL: $url");
    print("ACCESS TOKEN EXISTS: ${accessToken != null}");
    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");
    print("================================");

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      if (response.body.isEmpty) {
        return [];
      }

      try {
        return jsonDecode(response.body);
      } catch (_) {
        throw Exception(
          "Server returned invalid JSON.\n"
          "Status Code: ${response.statusCode}\n"
          "Body:\n${response.body}",
        );
      }
    }

    throw Exception(
      "GET request failed.\n"
      "Status Code: ${response.statusCode}\n"
      "Body:\n${response.body}",
    );
  }
}
