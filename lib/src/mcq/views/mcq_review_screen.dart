import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_colors.dart';

class McqReviewScreen extends StatelessWidget {
  const McqReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;

    final QuizSet quizSet = args['quizSet'] as QuizSet;

    final List<int?> selectedAnswers =
    _parseSelectedAnswers(args['selectedAnswers']);

    final List<int> correctAnswers =
    _parseCorrectAnswers(args['correctAnswers']);

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Review Questions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: quizSet.questions.length,
          itemBuilder: (context, questionIndex) {
            final QuizQuestion question =
            quizSet.questions[questionIndex];

            final int? selectedIndex =
            questionIndex < selectedAnswers.length
                ? selectedAnswers[questionIndex]
                : null;

            final int correctIndex =
            questionIndex < correctAnswers.length
                ? correctAnswers[questionIndex]
                : -1;

            return _buildQuestionCard(
              context: context,
              questionNumber: questionIndex + 1,
              question: question,
              selectedIndex: selectedIndex,
              correctIndex: correctIndex,
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // PARSE SELECTED ANSWERS
  // ============================================================

  List<int?> _parseSelectedAnswers(dynamic value) {
    if (value == null) {
      return <int?>[];
    }

    if (value is List) {
      return value.map<int?>((item) {
        if (item == null) {
          return null;
        }

        if (item is int) {
          return item;
        }

        return int.tryParse(item.toString());
      }).toList();
    }

    return <int?>[];
  }

  // ============================================================
  // PARSE CORRECT ANSWERS
  // ============================================================

  List<int> _parseCorrectAnswers(dynamic value) {
    if (value == null) {
      return <int>[];
    }

    if (value is List) {
      return value.map<int>((item) {
        if (item is int) {
          return item;
        }

        return int.tryParse(item.toString()) ?? -1;
      }).toList();
    }

    return <int>[];
  }

  // ============================================================
  // QUESTION CARD
  // ============================================================

  Widget _buildQuestionCard({
    required BuildContext context,
    required int questionNumber,
    required QuizQuestion question,
    required int? selectedIndex,
    required int correctIndex,
  }) {
    final bool isAnswered = selectedIndex != null;

    final bool answeredCorrectly =
        isAnswered &&
            correctIndex >= 0 &&
            selectedIndex == correctIndex;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderGrey,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ======================================================
          // QUESTION HEADER
          // ======================================================

          Row(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),

                decoration: BoxDecoration(
                  color: AppColors.primaryBlue
                      .withOpacity(0.1),
                  borderRadius:
                  BorderRadius.circular(10),
                ),

                child: Text(
                  'Question $questionNumber',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),

              const Spacer(),

              if (!isAnswered)
                _statusBadge(
                  text: 'Not answered',
                  background:
                  const Color(0xFFFFF7ED),
                  foreground:
                  const Color(0xFFB45309),
                  icon: Icons.info_outline,
                )
              else if (answeredCorrectly)
                _statusBadge(
                  text: 'Correct',
                  background:
                  const Color(0xFFE8F7EC),
                  foreground:
                  const Color(0xFF15803D),
                  icon: Icons.check_circle,
                )
              else
                _statusBadge(
                  text: 'Wrong',
                  background:
                  const Color(0xFFFDECEC),
                  foreground:
                  const Color(0xFFB91C1C),
                  icon: Icons.cancel,
                ),
            ],
          ),

          const SizedBox(height: 14),

          // ======================================================
          // QUESTION TEXT
          // ======================================================

          if (question.hasQuestionText)
            Text(
              question.question!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
                height: 1.5,
              ),
            ),

          // ======================================================
          // QUESTION IMAGE
          // ======================================================

          if (question.hasImage) ...[
            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.network(
                question.imageAsset!,
                width: double.infinity,
                fit: BoxFit.contain,

                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return Container(
                    width: double.infinity,
                    height: 180,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.broken_image_outlined,
                      size: 42,
                      color: AppColors.textGrey,
                    ),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ======================================================
          // ANSWERS TITLE
          // ======================================================

          const Text(
            'Options',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textGrey,
            ),
          ),

          const SizedBox(height: 10),

          // ======================================================
          // OPTIONS
          // ======================================================

          if (question.optionCount > 0)
            ...List.generate(
              question.optionCount,
                  (optionIndex) {
                return _buildOption(
                  question: question,
                  optionIndex: optionIndex,
                  selectedIndex: selectedIndex,
                  correctIndex: correctIndex,
                );
              },
            )
          else
            _noOptionsMessage(),

          // ======================================================
          // ANSWER INFORMATION
          // ======================================================

          const SizedBox(height: 6),

          if (!isAnswered)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 6),

              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius:
                BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFF59E0B)
                      .withOpacity(0.35),
                ),
              ),

              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Color(0xFFF59E0B),
                  ),

                  SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      'You did not answer this question.',
                      style: TextStyle(
                        color: Color(0xFFB45309),
                        fontWeight: FontWeight.w600,
                      ),
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
  // OPTION
  // ============================================================

  Widget _buildOption({
    required QuizQuestion question,
    required int optionIndex,
    required int? selectedIndex,
    required int correctIndex,
  }) {
    // Is this the actual correct option?
    final bool isCorrect =
        correctIndex >= 0 &&
            optionIndex == correctIndex;

    // Did the student select this option?
    final bool isSelected =
        selectedIndex != null &&
            optionIndex == selectedIndex;

    // Student selected this option but it isn't correct.
    final bool isWrong =
        isSelected && !isCorrect;

    // ----------------------------------------------------------
    // DEFAULT
    // ----------------------------------------------------------

    Color backgroundColor = Colors.white;
    Color borderColor = AppColors.borderGrey;
    Color textColor = AppColors.textDark;

    // ----------------------------------------------------------
    // CORRECT = GREEN
    // ----------------------------------------------------------

    if (isCorrect) {
      backgroundColor =
      const Color(0xFFE8F7EC);

      borderColor =
      const Color(0xFF16A34A);

      textColor =
      const Color(0xFF15803D);
    }

    // ----------------------------------------------------------
    // SELECTED WRONG = RED
    // ----------------------------------------------------------

    else if (isWrong) {
      backgroundColor =
      const Color(0xFFFDECEC);

      borderColor =
      const Color(0xFFDC2626);

      textColor =
      const Color(0xFFB91C1C);
    }

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(
        bottom: 10,
      ),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: backgroundColor,

        borderRadius:
        BorderRadius.circular(12),

        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          // ====================================================
          // OPTION LETTER
          // ====================================================

          Container(
            width: 32,
            height: 32,

            alignment: Alignment.center,

            decoration: BoxDecoration(
              color:
              borderColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),

            child: Text(
              String.fromCharCode(
                65 + optionIndex,
              ),

              style: TextStyle(
                fontWeight:
                FontWeight.bold,
                color: textColor,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ====================================================
          // OPTION CONTENT
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // ------------------------------------------------
                // TEXT OPTION
                // ------------------------------------------------

                if (question.hasOptionTextAt(
                  optionIndex,
                ))
                  Text(
                    question.displayOptionText(
                      optionIndex,
                    ),

                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                      color: textColor,
                      height: 1.4,
                    ),
                  ),

                // ------------------------------------------------
                // IMAGE OPTION
                // ------------------------------------------------

                if (question.hasOptionImageAt(
                  optionIndex,
                )) ...[
                  const SizedBox(height: 8),

                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(8),

                    child: Image.network(
                      question.optionImageAt(
                        optionIndex,
                      )!,

                      height: 130,

                      width:
                      double.infinity,

                      fit: BoxFit.contain,

                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return Container(
                          height: 130,
                          width:
                          double.infinity,

                          alignment:
                          Alignment.center,

                          decoration:
                          BoxDecoration(
                            color:
                            AppColors.background,
                            borderRadius:
                            BorderRadius
                                .circular(
                              8,
                            ),
                          ),

                          child:
                          const Icon(
                            Icons
                                .broken_image_outlined,
                            color:
                            AppColors.textGrey,
                            size: 34,
                          ),
                        );
                      },
                    ),
                  ),
                ],

                // ------------------------------------------------
                // AUDIO OPTION
                // ------------------------------------------------

                if (question.hasOptionAudioAt(
                  optionIndex,
                )) ...[
                  const SizedBox(height: 8),

                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.03),

                      borderRadius:
                      BorderRadius.circular(
                        8,
                      ),
                    ),

                    child: const Row(
                      mainAxisSize:
                      MainAxisSize.min,

                      children: [
                        Icon(
                          Icons
                              .volume_up_outlined,
                          size: 18,
                          color:
                          AppColors
                              .textGrey,
                        ),

                        SizedBox(width: 6),

                        Text(
                          'Audio option',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                            AppColors
                                .textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ====================================================
          // STATUS
          // ====================================================

          if (isCorrect)
            const Icon(
              Icons.check_circle,
              color: Color(0xFF16A34A),
              size: 27,
            )
          else if (isWrong)
            const Icon(
              Icons.cancel,
              color: Color(0xFFDC2626),
              size: 27,
            ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _statusBadge({
    required String text,
    required Color background,
    required Color foreground,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: background,
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: foreground,
          ),

          const SizedBox(width: 5),

          Text(
            text,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NO OPTIONS
  // ============================================================

  Widget _noOptionsMessage() {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),

        borderRadius:
        BorderRadius.circular(12),

        border: Border.all(
          color: const Color(0xFFF59E0B),
        ),
      ),

      child: const Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFF59E0B),
          ),

          SizedBox(width: 8),

          Expanded(
            child: Text(
              'No options are available for this question.',
              style: TextStyle(
                color: Color(0xFFB45309),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}