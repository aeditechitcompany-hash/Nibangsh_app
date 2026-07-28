import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../../../common/widgets/audio_play_button.dart';
import '../controller/mcq_quiz_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class McqQuizScreen extends StatelessWidget {
  const McqQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(McqQuizController());

    return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(controller),
              ResponsiveWrapper(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuestionCard(controller, context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  // ── Header ──
  Widget _buildHeader(McqQuizController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
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
      child: Column(
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.quizSet.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${controller.totalQuestions} Question',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Question card ──
  Widget _buildQuestionCard(
      McqQuizController controller,
      BuildContext context,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Obx(() {
          final question = controller.currentQuestion;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question: ${controller.currentIndex.value + 1}/${controller.totalQuestions}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _confirmQuit(context),
                    child: const Text(
                      'Quit',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.errorColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (question.hasQuestionText)
                Text(
                  question.question!,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    height: 1.4,
                  ),
                ),

              // Stimulus image (e.g. a picture/poster/graph the student looks at before answering).
              if (question.hasImage) ...[
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    color: AppColors.background,
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      question.imageAsset!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Image not found: ${question.imageAsset}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.errorColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              // Listening clip, if this question has one.
              if (question.hasAudio) ...[
                const SizedBox(height: 12),
                AudioPlayButton(
                  filePath: question.audioAsset!,
                  isAsset: true,
                  label: 'Listen',
                ),
              ],

              const SizedBox(height: 18),
              ...List.generate(question.options.length, (index) {
                final selected = controller.selectedForCurrent == index;
                final optionImage =
                question.hasOptionImages &&
                    index < question.optionImages!.length
                    ? question.optionImages![index]
                    : null;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => controller.selectOption(index),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primaryBlue : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? AppColors.primaryBlue
                              : AppColors.borderGrey,
                        ),
                      ),
                      child: optionImage == null
                          ? Text(
                        question.options[index],
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : AppColors.textDark,
                        ),
                      )
                          : Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 48,
                              height: 48,
                              color: selected
                                  ? Colors.white.withOpacity(0.15)
                                  : AppColors.background,
                              child: Image.asset(
                                optionImage,
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image_outlined,
                                  size: 20,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              question.options[index],
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : AppColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: controller.isFirstQuestion
                            ? null
                            : controller.goPrevious,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.borderGrey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Previous',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: controller.selectedForCurrent == null
                            ? null
                            : controller.goNextOrFinish,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          disabledBackgroundColor: AppColors.primaryBlue
                              .withOpacity(0.4),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          controller.isLastQuestion ? 'Finish' : 'Next',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  void _confirmQuit(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Quit Quiz?'),
        content: const Text('Your progress on this attempt will be lost.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back(); // close dialog
              Get.until((route) => route.settings.name == AppRoute.home);
            },
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }
}
