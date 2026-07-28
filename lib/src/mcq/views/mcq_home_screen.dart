import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../controller/mcq_home_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class McqHomeScreen extends StatelessWidget {
  const McqHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(McqHomeController());

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          ResponsiveWrapper(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBanner(controller),
                  const SizedBox(height: 20),
                  _buildSearchBar(controller),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'List of Sets',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildSetList(controller),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDark, AppColors.navyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                'Quizzes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Test what you\'ve learned',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ── "Test Your Knowledge" banner ──
  Widget _buildBanner(McqHomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.navyLight, AppColors.darkBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: Icon(
                Icons.emoji_events_rounded,
                color: Colors.white.withOpacity(0.15),
                size: 90,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Test Your Knowledge\nwith Quizzes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Quick multiple-choice sets to check how much you remember.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.toNamed(
                    AppRoute.mcqInstructions,
                    arguments: controller.firstSet,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryRed,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Play Now',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navyLight),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Search bar ──
  Widget _buildSearchBar(McqHomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller.searchController,
          decoration: InputDecoration(
            hintText: 'Search sets...',
            hintStyle: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 13.5,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.primaryBlue,
              size: 21,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // ── Set list ──
  Widget _buildSetList(McqHomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final sets = controller.filteredSets;
        if (sets.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'No sets match your search',
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
          );
        }
        return Column(
          children: sets.map((s) => _setTile(controller, s)).toList(),
        );
      }),
    );
  }

  Widget _setTile(McqHomeController controller, QuizSet set) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoute.mcqInstructions, arguments: set),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: set.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(set.icon, color: set.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    set.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${set.totalQuestions} Question',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              final best = controller.bestScoreFor(set.id);
              return _scoreRing(best, set.totalQuestions, set.color);
            }),
          ],
        ),
      ),
    );
  }

  Widget _scoreRing(int? score, int total, Color color) {
    final attempted = score != null;
    final fraction = attempted ? score / total : 0.0;
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              value: attempted ? fraction : 1,
              strokeWidth: 4,
              backgroundColor: AppColors.borderGrey,
              valueColor: AlwaysStoppedAnimation(
                attempted ? color : AppColors.borderGrey,
              ),
            ),
          ),
          attempted
              ? Text(
            '$score/$total',
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          )
              : Icon(Icons.play_arrow_rounded, color: color, size: 22),
        ],
      ),
    );
  }
}