import 'dart:io';

import 'api_constants.dart';
import 'api_service.dart';

class StudentApplicationService {
  final ApiService _api = const ApiService();

  Future<Map<String, dynamic>> getMyApplication() async {
    final response = await _api.get(
      url:
      '${ApiConstants.baseUrl}/students/applications/me/',
    );

    if (response is! Map) {
      throw Exception(
        'Invalid application response from server.',
      );
    }

    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>> updateApplication({
    Map<String, String> fields = const {},
    Map<String, File> files = const {},
  }) async {
    final response = await _api.patchMultipart(
      url:
      '${ApiConstants.baseUrl}/students/applications/me/',
      fields: fields,
      files: files,
    );

    return response;
  }
}