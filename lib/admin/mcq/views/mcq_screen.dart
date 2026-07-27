import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/models/mcq_model.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../../../common/widgets/audio_play_button.dart';
import '../controller/mcq_controller.dart';

class AdminMcqScreen extends StatelessWidget {
  const AdminMcqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminMcqController());

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMcqSheet(context, controller),
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add MCQ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(controller, context),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.only(top: 20),
              child: _buildQuestionList(controller, context),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AdminMcqController controller, BuildContext context) {
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
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoute.notifications),
                child: Container(
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
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'MCQ Manager',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(
              '${controller.questions.length} questions shared with students',
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionList(
    AdminMcqController controller,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final questions = controller.questions;
        if (questions.isEmpty) {
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
                    'No MCQs added yet',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tap "Add MCQ" to create one for students',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }
        return Column(
          children: questions
              .asMap()
              .entries
              .map((e) => _questionCard(controller, e.key, e.value, context))
              .toList(),
        );
      }),
    );
  }

  Widget _questionCard(
    AdminMcqController controller,
    int index,
    McqQuestion q,
    BuildContext context,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _showAddMcqSheet(context, controller, editQuestion: q),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Q${index + 1}. ${q.question}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _confirmDelete(controller, q),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.primaryRed,
                    size: 20,
                  ),
                  tooltip: 'Delete',
                ),
              ],
            ),
            if (q.hasAudio) ...[
              const SizedBox(height: 6),
              AudioPlayButton(filePath: q.audioFilePath!, label: 'Play clip'),
            ],
            const SizedBox(height: 10),
            ...List.generate(q.options.length, (i) {
              final isCorrect = i == q.correctOptionIndex;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      isCorrect
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      size: 16,
                      color: isCorrect
                          ? const Color(0xFF16A34A)
                          : AppColors.textGrey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        q.options[i],
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isCorrect
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isCorrect
                              ? const Color(0xFF16A34A)
                              : AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(AdminMcqController controller, McqQuestion q) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove MCQ?'),
        content: const Text('Students will no longer see this question.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteQuestion(q.id);
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: AppColors.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMcqSheet(
    BuildContext context,
    AdminMcqController controller, {
    McqQuestion? editQuestion,
  }) {
    if (editQuestion != null) {
      controller.startEdit(editQuestion);
    } else {
      controller.startAdd();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: AppColors.borderGrey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.isEditing
                            ? 'Edit Question'
                            : 'Add a Question',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.questionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Question',
                        hintText: 'e.g. What does IELTS stand for?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Options (tap the circle to mark correct answer)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Column(
                        children: List.generate(4, (i) {
                          final selected =
                              controller.correctOptionIndex.value == i;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () =>
                                      controller.correctOptionIndex.value = i,
                                  child: Icon(
                                    selected
                                        ? Icons.check_circle_rounded
                                        : Icons.circle_outlined,
                                    color: selected
                                        ? const Color(0xFF16A34A)
                                        : AppColors.textGrey,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: controller.optionControllers[i],
                                    decoration: InputDecoration(
                                      labelText: 'Option ${i + 1}',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Audio (optional)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: controller.isPicking.value
                            ? null
                            : controller.pickAudio,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderGrey),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.audiotrack_rounded,
                                  color: AppColors.primaryBlue,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  controller.hasPickedAudio
                                      ? controller.pickedAudioName.value
                                      : controller.isPicking.value
                                      ? 'Opening file picker...'
                                      : controller.isEditing
                                      ? 'Keep current clip (tap to replace)'
                                      : 'Choose an MP3 file',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (controller.hasPickedAudio)
                                IconButton(
                                  onPressed: controller.clearPickedAudio,
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: AppColors.textGrey,
                                    size: 18,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.saveQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Obx(
                          () => Text(
                            controller.isEditing ? 'Save Changes' : 'Save MCQ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
