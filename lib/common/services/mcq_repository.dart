import 'package:flutter/foundation.dart';
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

  // ============================================================
  // LOAD QUESTION SETS
  // ============================================================

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
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // LOAD ONE QUESTION SET
  // ============================================================

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

  // ============================================================
  // LOAD ADMIN QUESTION SET
  //
  // IMPORTANT:
  // Admin receives QuestionSetDetailSerializer.
  //
  // Therefore:
  // - options are included
  // - is_correct is included
  // - explanation is included
  // ============================================================

  Future<Map<String, dynamic>?> fetchAdminQuestionSet(
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
      rethrow;
    }
  }

  // ============================================================
  // QUESTION -> MODEL
  // ============================================================

  McqQuestion questionFromBackend(
      Map<String, dynamic> json, {
        String? setName,
        String? questionSetId,
        bool admin = false,
      }) {
    final rawOptions =
        json['options'] as List? ?? [];

    final optionIds = <String>[];
    final optionTexts = <String>[];
    final optionImages = <String>[];
    final optionAudios = <String>[];

    int? correctIndex;

    for (var i = 0; i < rawOptions.length; i++) {
      final option =
      Map<String, dynamic>.from(rawOptions[i]);

      final id =
          option['id']?.toString() ?? '';

      final text =
          option['text']?.toString() ?? '';

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

      // ONLY ADMIN DATA may read is_correct.
      if (admin &&
          option['is_correct'] == true) {
        correctIndex = i;
      }
    }

    final createdAtString =
    json['created_at']?.toString();

    final createdAt =
    createdAtString != null
        ? DateTime.tryParse(
      createdAtString,
    ) ??
        DateTime.now()
        : DateTime.now();

    return McqQuestion(
      id: json['id']?.toString() ?? '',
      question:
      json['text']?.toString() ?? '',
      options: optionTexts,

      correctOptionIndex:
      admin ? correctIndex : null,

      questionImagePath:
      ApiConstants.mediaUrl(
        json['image']?.toString(),
      ),

      audioFilePath:
      ApiConstants.mediaUrl(
        json['audio']?.toString(),
      ),

      optionImagePaths:
      optionImages,

      optionAudioPaths:
      optionAudios,

      setName: setName,

      createdAt: createdAt,

      questionSetId:
      questionSetId,

      optionIds: optionIds,
    );
  }

  // ============================================================
  // QUESTION SET -> QUESTIONS
  // ============================================================

  List<McqQuestion> questionsFromBackend(
      Map<String, dynamic> json, {
        bool admin = false,
      }) {
    final setId =
    json['id']?.toString();

    final setName =
    json['title']?.toString();

    final rawQuestions =
        json['questions'] as List? ?? [];

    return rawQuestions
        .map(
          (raw) => questionFromBackend(
        Map<String, dynamic>.from(raw),
        setName: setName,
        questionSetId: setId,
        admin: admin,
      ),
    )
        .toList();
  }

  // ============================================================
  // SET LOCAL QUESTIONS
  // ============================================================

  void setQuestions(
      List<McqQuestion> newQuestions,
      ) {
    questions.assignAll(newQuestions);
    _sortQuestions();
  }

  // ============================================================
  // UPDATE QUESTION ON DJANGO
  // ============================================================

  Future<McqQuestion> updateQuestionOnServer(
      McqQuestion updated,
      ) async {
    if (updated.id.isEmpty) {
      throw Exception(
        'Question ID is missing.',
      );
    }

    // ----------------------------------------------------------
    // 1. UPDATE QUESTION
    // ----------------------------------------------------------

    final questionResponse =
    await _apiService.patch(
      url: ApiConstants.mcqQuestion(
        updated.id,
      ),
      body: {
        'text': updated.question,
      },
      authenticated: true,
    );

    debugPrint(
      'QUESTION UPDATE RESPONSE: '
          '$questionResponse',
    );

    // ----------------------------------------------------------
    // 2. UPDATE OPTIONS
    // ----------------------------------------------------------

    if (updated.optionIds == null ||
        updated.optionIds!.length !=
            updated.options.length) {
      throw Exception(
        'Option IDs are missing or do not match the options.',
      );
    }

    for (
    var i = 0;
    i < updated.options.length;
    i++
    ) {
      final optionId =
      updated.optionIds![i];

      await _apiService.patch(
        url: ApiConstants.mcqOption(
          optionId,
        ),
        body: {
          'text': updated.options[i],
          'is_correct':
          i ==
              updated.correctOptionIndex,
          'order': i,
        },
        authenticated: true,
      );
    }

    // ----------------------------------------------------------
    // 3. RELOAD QUESTION
    // ----------------------------------------------------------

    final refreshed =
    await _apiService.get(
      url: ApiConstants.mcqQuestion(
        updated.id,
      ),
    );

    if (refreshed is! Map) {
      throw Exception(
        'Invalid question response from server.',
      );
    }

    final result =
    questionFromBackend(
      Map<String, dynamic>.from(
        refreshed,
      ),
      setName: updated.setName,
      questionSetId:
      updated.questionSetId,
      admin: true,
    );

    // ----------------------------------------------------------
    // 4. UPDATE LOCAL STATE
    // ----------------------------------------------------------

    final index =
    questions.indexWhere(
          (q) => q.id == updated.id,
    );

    if (index != -1) {
      questions[index] = result;
      _sortQuestions();
    }

    return result;
  }

  // ============================================================
  // DELETE QUESTION
  // ============================================================

  Future<void> deleteQuestionOnServer(
      String id,
      ) async {
    await _apiService.delete(
      url: ApiConstants.mcqQuestion(id),
      authenticated: true,
    );

    questions.removeWhere(
          (q) => q.id == id,
    );
  }

  // ============================================================
  // LOCAL HELPERS
  // ============================================================

// ============================================================
// LOCAL HELPERS
// ============================================================

  void addQuestion(McqQuestion question) {
    questions.add(question);
    _sortQuestions();
  }

  void updateQuestion(McqQuestion updated) {
    final index = questions.indexWhere(
          (q) => q.id == updated.id,
    );

    if (index != -1) {
      questions[index] = updated;
      _sortQuestions();
    }
  }

  void removeQuestion(String id) {
    questions.removeWhere(
          (q) => q.id == id,
    );
  }

  void _sortQuestions() {
    questions.sort(
          (a, b) => a.createdAt.compareTo(b.createdAt),
    );
  }
}