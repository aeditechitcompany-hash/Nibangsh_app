import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../common/api_models/leaderboard_model.dart';
import '../services/leaderboard_service.dart';

class LeaderboardController extends GetxController {
  final LeaderboardService _service =
  LeaderboardService();

  final RxList<LeaderboardEntry> leaderboard =
      <LeaderboardEntry>[].obs;

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data =
      await _service.getLeaderboard();

      leaderboard.assignAll(data);

      debugPrint(
        'LEADERBOARD ENTRIES: ${leaderboard.length}',
      );
    } catch (e, stackTrace) {
      debugPrint(
        'LEADERBOARD ERROR: $e',
      );

      debugPrint(
        'LEADERBOARD STACK TRACE:\n$stackTrace',
      );

      errorMessage.value =
      'Failed to load leaderboard.';
    } finally {
      isLoading.value = false;
    }
  }
}