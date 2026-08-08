import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/models/quiz_models.dart';
import '../../../common/models/mcq_model.dart';
import '../../../common/services/mcq_repository.dart';
import '../../../common/util/app_colors.dart';

class McqHomeController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  final bestScores = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });
  }

  // ── Merge static (bundled) sets with live admin-created sets ──

  // Admin questions are grouped by setName into QuizSets so the existing
  // quiz-taking screen (which only knows about QuizSet/QuizQuestion) can
  // render them without any changes to its data model.
  List<QuizSet> get allSets {
    final grouped = <String, List<McqQuestion>>{};
    for (final q in McqRepository.to.questions) {
      final setName = (q.setName ?? '').trim();
      if (setName.isEmpty) continue;
      grouped.putIfAbsent(setName, () => []).add(q);
    }

    final adminSets = grouped.entries
        .map((e) => _toQuizSet(e.key, e.value))
        .toList();

    return [...QuizCatalog.sets, ...adminSets];
  }

  List<QuizSet> get filteredSets {
    final sets = allSets;
    if (searchQuery.value.isEmpty) return sets;
    final q = searchQuery.value.toLowerCase();
    return sets.where((s) => s.title.toLowerCase().contains(q)).toList();
  }

  static const List<Color> _adminSetPalette = [
    AppColors.primaryBlue,
    Color(0xFF16A34A),
    Color(0xFF9333EA),
    Color(0xFFF59E0B),
    Color(0xFFDC2626),
  ];

  QuizSet _toQuizSet(String setName, List<McqQuestion> mcqQuestions) {
    final ordered = [...mcqQuestions]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final color = _adminSetPalette[setName.hashCode.abs() % _adminSetPalette.length];
    return QuizSet(
      id: 'admin_$setName',
      title: setName,
      icon: Icons.quiz_outlined,
      color: color,
      questions: ordered.map(_toQuizQuestion).toList(),
    );
  }

  QuizQuestion _toQuizQuestion(McqQuestion q) {
    return QuizQuestion(
      question: q.question.trim().isEmpty ? null : q.question,
      options: q.options,
      correctIndex: q.correctOptionIndex,
      imageAsset: q.questionImagePath,
      optionImages: q.optionImagePaths,
      audioAsset: q.audioFilePath,
      optionAudios: q.optionAudioPaths,
    );
  }

  // Called by the quiz screen when a set is completed.
  void recordScore(String setId, int score) {
    final best = bestScores[setId];
    if (best == null || score > best) {
      bestScores[setId] = score;
    }
  }

  int? bestScoreFor(String setId) => bestScores[setId];

  QuizSet get firstSet => allSets.first;
}