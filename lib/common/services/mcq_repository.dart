import 'package:get/get.dart';

import '../api_services/api_constants.dart';
import '../api_services/api_service.dart';
import '../models/mcq_model.dart';

class McqRepository extends GetxService {
  static McqRepository get to =>
      Get.isRegistered<McqRepository>()
          ? Get.find<McqRepository>()
          : Get.put(
              McqRepository(),
              permanent: true,
            );

  final ApiService _apiService = const ApiService();

  final questions = <McqQuestion>[].obs;

  final isLoading = false.obs;

  final errorMessage = ''.obs;

  /// Loads all active MCQ sets from Django.
  ///
  /// The backend only returns question sets when the logged-in
  /// student has mcq_access=True.
  Future<List<Map<String, dynamic>>> fetchQuestionSets() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.get(
        url: ApiConstants.questionSets,
      );

      if (response is List) {
        return response
            .map(
              (item) => Map<String, dynamic>.from(item),
            )
            .toList();
      }

      // DRF pagination support.
      if (response is Map &&
          response['results'] is List) {
        return (response['results'] as List)
            .map(
              (item) => Map<String, dynamic>.from(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      errorMessage.value = e.toString();
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Loads one complete student-safe question set.
  ///
  /// IMPORTANT:
  /// This endpoint does NOT contain correct answers.
  Future<Map<String, dynamic>?> fetchQuestionSet(
    String questionSetId,
  ) async {
    try {
      final response = await _apiService.get(
        url: ApiConstants.questionSetTake(
          questionSetId,
        ),
      );

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }

      return null;
    } catch (e) {
      errorMessage.value = e.toString();
      return null;
    }
  }

  /// Convert one backend question into the existing
  /// McqQuestion model.
  McqQuestion questionFromBackend(
    Map<String, dynamic> json, {
    String? setName,
    String? questionSetId,
  }) {
    final rawOptions = json['options'] as List? ?? [];

    final optionIds = <String>[];
    final optionTexts = <String>[];
    final optionImages = <String>[];
    final optionAudios = <String>[];

    for (final raw in rawOptions) {
      final option = Map<String, dynamic>.from(raw);

      final id = option['id']?.toString() ?? '';
      final text = option['text']?.toString() ?? '';

      optionIds.add(id);
      optionTexts.add(text);

      optionImages.add(
        ApiConstants.mediaUrl(
          option['image']?.toString(),
        ),
      );

      optionAudios.add(
        ApiConstants.mediaUrl(
          option['audio']?.toString(),
        ),
      );
    }

    final createdAtString =
        json['created_at']?.toString();

    DateTime createdAt;

    if (createdAtString != null) {
      createdAt =
          DateTime.tryParse(createdAtString) ??
              DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return McqQuestion(
      id: json['id']?.toString() ?? '',
      question: json['text']?.toString() ?? '',
      options: optionTexts,

      // NEVER read is_correct here.
      // Students should not receive it.
      correctOptionIndex: null,

      questionImagePath: ApiConstants.mediaUrl(
        json['image']?.toString(),
      ),

      audioFilePath: ApiConstants.mediaUrl(
        json['audio']?.toString(),
      ),

      optionImagePaths: optionImages,
      optionAudioPaths: optionAudios,

      setName: setName,

      createdAt: createdAt,

      questionSetId: questionSetId,
      optionIds: optionIds,
    );
  }

  /// Convert a complete backend question-set response
  /// into McqQuestion objects.
  List<McqQuestion> questionsFromBackend(
    Map<String, dynamic> json,
  ) {
    final setId = json['id']?.toString();
    final setName = json['title']?.toString();

    final rawQuestions =
        json['questions'] as List? ?? [];

    return rawQuestions
        .map(
          (raw) => questionFromBackend(
            Map<String, dynamic>.from(raw),
            setName: setName,
            questionSetId: setId,
          ),
        )
        .toList();
  }

  void setQuestions(
    List<McqQuestion> newQuestions,
  ) {
    questions.assignAll(newQuestions);
    _sortQuestions();
  }

  void addQuestion(
    McqQuestion question,
  ) {
    questions.add(question);
    _sortQuestions();
  }

  void updateQuestion(
    McqQuestion updated,
  ) {
    final index = questions.indexWhere(
      (q) => q.id == updated.id,
    );

    if (index != -1) {
      questions[index] = updated;
      _sortQuestions();
    }
  }

  void removeQuestion(
    String id,
  ) {
    questions.removeWhere(
      (q) => q.id == id,
    );
  }

  void _sortQuestions() {
    questions.sort(
      (a, b) =>
          a.createdAt.compareTo(b.createdAt),
    );
  }
}