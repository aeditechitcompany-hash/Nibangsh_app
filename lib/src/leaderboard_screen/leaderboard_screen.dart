import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/api_models/leaderboard_model.dart';
import '../../common/util/app_colors.dart';
import 'controller/leaderboard_controller.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
    Get.isRegistered<LeaderboardController>()
        ? Get.find<LeaderboardController>()
        : Get.put(LeaderboardController());

    return Scaffold(
      backgroundColor: AppColors.background,

      // ==============================================================
      // APP BAR
      // ==============================================================

      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
      ),

      // ==============================================================
      // BODY
      // ==============================================================

      body: Obx(() {
        // ============================================================
        // LOADING
        // ============================================================

        if (controller.isLoading.value &&
            controller.leaderboard.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // ============================================================
        // ERROR
        // ============================================================

        if (controller.errorMessage.value.isNotEmpty &&
            controller.leaderboard.isEmpty) {
          return _buildError(
            controller,
            controller.errorMessage.value,
          );
        }

        // ============================================================
        // EMPTY
        // ============================================================

        if (controller.leaderboard.isEmpty) {
          return _buildEmpty();
        }

        // ============================================================
        // DATA
        // ============================================================

        final leaderboard =
            controller.leaderboard;

        return SafeArea(
          child: RefreshIndicator(
            onRefresh:
            controller.fetchLeaderboard,
            child: SingleChildScrollView(
              physics:
              const AlwaysScrollableScrollPhysics(),
              padding:
              const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                30,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // HEADER
                  // ==================================================

                  Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 22,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkBlue,
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons
                              .emoji_events_rounded,
                          color: Colors.amber,
                          size: 52,
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        const Text(
                          'Leaderboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        Text(
                          'See who has solved the most questions',
                          textAlign:
                          TextAlign.center,
                          style: TextStyle(
                            color: Colors.white
                                .withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ==================================================
                  // TOP PERFORMERS
                  // ==================================================

                  if (leaderboard.length >= 3) ...[
                    const Text(
                      'Top Performers',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: [
                        // ============================================
                        // SECOND
                        // ============================================

                        Expanded(
                          child: _buildTopUser(
                            entry:
                            leaderboard[1],
                            height: 150,
                          ),
                        ),

                        // ============================================
                        // FIRST
                        // ============================================

                        Expanded(
                          child: _buildTopUser(
                            entry:
                            leaderboard[0],
                            height: 175,
                            isFirst: true,
                          ),
                        ),

                        // ============================================
                        // THIRD
                        // ============================================

                        Expanded(
                          child: _buildTopUser(
                            entry:
                            leaderboard[2],
                            height: 150,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 28,
                    ),
                  ],

                  // ==================================================
                  // ALL RANKINGS
                  // ==================================================

                  const Text(
                    'All Rankings',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  ...leaderboard.map(
                        (entry) =>
                        _buildLeaderboardTile(
                          entry: entry,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // ==================================================================
  // TOP USER
  // ==================================================================

  Widget _buildTopUser({
    required LeaderboardEntry entry,
    required double height,
    bool isFirst = false,
  }) {
    return Container(
      constraints: BoxConstraints(
        minHeight: height,
      ),
      margin:
      const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      padding:
      const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: isFirst
              ? Colors.amber
              : Colors.grey.shade200,
          width: isFirst ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color:
            Colors.black.withOpacity(0.06),
            offset:
            const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          // ==========================================================
          // TROPHY
          // ==========================================================

          Icon(
            Icons.emoji_events,
            size:
            isFirst ? 36 : 28,
            color:
            _getRankColor(entry.rank),
          ),

          const SizedBox(
            height: 5,
          ),

          // ==========================================================
          // RANK
          // ==========================================================

          Text(
            '#${entry.rank}',
            style: const TextStyle(
              fontWeight:
              FontWeight.bold,
              fontSize: 13,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          // ==========================================================
          // NAME
          // ==========================================================

          SizedBox(
            height: 30,
            child: Text(
              entry.name,
              maxLines: 2,
              overflow:
              TextOverflow.ellipsis,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontWeight:
                FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          // ==========================================================
          // QUESTIONS SOLVED
          // ==========================================================

          Text(
            '${entry.questionsSolved}',
            style: TextStyle(
              color:
              AppColors.darkBlue,
              fontWeight:
              FontWeight.bold,
              fontSize: 14,
            ),
          ),

          Text(
            'questions',
            style: TextStyle(
              color:
              Colors.grey.shade600,
              fontSize: 9,
            ),
          ),

          const SizedBox(
            height: 3,
          ),

          // ==========================================================
          // SCORE
          // ==========================================================

          Text(
            '${entry.score.toStringAsFixed(0)}%',
            style: TextStyle(
              color:
              AppColors.darkBlue,
              fontWeight:
              FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================================
  // LEADERBOARD TILE
  // ==================================================================

  Widget _buildLeaderboardTile({
    required LeaderboardEntry entry,
  }) {
    final initials =
    _getInitials(entry.name);

    return Container(
      width: double.infinity,
      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // ==========================================================
          // RANK
          // ==========================================================

          SizedBox(
            width: 28,
            child: Text(
              '${entry.rank}',
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontWeight:
                FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          // ==========================================================
          // AVATAR
          // ==========================================================

          CircleAvatar(
            radius: 21,
            backgroundColor:
            AppColors.primaryBlue
                .withOpacity(0.12),
            child: Text(
              initials,
              style: TextStyle(
                color:
                AppColors.darkBlue,
                fontWeight:
                FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(
            width: 11,
          ),

          // ==========================================================
          // NAME + STATS
          // ==========================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.w600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  '${entry.questionsSolved} questions solved',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                    Colors.grey.shade600,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  '${entry.completedQuizzes} quizzes completed',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                    Colors.grey.shade500,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          // ==========================================================
          // SCORE
          // ==========================================================

          Text(
            '${entry.score.toStringAsFixed(0)}%',
            style: TextStyle(
              color:
              AppColors.darkBlue,
              fontWeight:
              FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================================
  // ERROR
  // ==================================================================

  Widget _buildError(
      LeaderboardController controller,
      String message,
      ) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.redAccent,
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              message,
              textAlign:
              TextAlign.center,
            ),

            const SizedBox(
              height: 16,
            ),

            ElevatedButton(
              onPressed:
              controller
                  .fetchLeaderboard,
              child:
              const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================================
  // EMPTY
  // ==================================================================

  Widget _buildEmpty() {
    return const Center(
      child: Padding(
        padding:
        EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons
                  .emoji_events_outlined,
              size: 60,
              color: Colors.grey,
            ),

            SizedBox(
              height: 16,
            ),

            Text(
              'No leaderboard data yet.',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w600,
              ),
            ),

            SizedBox(
              height: 8,
            ),

            Text(
              'Complete an MCQ to appear on the leaderboard.',
              textAlign:
              TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================================
  // RANK COLOR
  // ==================================================================

  Color _getRankColor(
      int rank,
      ) {
    switch (rank) {
      case 1:
        return Colors.amber;

      case 2:
        return Colors.grey;

      case 3:
        return Colors.brown;

      default:
        return AppColors.darkBlue;
    }
  }

  // ==================================================================
  // INITIALS
  // ==================================================================

  String _getInitials(
      String name,
      ) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where(
          (e) => e.isNotEmpty,
    )
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      final value =
          parts.first;

      return value
          .substring(
        0,
        value.length >= 2
            ? 2
            : 1,
      )
          .toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'
        .toUpperCase();
  }
}