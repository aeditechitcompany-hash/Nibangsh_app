import 'api_constants.dart';
import 'api_service.dart';

class ProcessService {
  final ApiService _api = const ApiService();

  Future<Map<String, dynamic>> completeStage({
    required String processId,
  }) async {
    final response = await _api.post(
      url:
      '${ApiConstants.baseUrl}/student-process/$processId/complete-stage/',
      body: {},
      authenticated: true,
    );

    if (response is! Map) {
      throw Exception('Invalid process response from server.');
    }

    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>> setStage({
    required String processId,
    required int stageOrder,
  }) async {
    final response = await _api.post(
      url:
      '${ApiConstants.baseUrl}/student-process/$processId/set-stage/',
      body: {
        'stage_order': stageOrder,
      },
      authenticated: true,
    );

    if (response is! Map) {
      throw Exception('Invalid process response from server.');
    }

    return Map<String, dynamic>.from(response);
  }
}