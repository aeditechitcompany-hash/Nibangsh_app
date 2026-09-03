import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../../../common/util/responsive.dart';

const double _kWideLayoutBreakpoint = 700;

class McqResultScreen extends StatelessWidget {
  const McqResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;

    final QuizSet quizSet = args['quizSet'] as QuizSet;

    final int score =
        int.tryParse(args['score']?.toString() ?? '') ?? 0;

    final int maxScore = quizSet.totalQuestions;

    final double percentage =
    maxScore > 0 ? (score / maxScore) * 100 : 0;

    final bool passed = args['passed'] ?? false;

    final screenWidth = MediaQuery.of(context).size.width;
    final isWideLayout = screenWidth >= _kWideLayoutBreakpoint;

    return Scaffold(
      backgroundColor:
      isWideLayout ? AppColors.background : AppColors.white,
      body: isWideLayout
          ? _buildWideLayout(
        score: score,
        maxScore: maxScore,
        percentage: percentage,
        passed: passed,
      )
          : _buildNarrowLayout(
        score: score,
        maxScore: maxScore,
        percentage: percentage,
        passed: passed,
      ),
    );
  }

  // ============================================================
  // NARROW / MOBILE
  // ============================================================

  Widget _buildNarrowLayout({
    required int score,
    required int maxScore,
    required double percentage,
    required bool passed,
  }) {
    return ResponsiveWrapper(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),

                        _scoreCircle(
                          score: score,
                          total: maxScore,
                          percentage: percentage,
                          size: 220,
                          scoreFontSize: 39,
                        ),

                        const SizedBox(height: 36),

                        _resultHeading(
                          passed: passed,
                          headingFontSize: 27.5,
                          subFontSize: 15.5,
                        ),

                        const Spacer(),

                        _actionButtons(),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // WIDE / TABLET / DESKTOP
  // ============================================================

  Widget _buildWideLayout({
    required int score,
    required int maxScore,
    required double percentage,
    required bool passed,
  }) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 480,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 24,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 36,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.borderGrey,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _scoreCircle(
                          score: score,
                          total: maxScore,
                          percentage: percentage,
                          size: 220,
                          scoreFontSize: 39,
                        ),

                        const SizedBox(height: 36),

                        _resultHeading(
                          passed: passed,
                          headingFontSize: 27.5,
                          subFontSize: 15.5,
                        ),

                        const SizedBox(height: 36),

                        _actionButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // SCORE CIRCLE
  // ============================================================

  Widget _scoreCircle({
    required int score,
    required int total,
    required double percentage,
    required double size,
    required double scoreFontSize,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: AppColors.primaryBlue,
          width: 8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$score / $total',
            style: TextStyle(
              fontSize: scoreFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RESULT HEADING
  // ============================================================

  Widget _resultHeading({
    required bool passed,
    required double headingFontSize,
    required double subFontSize,
  }) {
    return Column(
      children: [
        Text(
          passed ? 'Congratulations!' : 'Keep Practicing!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: headingFontSize,
            fontWeight: FontWeight.bold,
            color: passed
                ? const Color(0xFF16A34A)
                : const Color(0xFFDC2626),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          passed
              ? 'You passed the quiz.'
              : 'You did not reach the passing score.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: subFontSize,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BUTTONS
  // ============================================================

  Widget _actionButtons() {
    return Column(
      children: [
        // --------------------------------------------------------
        // REVIEW QUESTIONS
        // --------------------------------------------------------

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              final args = Get.arguments as Map;

              Get.toNamed(
                AppRoute.mcqReview,
                arguments: {
                  'quizSet': args['quizSet'],
                  'selectedAnswers': args['selectedAnswers'],
                  'correctAnswers': args['correctAnswers'],
                },
              );
            },
            icon: const Icon(
              Icons.fact_check_outlined,
              size: 19,
            ),
            label: const Text(
              'Review Questions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // --------------------------------------------------------
        // SHARE
        // --------------------------------------------------------

        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => Get.snackbar(
              'Share',
              'Sharing your result isn\'t wired up yet.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.primaryBlue,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            ),
            icon: const Icon(
              Icons.share_outlined,
              size: 18,
              color: AppColors.primaryBlue,
            ),
            label: const Text(
              'Share',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: AppColors.primaryBlue,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // --------------------------------------------------------
        // BACK TO HOME
        // --------------------------------------------------------

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Get.until(
                    (route) =>
                route.settings.name == AppRoute.home,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Back to Home',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}