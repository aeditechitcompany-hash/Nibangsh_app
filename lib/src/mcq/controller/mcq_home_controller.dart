import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/models/quiz_models.dart';

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

  List<QuizSet> get filteredSets {
    if (searchQuery.value.isEmpty) return QuizCatalog.sets;
    final q = searchQuery.value.toLowerCase();
    return QuizCatalog.sets.where((s) => s.title.toLowerCase().contains(q)).toList();
  }

  // Called by the quiz screen when a set is completed.
  void recordScore(String setId, int score) {
    final best = bestScores[setId];
    if (best == null || score > best) {
      bestScores[setId] = score;
    }
  }

  int? bestScoreFor(String setId) => bestScores[setId];

  QuizSet get firstSet => QuizCatalog.sets.first;
}