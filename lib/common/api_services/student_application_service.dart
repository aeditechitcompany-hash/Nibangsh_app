import 'dart:io';

import 'api_constants.dart';
import 'api_service.dart';

class StudentApplicationService {
  final ApiService _api = const ApiService();

  // ============================================================
  // GET MY APPLICATION
  // ============================================================

  Future<Map<String, dynamic>> getMyApplication() async {
    final response = await _api.get(
      url: ApiConstants.myStudentApplication,
    );

    if (response is! Map) {
      throw Exception(
        'Invalid application response from server.',
      );
    }

    return Map<String, dynamic>.from(response);
  }

  // ============================================================
  // UPDATE MY APPLICATION
  // ============================================================

  Future<Map<String, dynamic>> updateApplication({
    Map<String, String> fields = const {},
    Map<String, File> files = const {},
  }) async {
    final response = await _api.patchMultipart(
      url: ApiConstants.myStudentApplication,
      fields: fields,
      files: files,
    );

    if (response is! Map) {
      throw Exception(
        'Invalid application response from server.',
      );
    }

    return Map<String, dynamic>.from(response);
  }

  // ============================================================
  // ADMIN: GET SPECIFIC STUDENT APPLICATION
  // ============================================================

  Future<Map<String, dynamic>> getStudentApplication(
      String applicationId,
      ) async {
    final response = await _api.get(
      url: ApiConstants.studentApplication(
        applicationId,
      ),
    );

    if (response is! Map) {
      throw Exception(
        'Invalid student application response.',
      );
    }

    return Map<String, dynamic>.from(response);
  }

  // ============================================================
  // ADMIN: UPDATE SPECIFIC STUDENT APPLICATION
  // ============================================================

  Future<Map<String, dynamic>> updateStudentApplication({
    required String applicationId,
    Map<String, String> fields = const {},
    Map<String, File> files = const {},
  }) async {
    final response = await _api.patchMultipart(
      url: ApiConstants.studentApplication(
        applicationId,
      ),
      fields: fields,
      files: files,
    );

    if (response is! Map) {
      throw Exception(
        'Invalid student application response.',
      );
    }

    return Map<String, dynamic>.from(response);
  }

  // ============================================================
  // ADMIN: UPLOAD / REPLACE ONE DOCUMENT
  // ============================================================

  Future<Map<String, dynamic>> uploadStudentDocument({
    required String applicationId,
    required String fieldName,
    required File file,
  }) async {
    return updateStudentApplication(
      applicationId: applicationId,
      files: {
        fieldName: file,
      },
    );
  }

  // ============================================================
  // ADMIN: UPLOAD MULTIPLE DOCUMENTS
  // ============================================================

  Future<Map<String, dynamic>> uploadStudentDocuments({
    required String applicationId,
    required Map<String, File> files,
  }) async {
    return updateStudentApplication(
      applicationId: applicationId,
      files: files,
    );
  }
}