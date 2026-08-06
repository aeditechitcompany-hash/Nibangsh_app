import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../../../common/util/secure_screen.dart';
import '../../../common/widgets/audio_play_button.dart';
import '../controller/mcq_quiz_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

const double _kWideLayoutBreakpoint = 700;

class McqQuizScreen extends StatefulWidget {
  const McqQuizScreen({super.key});

  @override
  State<McqQuizScreen> createState() => _McqQuizScreenState();
}

class _McqQuizScreenState extends State<McqQuizScreen> {
  @override
  void initState() {
    super.initState();
    SecureScreen.enable();
    // Quiz screen is landscape-only on phones and tablets alike.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SecureScreen.disable();
    // Restore all orientations for the rest of the app once we leave.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(McqQuizController());
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideLayout = screenWidth >= _kWideLayoutBreakpoint;

    final body = Container(
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
          _buildQuestionCard(controller, context, isWideLayout),
          const SizedBox(height: 40),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(controller, context),
            isWideLayout ? body : ResponsiveWrapper(child: body),
          ],
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(McqQuizController controller, BuildContext context) {
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${controller.totalQuestions} Question',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showQuestionNavigator(context, controller),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.grid_view_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
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
              fontSize: 15,
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
      bool isWideLayout,
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
              _buildQuestionMeta(controller, context),
              const SizedBox(height: 16),
              isWideLayout
                  ? _buildWideBody(controller, question)
                  : _buildNarrowBody(controller, question),
              const SizedBox(height: 8),
              _buildNavButtons(controller),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildQuestionMeta(McqQuizController controller, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Question: ${controller.currentIndex.value + 1}/${controller.totalQuestions}',
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        GestureDetector(
          onTap: () => _confirmQuit(context),
          child: const Text(
            'Quit',
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: AppColors.errorColor,
            ),
          ),
        ),
      ],
    );
  }

  // Phone layout
  Widget _buildNarrowBody(McqQuizController controller, QuizQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionContent(question),
        const SizedBox(height: 18),
        _buildOptionsSection(controller, question, isWideLayout: false),
      ],
    );
  }

  // Tablet/desktop layout
  Widget _buildWideBody(McqQuizController controller, QuizQuestion question) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _buildQuestionContent(question),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.only(left: 24),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.borderGrey, width: 1),
              ),
            ),
            child: _buildOptionsSection(controller, question, isWideLayout: true),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionContent(QuizQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question.hasQuestionText)
          Text(
            question.question!,
            style: const TextStyle(
              fontSize: 22.5,
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
      ],
    );
  }

  Widget _buildOptionsSection(
      McqQuizController controller,
      QuizQuestion question, {
        required bool isWideLayout,
      }) {
    if (question.hasOptionImages) {
      return isWideLayout
          ? _buildImageOptionsList(controller, question)
          : _buildImageOptionsGrid(controller, question);
    }
    return _buildOptionsList(controller, question);
  }

  Widget _buildNavButtons(McqQuizController controller) {
    return Row(
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
                        fontSize: 20,
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

  Widget _buildImageOptionsList(McqQuizController controller, QuizQuestion question) {
    return Column(
      children: List.generate(question.optionCount, (index) {
        final selected = controller.selectedForCurrent == index;
        final imagePath = question.hasOptionImageAt(index)
            ? question.optionImages![index]
            : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => controller.selectOption(index),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _optionNumberBadge(index, selected: selected),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        color: AppColors.background,
                        padding: const EdgeInsets.all(8),
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
                  ),
                ],
              ),
            ),
          ),
        );
      }),
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
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }

  // ── Question-number navigator ──
  void _showQuestionNavigator(BuildContext context, McqQuizController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.borderGrey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jump to Question',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Obx(
                          () => Text(
                        '${controller.answeredCount}/${controller.totalQuestions} answered',
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildNavigatorLegend(),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.totalQuestions,
                      gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 64,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        // Obx must live INSIDE itemBuilder (per grid cell),
                        // not wrapped around the whole GridView.builder.
                        // itemBuilder callbacks run during layout, after
                        // the outer Obx's build() already finished, so an
                        // outer Obx never sees currentIndex/selectedAnswers
                        // being read -> "no observables found" error.
                        return Obx(() {
                          final isCurrent =
                              controller.currentIndex.value == index;
                          final answered = controller.isAnswered(index);

                          final Color background;
                          final Color border;
                          final Color text;

                          if (isCurrent) {
                            background = AppColors.primaryBlue;
                            border = AppColors.primaryBlue;
                            text = Colors.white;
                          } else if (answered) {
                            background = AppColors.primaryBlue.withOpacity(0.1);
                            border = AppColors.primaryBlue.withOpacity(0.4);
                            text = AppColors.primaryBlue;
                          } else {
                            background = Colors.white;
                            border = AppColors.borderGrey;
                            text = AppColors.textDark;
                          }

                          return GestureDetector(
                            onTap: () {
                              controller.jumpToQuestion(index);
                              Get.back();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: background,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: border, width: 1.4),
                              ),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: text,
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _confirmSubmit(context, controller);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Submit and Finish Exam',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigatorLegend() {
    return Row(
      children: [
        _legendDot(AppColors.primaryBlue, 'Current'),
        const SizedBox(width: 16),
        _legendDot(AppColors.primaryBlue.withOpacity(0.15), 'Answered', borderColor: AppColors.primaryBlue.withOpacity(0.4)),
        const SizedBox(width: 16),
        _legendDot(Colors.white, 'Unanswered', borderColor: AppColors.borderGrey),
      ],
    );
  }

  Widget _legendDot(Color color, String label, {Color? borderColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor ?? color),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
        ),
      ],
    );
  }

  void _confirmSubmit(BuildContext context, McqQuizController controller) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Submit Exam?'),
        content: Obx(
              () => Text(
            controller.answeredCount < controller.totalQuestions
                ? 'You have answered ${controller.answeredCount} of ${controller.totalQuestions} questions. Unanswered questions will be marked wrong.'
                : 'You have answered all questions. Submit now?',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              controller.submitExam();
            },
            child: const Text('Submit'),
          ),
        ],
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