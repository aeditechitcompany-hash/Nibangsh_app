import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_route.dart';
import '../../../common/util/responsive.dart';

const double _kWideLayoutBreakpoint = 700;

class McqResultScreen extends StatelessWidget {
  const McqResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rawArguments = Get.arguments;

    if (rawArguments is! Map) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Invalid quiz result data.',
          ),
        ),
      );
    }

    final Map args = rawArguments;

    final QuizSet? quizSet =
    args['quizSet'] is QuizSet
        ? args['quizSet'] as QuizSet
        : null;

    if (quizSet == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Quiz data not found.',
          ),
        ),
      );
    }

    final int score =
    _toInt(args['score']);

    final int total =
    _toInt(
      args['totalQuestions'],
      fallback:
      quizSet.totalQuestions,
    );

    final int attemptedRaw =
    _toInt(
      args['answeredCount'],
    );

    final int safeTotal =
    total < 0 ? 0 : total;

    final int attempted =
    attemptedRaw
        .clamp(0, safeTotal)
        .toInt();

    final int safeScore =
    score
        .clamp(0, attempted)
        .toInt();

    final int incorrect =
    (attempted - safeScore)
        .clamp(0, attempted)
        .toInt();

    final int skipped =
    (safeTotal - attempted)
        .clamp(0, safeTotal)
        .toInt();

    final double percentage =
    safeTotal > 0
        ? (safeScore /
        safeTotal) *
        100
        : 0;

    final double attemptPercentage =
    safeTotal > 0
        ? attempted /
        safeTotal
        : 0;

    final bool passed =
        args['passed'] == true;

    final screenWidth =
        MediaQuery.of(context)
            .size
            .width;

    final isWide =
        screenWidth >=
            _kWideLayoutBreakpoint;

    return Scaffold(
      backgroundColor:
      const Color(0xFFF4F8FF),
      body: SafeArea(
        child: isWide
            ? _buildWide(
          context,
          quizSet,
          safeScore,
          safeTotal,
          attempted,
          incorrect,
          skipped,
          percentage,
          attemptPercentage,
          passed,
          args,
        )
            : _buildMobile(
          context,
          quizSet,
          safeScore,
          safeTotal,
          attempted,
          incorrect,
          skipped,
          percentage,
          attemptPercentage,
          passed,
          args,
        ),
      ),
    );
  }

  int _toInt(
      dynamic value, {
        int fallback = 0,
      }) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        fallback;
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobile(
      BuildContext context,
      QuizSet quizSet,
      int score,
      int total,
      int attempted,
      int incorrect,
      int skipped,
      double percentage,
      double attemptPercentage,
      bool passed,
      Map args,
      ) {
    return ResponsiveWrapper(
      child: SingleChildScrollView(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          children: [
            _header(quizSet),

            const SizedBox(
                height: 18),

            _scoreCard(
              score: score,
              total: total,
              percentage:
              percentage,
              passed: passed,
            ),

            const SizedBox(
                height: 16),

            _stats(
              score: score,
              incorrect:
              incorrect,
              attempted:
              attempted,
              skipped:
              skipped,
            ),

            const SizedBox(
                height: 16),

            _attemptedCard(
              attempted:
              attempted,
              total: total,
              progress:
              attemptPercentage,
            ),

            const SizedBox(
                height: 16),

            _performanceCard(
              percentage:
              percentage,
            ),

            const SizedBox(
                height: 22),

            _buttons(args),

            const SizedBox(
                height: 10),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _buildWide(
      BuildContext context,
      QuizSet quizSet,
      int score,
      int total,
      int attempted,
      int incorrect,
      int skipped,
      double percentage,
      double attemptPercentage,
      bool passed,
      Map args,
      ) {
    return SingleChildScrollView(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
          const BoxConstraints(
            maxWidth: 800,
          ),
          child: Column(
            children: [
              _header(quizSet),

              const SizedBox(
                  height: 18),

              _scoreCard(
                score: score,
                total: total,
                percentage:
                percentage,
                passed: passed,
              ),

              const SizedBox(
                  height: 18),

              _stats(
                score: score,
                incorrect:
                incorrect,
                attempted:
                attempted,
                skipped:
                skipped,
              ),

              const SizedBox(
                  height: 18),

              Row(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Expanded(
                    child:
                    _attemptedCard(
                      attempted:
                      attempted,
                      total: total,
                      progress:
                      attemptPercentage,
                    ),
                  ),
                  const SizedBox(
                      width: 16),
                  Expanded(
                    child:
                    _performanceCard(
                      percentage:
                      percentage,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                  height: 22),

              _buttons(args),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header(
      QuizSet quizSet,
      ) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient:
        const LinearGradient(
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1976D2),
            Color(0xFF42A5F5),
          ],
          begin:
          Alignment.topLeft,
          end:
          Alignment.bottomRight,
        ),
        borderRadius:
        BorderRadius.circular(
          22,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF1976D2,
            ).withOpacity(0.20),
            blurRadius: 18,
            offset:
            const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration:
            BoxDecoration(
              color: Colors.white
                  .withOpacity(
                0.16,
              ),
              borderRadius:
              BorderRadius.circular(
                16,
              ),
            ),
            child:
            const Icon(
              Icons
                  .emoji_events_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                const Text(
                  'Quiz Completed',
                  style:
                  TextStyle(
                    color:
                    Colors.white,
                    fontSize: 22,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
                const SizedBox(
                    height: 4),
                Text(
                  quizSet.title,
                  maxLines: 2,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  TextStyle(
                    color: Colors.white
                        .withOpacity(
                      0.85,
                    ),
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SCORE
  // ============================================================

  Widget _scoreCard({
    required int score,
    required int total,
    required double percentage,
    required bool passed,
  }) {
    final double progress =
    total > 0
        ? (score / total)
        .clamp(0.0, 1.0)
        : 0;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(
          24,
        ),
        border: Border.all(
          color:
          const Color(0xFFD9E8FF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue
                .withOpacity(0.07),
            blurRadius: 18,
            offset:
            const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 190,
            height: 190,
            child: Stack(
              alignment:
              Alignment.center,
              children: [
                SizedBox(
                  width: 190,
                  height: 190,
                  child:
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 13,
                    backgroundColor:
                    const Color(
                      0xFFE3EEFF,
                    ),
                    valueColor:
                    const AlwaysStoppedAnimation<
                        Color>(
                      Color(0xFF1976D2),
                    ),
                  ),
                ),
                Container(
                  width: 158,
                  height: 158,
                  decoration:
                  const BoxDecoration(
                    shape:
                    BoxShape.circle,
                    color: Color(
                      0xFFF4F8FF,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                    children: [
                      Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style:
                        const TextStyle(
                          fontSize: 38,
                          fontWeight:
                          FontWeight.w900,
                          color: Color(
                            0xFF0D47A1,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 3),
                      Text(
                        '$score / $total',
                        style:
                        const TextStyle(
                          fontSize: 17,
                          fontWeight:
                          FontWeight.w700,
                          color: Color(
                            0xFF607D9B,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
              height: 20),

          Text(
            passed
                ? 'Excellent Work!'
                : 'Keep Practicing!',
            textAlign:
            TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight:
              FontWeight.w800,
              color:
              Color(0xFF1565C0),
            ),
          ),

          const SizedBox(
              height: 6),

          Text(
            passed
                ? 'You have successfully completed the quiz.'
                : 'Review the questions and try again.',
            textAlign:
            TextAlign.center,
            style:
            const TextStyle(
              fontSize: 14.5,
              color:
              Color(0xFF607D9B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATS
  // ============================================================

  Widget _stats({
    required int score,
    required int incorrect,
    required int attempted,
    required int skipped,
  }) {
    return Row(
      children: [
        Expanded(
          child: _stat(
            Icons.check_circle_rounded,
            'Correct',
            '$score',
          ),
        ),
        const SizedBox(
            width: 10),
        Expanded(
          child: _stat(
            Icons.cancel_rounded,
            'Incorrect',
            '$incorrect',
          ),
        ),
        const SizedBox(
            width: 10),
        Expanded(
          child: _stat(
            Icons.edit_note_rounded,
            'Attempted',
            '$attempted',
          ),
        ),
        const SizedBox(
            width: 10),
        Expanded(
          child: _stat(
            Icons.remove_circle_outline,
            'Skipped',
            '$skipped',
          ),
        ),
      ],
    );
  }

  Widget _stat(
      IconData icon,
      String title,
      String value,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 5,
      ),
      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color:
          const Color(0xFFD9E8FF),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color:
            const Color(0xFF1976D2),
            size: 25,
          ),
          const SizedBox(
              height: 7),
          Text(
            value,
            style:
            const TextStyle(
              fontSize: 21,
              fontWeight:
              FontWeight.w900,
              color:
              Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(
              height: 3),
          Text(
            title,
            textAlign:
            TextAlign.center,
            style:
            const TextStyle(
              fontSize: 11.5,
              fontWeight:
              FontWeight.w600,
              color:
              Color(0xFF607D9B),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ATTEMPTED
  // ============================================================

  Widget _attemptedCard({
    required int attempted,
    required int total,
    required double progress,
  }) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(20),
      decoration:
      BoxDecoration(
        color:
        const Color(0xFFEAF3FF),
        borderRadius:
        BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color:
          const Color(0xFFC7DFFF),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment
            .start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration:
                const BoxDecoration(
                  color:
                  Color(0xFF1976D2),
                  shape:
                  BoxShape.circle,
                ),
                child:
                const Icon(
                  Icons
                      .edit_note_rounded,
                  color:
                  Colors.white,
                  size: 23,
                ),
              ),
              const SizedBox(
                  width: 12),
              const Expanded(
                child: Text(
                  'Questions Attempted',
                  style:
                  TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w800,
                    color:
                    Color(0xFF0D47A1),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
              height: 18),

          Row(
            crossAxisAlignment:
            CrossAxisAlignment
                .end,
            children: [
              Text(
                '$attempted',
                style:
                const TextStyle(
                  fontSize: 34,
                  fontWeight:
                  FontWeight.w900,
                  color:
                  Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(
                  width: 5),
              Padding(
                padding:
                const EdgeInsets.only(
                  bottom: 6,
                ),
                child: Text(
                  '/ $total',
                  style:
                  const TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    Color(0xFF607D9B),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
              height: 10),

          ClipRRect(
            borderRadius:
            BorderRadius.circular(
              20,
            ),
            child:
            LinearProgressIndicator(
              value: progress
                  .clamp(0.0, 1.0),
              minHeight: 9,
              backgroundColor:
              const Color(
                0xFFD4E5FA,
              ),
              valueColor:
              const AlwaysStoppedAnimation<
                  Color>(
                Color(0xFF1976D2),
              ),
            ),
          ),

          const SizedBox(
              height: 8),

          Text(
            '$attempted of $total questions attempted',
            style:
            const TextStyle(
              fontSize: 12.5,
              color:
              Color(0xFF607D9B),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PERFORMANCE
  // ============================================================

  Widget _performanceCard({
    required double percentage,
  }) {
    String performance;

    if (percentage >= 90) {
      performance = 'Outstanding';
    } else if (percentage >= 75) {
      performance = 'Excellent';
    } else if (percentage >= 60) {
      performance = 'Good';
    } else if (percentage >= 40) {
      performance =
      'Needs Improvement';
    } else {
      performance =
      'Keep Practicing';
    }

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(20),
      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color:
          const Color(0xFFD9E8FF),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment
            .start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.insights_rounded,
                color:
                Color(0xFF1976D2),
                size: 26,
              ),
              const SizedBox(
                  width: 10),
              const Text(
                'Performance',
                style:
                TextStyle(
                  fontSize: 15,
                  fontWeight:
                  FontWeight.w800,
                  color:
                  Color(0xFF0D47A1),
                ),
              ),
            ],
          ),

          const SizedBox(
              height: 18),

          Text(
            performance,
            style:
            const TextStyle(
              fontSize: 21,
              fontWeight:
              FontWeight.w800,
              color:
              Color(0xFF1976D2),
            ),
          ),

          const SizedBox(
              height: 10),

          ClipRRect(
            borderRadius:
            BorderRadius.circular(
              20,
            ),
            child:
            LinearProgressIndicator(
              value:
              (percentage / 100)
                  .clamp(0.0, 1.0),
              minHeight: 9,
              backgroundColor:
              const Color(
                0xFFE3EEFF,
              ),
              valueColor:
              const AlwaysStoppedAnimation<
                  Color>(
                Color(0xFF1976D2),
              ),
            ),
          ),

          const SizedBox(
              height: 8),

          Text(
            '${percentage.toStringAsFixed(0)}% overall score',
            style:
            const TextStyle(
              fontSize: 12.5,
              color:
              Color(0xFF607D9B),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUTTONS
  // ============================================================

  Widget _buttons(
      Map args,
      ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child:
          ElevatedButton.icon(
            onPressed: () {
              Get.toNamed(
                AppRoute.mcqReview,
                arguments: {
                  'quizSet':
                  args['quizSet'],
                  'selectedAnswers':
                  args[
                  'selectedAnswers'],
                  'correctAnswers':
                  args[
                  'correctAnswers'],
                },
              );
            },
            icon:
            const Icon(
              Icons
                  .fact_check_outlined,
              size: 20,
            ),
            label:
            const Text(
              'Review Questions',
              style:
              TextStyle(
                fontSize: 15.5,
                fontWeight:
                FontWeight.w800,
              ),
            ),
            style:
            ElevatedButton.styleFrom(
              backgroundColor:
              const Color(
                0xFF1976D2,
              ),
              foregroundColor:
              Colors.white,
              elevation: 0,
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                  15,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(
            height: 12),

        SizedBox(
          width: double.infinity,
          height: 54,
          child:
          OutlinedButton.icon(
            onPressed: () {
              Get.snackbar(
                'Share',
                'Sharing your result isn\'t wired up yet.',
                snackPosition:
                SnackPosition
                    .BOTTOM,
                backgroundColor:
                const Color(
                  0xFF1976D2,
                ),
                colorText:
                Colors.white,
                margin:
                const EdgeInsets.all(
                  16,
                ),
                borderRadius: 12,
              );
            },
            icon:
            const Icon(
              Icons.share_outlined,
              color:
              Color(0xFF1976D2),
            ),
            label:
            const Text(
              'Share Result',
              style:
              TextStyle(
                color:
                Color(0xFF1976D2),
                fontSize: 15,
                fontWeight:
                FontWeight.w700,
              ),
            ),
            style:
            OutlinedButton.styleFrom(
              side:
              const BorderSide(
                color:
                Color(0xFF1976D2),
              ),
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                  15,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(
            height: 12),

        SizedBox(
          width: double.infinity,
          height: 54,
          child:
          TextButton.icon(
            onPressed: () {
              Get.until(
                    (route) =>
                route.settings
                    .name ==
                    AppRoute.home,
              );
            },
            icon:
            const Icon(
              Icons.home_outlined,
              color:
              Color(0xFF607D9B),
            ),
            label:
            const Text(
              'Back to Home',
              style:
              TextStyle(
                color:
                Color(0xFF607D9B),
                fontSize: 15,
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}