import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/models/quiz_models.dart';
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
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.quizSet.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
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
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => _timerChip(controller)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timerChip(McqQuizController controller) {
    final lowTime = controller.isTimeRunningLow;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: lowTime ? AppColors.errorColor.withOpacity(0.18) : Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            color: lowTime ? AppColors.errorColor : Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            controller.formattedTime,
            style: TextStyle(
              color: lowTime ? AppColors.errorColor : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
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
                    fontSize: 19.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    height: 1.4,
                  ),
                ),

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
              question.hasOptionImages
                  ? _buildImageOptionsGrid(controller, question)
                  : _buildOptionsList(controller, question),
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

  // ── Text / audio options ──
  Widget _buildOptionsList(McqQuizController controller, QuizQuestion question) {
    return Column(
      children: List.generate(question.optionCount, (index) {
        final selected = controller.selectedForCurrent == index;
        final displayText = question.displayOptionText(index);
        final hasAudioOption = question.hasOptionAudioAt(index);

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () => controller.selectOption(index),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryBlue : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppColors.primaryBlue : AppColors.borderGrey,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _optionNumberBadge(index, selected: selected, onColoredBackground: true),
                  const SizedBox(width: 12),
                  Expanded(
                    child: hasAudioOption
                        ? AudioPlayButton(
                      filePath: question.optionAudios![index],
                      isAsset: true,
                      label: displayText.isNotEmpty
                          ? displayText
                          : 'Listen ${index + 1}',
                    )
                        : Text(
                      displayText,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppColors.textDark,
                      ),
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

  // ── Image options ──
  Widget _buildImageOptionsGrid(McqQuizController controller, QuizQuestion question) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: question.optionCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final selected = controller.selectedForCurrent == index;
        final imagePath = question.hasOptionImageAt(index)
            ? question.optionImages![index]
            : null;

        return GestureDetector(
          onTap: () => controller.selectOption(index),
          child: Container(
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryBlue.withOpacity(0.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.primaryBlue : AppColors.borderGrey,
                width: selected ? 2 : 1,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                    child: imagePath == null
                        ? const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 28,
                        color: AppColors.textGrey,
                      ),
                    )
                        : Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                      const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 28,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: _optionNumberBadge(index, selected: selected),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _optionNumberBadge(
      int index, {
        required bool selected,
        bool onColoredBackground = false,
      }) {
    final Color background;
    final Color border;
    final Color text;

    if (onColoredBackground) {
      background = selected ? Colors.white : AppColors.background;
      border = selected ? Colors.white : AppColors.borderGrey;
      text = selected ? AppColors.primaryBlue : AppColors.textDark;
    } else {
      background = selected ? AppColors.primaryBlue : AppColors.background;
      border = selected ? AppColors.primaryBlue : AppColors.borderGrey;
      text = selected ? Colors.white : AppColors.textDark;
    }

    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background,
        border: Border.all(color: border),
      ),
      child: Text(
        '${index + 1}',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: text,
        ),
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
              Get.back();
              Get.until((route) => route.settings.name == AppRoute.home);
            },
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }
}