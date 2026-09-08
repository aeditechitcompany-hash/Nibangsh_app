import 'package:nibangsh_consultancy/common/api_services/api_constants.dart';
import 'package:nibangsh_consultancy/common/api_services/api_service.dart';
import 'package:nibangsh_consultancy/common/models/quiz_models.dart';

class McqService {
  final ApiService _apiService = const ApiService();

  // ============================================================
  // GET QUESTION SET WITH QUESTIONS
  // ============================================================

  Future<QuizSet> getQuestionSet({
    required String questionSetId,
  }) async {
    final response = await _apiService.get(
      url:
      '${ApiConstants.baseUrl}/mcq/question-sets/$questionSetId/',
    );

    if (response is! Map) {
      throw Exception(
        'Invalid question set response from server.',
      );
    }

    final json = Map<String, dynamic>.from(response);

    print('========================================');
    print('MCQ QUESTION SET RESPONSE');
    print('ID: ${json['id']}');
    print('TITLE: ${json['title']}');
    print('QUESTIONS: ${json['questions']}');
    print('========================================');

    return QuizSet.fromJson(json);
  }

  // ============================================================
  // CREATE ATTEMPT
  // ============================================================

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

  // ============================================================
  // SUBMIT ANSWER
  // ============================================================

  Future<Map<String, dynamic>> submitAnswer({
    required int attemptId,
    required int questionId,
    int? selectedOptionId,
  }) async {
    return await _apiService.post(
      url:
      '${ApiConstants.baseUrl}/mcq/attempts/$attemptId/answer/',
      body: {
        'question': questionId,
        'selected_option': selectedOptionId,
      },
      authenticated: true,
    );
  }

  // ============================================================
  // FINISH ATTEMPT
  // ============================================================

  Future<Map<String, dynamic>> finishAttempt({
    required int attemptId,
  }) async {
    return await _apiService.post(
      url:
      '${ApiConstants.baseUrl}/mcq/attempts/$attemptId/finish/',
      body: {},
      authenticated: true,
    );
  }
}