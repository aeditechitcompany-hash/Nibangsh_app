import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/models/quiz_models.dart';
import '../../../common/models/mcq_model.dart';
import '../../../common/services/mcq_repository.dart';
import '../../../common/api_services/api_service.dart';
import '../../../common/api_services/api_constants.dart';
import '../../../common/util/app_colors.dart';

class McqHomeController extends GetxController {
  final searchController = TextEditingController();

  final searchQuery = ''.obs;

  final bestScores = <String, int>{}.obs;

  final ApiService _apiService = const ApiService();

  final McqRepository _repository = McqRepository.to;

  // ============================================================
  // MCQ ACCESS
  // ============================================================

  final RxBool mcqAccess = false.obs;

  final RxBool isCheckingAccess = true.obs;

  final RxBool isRefreshingAccess = false.obs;

  // ============================================================
  // MCQ LOADING
  // ============================================================

  final RxBool isLoadingSets = false.obs;

  final RxString loadError = ''.obs;

  Timer? _accessPollingTimer;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });

    checkMcqAccess(
      showLoading: true,
    );
  }

  // ============================================================
  // ACCESS POLLING
  // ============================================================



  // ============================================================
  // CHECK MCQ ACCESS
  // ============================================================

  Future<void> checkMcqAccess({
    bool showLoading = false,
  }) async {
    try {
      if (showLoading) {
        isCheckingAccess.value = true;
      }

      final response = await _apiService.get(
        url: ApiConstants.myMcqAccess,
      );

      debugPrint('================================');
      debugPrint('MCQ ACCESS CHECK');
      debugPrint('Response: $response');
      debugPrint('================================');

      // Only update access when we successfully
      // receive a valid response.
      if (response is Map<String, dynamic>) {
        final access =
            response['mcq_access'] == true;

        mcqAccess.value = access;

        debugPrint(
          'MCQ ACCESS VALUE: ${mcqAccess.value}',
        );

        if (access) {
          await loadBackendQuestionSets();
        } else {
          _repository.questions.clear();
        }
      } else if (response is Map) {
        // Safe fallback for other Map implementations.
        final access =
            response['mcq_access'] == true;

        mcqAccess.value = access;

        debugPrint(
          'MCQ ACCESS VALUE: ${mcqAccess.value}',
        );

        if (access) {
          await loadBackendQuestionSets();
        } else {
          _repository.questions.clear();
        }
      }
    } catch (e) {
      debugPrint('================================');
      debugPrint('MCQ ACCESS ERROR');
      debugPrint(e.toString());
      debugPrint('================================');

      // IMPORTANT:
      //
      // Do NOT do:
      //
      // mcqAccess.value = false;
      //
      // A network/DNS/API error does not mean
      // that the student's access was revoked.
      //
      // Keep the previous valid access value.
    } finally {
      if (showLoading) {
        isCheckingAccess.value = false;
      }
    }
  }

  // ============================================================
  // REFRESH ACCESS
  // ============================================================

  Future<void> refreshAccess() async {
    if (isRefreshingAccess.value) {
      return;
    }

    isRefreshingAccess.value = true;

    try {
      await checkMcqAccess(
        showLoading: false,
      );
    } finally {
      isRefreshingAccess.value = false;
    }
  }

  // ============================================================
  // LOAD BACKEND QUESTION SETS
  // ============================================================

  /// Fetch every active question set from Django
  /// and then fetch its student-safe questions.
  Future<void> loadBackendQuestionSets() async {
    try {
      isLoadingSets.value = true;
      loadError.value = '';

      final sets =
      await _repository.fetchQuestionSets();

      final backendQuestions = <McqQuestion>[];

      for (final set in sets) {
        final setId = set['id']?.toString();

        if (setId == null || setId.isEmpty) {
          continue;
        }

        final fullSet =
        await _repository.fetchQuestionSet(
          setId,
        );

        if (fullSet == null) {
          continue;
        }

        backendQuestions.addAll(
          _repository.questionsFromBackend(
            fullSet,
          ),
        );
      }

      _repository.setQuestions(
        backendQuestions,
      );

      debugPrint(
        'Loaded ${backendQuestions.length} '
            'MCQ questions from Django.',
      );
    } catch (e) {
      loadError.value = e.toString();

      debugPrint(
        'MCQ SET LOAD ERROR: $e',
      );
    } finally {
      isLoadingSets.value = false;
    }
  }

  // ============================================================
  // ALL MCQ SETS
  // ============================================================

  List<QuizSet> get allSets {
    if (!mcqAccess.value) {
      return [];
    }

    // Group by actual question_set_id (UUID) from backend.
    final grouped =
    <String, List<McqQuestion>>{};

    for (final q in _repository.questions) {
      final questionSetId =
      (q.questionSetId ?? '').trim();

      if (questionSetId.isEmpty) {
        continue;
      }

      grouped
          .putIfAbsent(
        questionSetId,
            () => [],
      )
          .add(q);
    }

    final backendSets =
    grouped.entries
        .map(
          (entry) => _toQuizSet(
        entry.value[0].setName ?? 'Quiz',
        entry.key,
        entry.value,
      ),
    )
        .toList();

    // Sort Quiz Sets in ascending numerical order.
    backendSets.sort((a, b) {
      final aNumber =
      _extractSetNumber(a.title);

      final bNumber =
      _extractSetNumber(b.title);

      return aNumber.compareTo(bNumber);
    });

    return [
      ...backendSets,
    ];
  }

  // ============================================================
  // EXTRACT SET NUMBER
  // ============================================================

  int _extractSetNumber(String title) {
    final match = RegExp(r'\d+').firstMatch(title);

    if (match != null) {
      return int.tryParse(
        match.group(0)!,
      ) ??
          999999;
    }

    return 999999;
  }

  // ============================================================
  // FILTERED SETS
  // ============================================================

  List<QuizSet> get filteredSets {
    final sets = allSets;

    if (searchQuery.value.isEmpty) {
      return sets;
    }

    final query =
    searchQuery.value.toLowerCase();

    return sets.where(
          (set) => set.title
          .toLowerCase()
          .contains(query),
    ).toList();
  }

  // ============================================================
  // ADMIN SET COLORS
  // ============================================================

  static const List<Color> _adminSetPalette = [
    AppColors.primaryBlue,
    Color(0xFF16A34A),
    Color(0xFF9333EA),
    Color(0xFFF59E0B),
    Color(0xFFDC2626),
  ];

  // ============================================================
  // CONVERT TO QUIZ SET
  // ============================================================

  QuizSet _toQuizSet(
      String setName,
      String questionSetId,
      List<McqQuestion> questions,
      ) {
    final ordered = [...questions]
      ..sort(
            (a, b) =>
            a.createdAt.compareTo(
              b.createdAt,
            ),
      );

    final color =
    _adminSetPalette[
    questionSetId.hashCode.abs() %
        _adminSetPalette.length
    ];

    return QuizSet(
      id: questionSetId,
      title: setName,
      icon: Icons.quiz_outlined,
      color: color,
      questions: ordered
          .map(_toQuizQuestion)
          .toList(),
    );
  }

  // ============================================================
  // CONVERT TO QUIZ QUESTION
  // ============================================================

  QuizQuestion _toQuizQuestion(
      McqQuestion q,
      ) {
    final quizOpts = <QuizOption>[];

    final optionIds = q.optionIds ?? [];

    for (int i = 0;
    i < q.options.length;
    i++) {
      quizOpts.add(
        QuizOption(
          id: i < optionIds.length
              ? optionIds[i]
              : null,
          text: q.options[i],
          image:
          i <
              (q.optionImagePaths
                  ?.length ??
                  0)
              ? q.optionImagePaths![i]
              : null,
          audio:
          i <
              (q.optionAudioPaths
                  ?.length ??
                  0)
              ? q.optionAudioPaths![i]
              : null,
          order: i,
        ),
      );
    }

    return QuizQuestion(
      id: q.id,
      question:
      q.question.trim().isEmpty
          ? null
          : q.question,
      options: q.options,

      // Backend questions don't expose
      // correct answers to students.
      correctIndex:
      q.correctOptionIndex ?? -1,

      imageAsset:
      q.questionImagePath,

      optionImages:
      q.optionImagePaths,

      audioAsset:
      q.audioFilePath,

      optionAudios:
      q.optionAudioPaths,

      quizOptions: quizOpts,
    );
  }

  // ============================================================
  // RECORD SCORE
  // ============================================================

  void recordScore(
      String setId,
      int score,
      ) {
    final best = bestScores[setId];

    if (best == null ||
        score > best) {
      bestScores[setId] = score;
    }
  }

  // ============================================================
  // BEST SCORE
  // ============================================================

  int? bestScoreFor(
      String setId,
      ) {
    return bestScores[setId];
  }

  // ============================================================
  // FIRST SET
  // ============================================================

  QuizSet? get firstSet {
    final sets = allSets;

    if (sets.isEmpty) {
      return null;
    }

    return sets.first;
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  void onClose() {
    _accessPollingTimer?.cancel();
    _accessPollingTimer = null;

    searchController.dispose();

    super.onClose();
  }
}