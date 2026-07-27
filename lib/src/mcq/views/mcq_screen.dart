import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../../../common/widgets/audio_play_button.dart';
import '../controller/mcq_controller.dart';

class McqScreen extends StatelessWidget {
  const McqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(McqController());

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Obx(() {
              if (controller.questions.isEmpty) {
                return _emptyState();
              }
              if (controller.submitted.value) {
                return _resultCard(controller);
              }
              return _quizCard(controller);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MCQ Practice',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Test your knowledge',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoute.studentNotifications),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 40,
              color: AppColors.textGrey.withOpacity(0.4),
            ),
            const SizedBox(height: 12),
            const Text(
              'No MCQs available yet',
              style: TextStyle(
                color: AppColors.textGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Check back once your consultancy adds some',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quizCard(McqController controller) {
    final q = controller.currentQuestion!;
    final total = controller.questions.length;
    final index = controller.currentIndex.value;
    final selected = controller.selectedForCurrent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${index + 1} of $total',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
              ),
            ),
            Text(
              '${controller.selectedAnswers.length}/$total answered',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Container(height: 6, color: AppColors.borderGrey),
                Container(
                  height: 6,
                  width: constraints.maxWidth * ((index + 1) / total),
                  color: AppColors.primaryBlue,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Question card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                q.question,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              if (q.hasAudio) ...[
                const SizedBox(height: 10),
                AudioPlayButton(
                  filePath: q.audioFilePath!,
                  label: 'Listen to clip',
                ),
              ],
              const SizedBox(height: 16),
              ...List.generate(q.options.length, (i) {
                final isSelected = selected == i;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => controller.selectOption(i),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryBlue.withOpacity(0.08)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.borderGrey,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            size: 20,
                            color: isSelected
                                ? AppColors.primaryBlue
                                : AppColors.textGrey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              q.options[i],
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Nav buttons
        Row(
          children: [
            if (!controller.isFirstQuestion)
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousQuestion,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.borderGrey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Previous',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ),
            if (!controller.isFirstQuestion) const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.isLastQuestion
                    ? controller.submitQuiz
                    : controller.nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  controller.isLastQuestion ? 'Submit' : 'Next',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _resultCard(McqController controller) {
    final total = controller.questions.length;
    final score = controller.score;
    final percent = total == 0 ? 0 : ((score / total) * 100).round();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Color(0xFF16A34A),
                  size: 30,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Quiz Complete!',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'You scored $score out of $total ($percent%)',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.restartQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Retake Quiz',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Review',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...controller.questions.asMap().entries.map((entry) {
          final i = entry.key;
          final q = entry.value;
          final picked = controller.selectedAnswers[q.id];
          final isCorrect = picked == q.correctOptionIndex;
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isCorrect
                    ? const Color(0xFF16A34A).withOpacity(0.4)
                    : AppColors.primaryRed.withOpacity(0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isCorrect
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      size: 18,
                      color: isCorrect
                          ? const Color(0xFF16A34A)
                          : AppColors.primaryRed,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Q${i + 1}. ${q.question}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Correct answer: ${q.options[q.correctOptionIndex]}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF16A34A),
                  ),
                ),
                if (!isCorrect && picked != null)
                  Text(
                    'Your answer: ${q.options[picked]}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryRed,
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
