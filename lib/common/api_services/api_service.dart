import 'dart:convert';
import 'package:http/http.dart' as http;

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

    if (data is Map<String, dynamic>) {
      final buffer = StringBuffer();

      data.forEach((key, value) {
        buffer.writeln("$key : $value");
      });

      throw Exception(buffer.toString());
    }

    throw Exception("Unknown Error");
  }
}