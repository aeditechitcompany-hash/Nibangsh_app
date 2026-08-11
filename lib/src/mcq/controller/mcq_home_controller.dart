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

  // ─────────────────────────────────────────────
  // API
  // ─────────────────────────────────────────────

  final ApiService _apiService = const ApiService();

  // Database value:
  // true  = student can access MCQs
  // false = student must wait for admin approval
  final RxBool mcqAccess = false.obs;

  // True only during the initial/manual access check.
  final RxBool isCheckingAccess = true.obs;

  // Used for the "Check Again" button.
  final RxBool isRefreshingAccess = false.obs;

  // Automatically checks Django periodically.
  Timer? _accessPollingTimer;

  // ─────────────────────────────────────────────
  // INITIALIZATION
  // ─────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });

    // First check immediately.
    checkMcqAccess(showLoading: true);

    // Then keep checking automatically.
    //
    // Example:
    // Admin changes false -> true in Django
    // ↓
    // Within max ~5 seconds Flutter sees true
    // ↓
    // MCQ screen changes automatically
    _startAccessPolling();
  }

  // ─────────────────────────────────────────────
  // AUTOMATIC ACCESS POLLING
  // ─────────────────────────────────────────────

  void _startAccessPolling() {
    _accessPollingTimer?.cancel();

    _accessPollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) async {
        // Do not show the big loading screen during background checks.
        await checkMcqAccess(showLoading: false);
      },
    );
  }

  // ─────────────────────────────────────────────
  // CHECK MCQ ACCESS
  // ─────────────────────────────────────────────

  Future<void> checkMcqAccess({
    bool showLoading = false,
  }) async {
    if (showLoading) {
      isCheckingAccess.value = true;
    }

    try {
      final response = await _apiService.get(
        url: ApiConstants.myMcqAccess,
      );

      final bool newAccess =
          response is Map && response["mcq_access"] == true;

      // Only print when useful.
      print("================================");
      print("MCQ ACCESS CHECK");
      print("Response: $response");
      print("MCQ Access: $newAccess");
      print("================================");

      // RxBool automatically rebuilds all Obx widgets.
      mcqAccess.value = newAccess;
    } catch (e) {
      print("================================");
      print("MCQ ACCESS CHECK ERROR");
      print(e);
      print("================================");

      // SECURITY:
      // If backend cannot be reached, do not grant access.
      mcqAccess.value = false;
    } finally {
      if (showLoading) {
        isCheckingAccess.value = false;
      }
    }
  }

  // ─────────────────────────────────────────────
  // MANUAL REFRESH
  // ─────────────────────────────────────────────

  Future<void> refreshAccess() async {
    if (isRefreshingAccess.value) return;

    isRefreshingAccess.value = true;

    try {
      await checkMcqAccess(showLoading: false);
    } finally {
      isRefreshingAccess.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // ALL QUIZ SETS
  // ─────────────────────────────────────────────

  List<QuizSet> get allSets {
    // SECURITY:
    // Never expose any MCQ set when access is false.
    if (!mcqAccess.value) {
      return [];
    }

    final grouped = <String, List<McqQuestion>>{};

    // Admin-created MCQs.
    for (final q in McqRepository.to.questions) {
      final setName = (q.setName ?? '').trim();

      if (setName.isEmpty) {
        continue;
      }

      grouped.putIfAbsent(setName, () => []).add(q);
    }

    final adminSets = grouped.entries
        .map(
          (entry) => _toQuizSet(
            entry.key,
            entry.value,
          ),
        )
        .toList();

    // Static/bundled sets + admin-created sets.
    return [
      ...QuizCatalog.sets,
      ...adminSets,
    ];
  }

  // ─────────────────────────────────────────────
  // SEARCH
  // ─────────────────────────────────────────────

  List<QuizSet> get filteredSets {
    final sets = allSets;

    if (searchQuery.value.isEmpty) {
      return sets;
    }

    final query = searchQuery.value.toLowerCase();

    return sets.where(
      (set) => set.title.toLowerCase().contains(query),
    ).toList();
  }

  // ─────────────────────────────────────────────
  // ADMIN SET COLORS
  // ─────────────────────────────────────────────

  static const List<Color> _adminSetPalette = [
    AppColors.primaryBlue,
    Color(0xFF16A34A),
    Color(0xFF9333EA),
    Color(0xFFF59E0B),
    Color(0xFFDC2626),
  ];

  // ─────────────────────────────────────────────
  // CONVERT ADMIN MCQ → QUIZ SET
  // ─────────────────────────────────────────────

  QuizSet _toQuizSet(
    String setName,
    List<McqQuestion> mcqQuestions,
  ) {
    final ordered = [...mcqQuestions]
      ..sort(
        (a, b) => a.createdAt.compareTo(b.createdAt),
      );

    final color = _adminSetPalette[
      setName.hashCode.abs() % _adminSetPalette.length
    ];

    return QuizSet(
      id: 'admin_$setName',
      title: setName,
      icon: Icons.quiz_outlined,
      color: color,
      questions: ordered
          .map(_toQuizQuestion)
          .toList(),
    );
  }

  // ─────────────────────────────────────────────
  // CONVERT ADMIN QUESTION → QUIZ QUESTION
  // ─────────────────────────────────────────────

  QuizQuestion _toQuizQuestion(McqQuestion q) {
    return QuizQuestion(
      question: q.question.trim().isEmpty
          ? null
          : q.question,
      options: q.options,
      correctIndex: q.correctOptionIndex,
      imageAsset: q.questionImagePath,
      optionImages: q.optionImagePaths,
      audioAsset: q.audioFilePath,
      optionAudios: q.optionAudioPaths,
    );
  }

  // ─────────────────────────────────────────────
  // SCORE
  // ─────────────────────────────────────────────

  void recordScore(
    String setId,
    int score,
  ) {
    final best = bestScores[setId];

    if (best == null || score > best) {
      bestScores[setId] = score;
    }
  }

  int? bestScoreFor(String setId) {
    return bestScores[setId];
  }

  // ─────────────────────────────────────────────
  // FIRST SET
  // ─────────────────────────────────────────────

  QuizSet? get firstSet {
    final sets = allSets;

    if (sets.isEmpty) {
      return null;
    }

    return sets.first;
  }

  // ─────────────────────────────────────────────
  // CLEANUP
  // ─────────────────────────────────────────────

  @override
  void onClose() {
    _accessPollingTimer?.cancel();
    _accessPollingTimer = null;

    searchController.dispose();

    super.onClose();
  }
}