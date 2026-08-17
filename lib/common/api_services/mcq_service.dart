import 'package:nibangsh_consultancy/common/api_services/api_constants.dart';
import 'package:nibangsh_consultancy/common/api_services/api_service.dart';

class McqService {
  final ApiService _apiService = const ApiService();

  Future<Map<String, dynamic>> createAttempt({
    required String questionSetId,
  }) async {
    return await _apiService.post(
      url: '${ApiConstants.baseUrl}/mcq/attempts/',
      body: {
        'question_set': questionSetId,
      },
      authenticated: true,
    );
  }

  Future<Map<String, dynamic>> submitAnswer({
    required int attemptId,
    required int questionId,
    int? selectedOptionId,
  }) async {
    return await _apiService.post(
      url: '${ApiConstants.baseUrl}/mcq/attempts/$attemptId/answer/',
      body: {
        'question': questionId,
        'selected_option': selectedOptionId,
      },
      authenticated: true,
    );
  }

  Future<Map<String, dynamic>> finishAttempt({
    required int attemptId,
  }) async {
    return await _apiService.post(
      url: '${ApiConstants.baseUrl}/mcq/attempts/$attemptId/finish/',
      body: {},
      authenticated: true,
    );
  }
}