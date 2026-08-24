import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

const double _kWideLayoutBreakpoint = 700;

class McqResultScreen extends StatelessWidget {
  const McqResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;

    final QuizSet quizSet =
        args['quizSet'] as QuizSet;

    // Keep the earned score from Django, but calculate the denominator from
    // the complete quiz so unanswered questions are included.
    final int score =
      int.tryParse(args['score']?.toString() ?? '') ?? 0;

    final int maxScore = quizSet.totalQuestions;

    final double percentage = maxScore > 0
      ? (score / maxScore) * 100
      : 0;

    final bool passed =
        args['passed'] ?? false;

    final screenWidth =
        MediaQuery.of(context).size.width;

    final isWideLayout =
        screenWidth >= _kWideLayoutBreakpoint;

    return Scaffold(
      backgroundColor:
          isWideLayout
              ? AppColors.background
              : AppColors.white,

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

  // NARROW / MOBILE
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

  // WIDE LAYOUT (TABLET / DESKTOP)
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
                      vertical: 40,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(0.05),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
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

                        const SizedBox(height: 32),

                        _resultHeading(
                          passed: passed,
                          headingFontSize: 27,
                          subFontSize: 15.5,
                        ),

                        const SizedBox(height: 32),

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

  // SCORE CIRCLE

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
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,

        gradient: LinearGradient(
          colors: [
            Color.lerp(
              AppColors.primaryBlue,
              Colors.black,
              0.5,
            )!,
            AppColors.primaryBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue
                .withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Your Score',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            '$score/$total',
            style: TextStyle(
              color: Colors.white,
              fontSize: scoreFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // RESULT HEADING
  Widget _resultHeading({
    required bool passed,
    required double headingFontSize,
    required double subFontSize,
  }) {
    return Column(
      children: [
        Text(
          passed
              ? 'Congratulations'
              : 'Keep Practicing',

          style: TextStyle(
            color: AppColors.primaryBlue,
            fontSize: headingFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          passed
              ? 'Great job! You did it.'
              : 'Review the topic and try this set again.',

          textAlign: TextAlign.center,

          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: subFontSize,
          ),
        ),
      ],
    );
  }

  // BUTTONS
  Widget _actionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,

          child: OutlinedButton.icon(
            onPressed: () => Get.snackbar(
              'Share',
              'Sharing your result isn\'t wired up yet.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor:
                  AppColors.primaryBlue,
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
                borderRadius:
                    BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 50,

          child: ElevatedButton(
            onPressed: () => Get.until(
              (route) =>
                  route.settings.name ==
                  AppRoute.home,
            ),

            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primaryBlue,
              foregroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(14),
              ),

              elevation: 0,
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