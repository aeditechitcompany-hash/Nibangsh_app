import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../../../common/util/responsive.dart';
import '../../../common/util/secure_screen.dart';
import '../../../common/widgets/audio_play_button.dart';
import '../controller/mcq_quiz_controller.dart';


const double _kWideLayoutBreakpoint = 700;

class McqQuizScreen extends StatefulWidget {
  const McqQuizScreen({super.key});

  @override
  State<McqQuizScreen> createState() => _McqQuizScreenState();
}

class _McqQuizScreenState extends State<McqQuizScreen> {
  // One audio controller per option index.
  final Map<int, AudioPlayButtonController> _optionAudioControllers = {};

  AudioPlayButtonController _controllerForOption(int index) {
    return _optionAudioControllers.putIfAbsent(
      index,
          () => AudioPlayButtonController(),
    );
  }

  @override
  void initState() {
    super.initState();

    SecureScreen.enable();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SecureScreen.disable();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  // ============================================================
  // PATH HELPERS
  // ============================================================

  bool _isBundledAsset(String path) {
    return path.startsWith('assets/');
  }

  bool _isNetworkUrl(String path) {
    return path.startsWith('http://') ||
        path.startsWith('https://');
  }

  bool _isLocalFile(String path) {
    return !_isBundledAsset(path) &&
        !_isNetworkUrl(path) &&
        path.startsWith('/');
  }

  // ============================================================
  // IMAGE WIDGET
  // ============================================================

  Widget _quizImage(
      String path, {
        required BoxFit fit,
        required Widget Function(
            BuildContext,
            Object,
            StackTrace?,
            ) errorBuilder,
      }) {
    // ------------------------------------------------------------
    // BUNDLED FLUTTER ASSET
    // ------------------------------------------------------------

    if (_isBundledAsset(path)) {
      return Image.asset(
        path,
        fit: fit,
        errorBuilder: errorBuilder,
      );
    }

    // ------------------------------------------------------------
    // NETWORK IMAGE
    // ------------------------------------------------------------

    if (_isNetworkUrl(path)) {
      return Image.network(
        path,
        fit: fit,
        errorBuilder: errorBuilder,
        loadingBuilder: (
            context,
            child,
            loadingProgress,
            ) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }

    // ------------------------------------------------------------
    // RELATIVE DJANGO / RENDER URL
    // ------------------------------------------------------------

    if (path.startsWith('/')) {
      final url =
          'https://backend-1-mltk.onrender.com$path';

      return Image.network(
        url,
        fit: fit,
        errorBuilder: errorBuilder,
        loadingBuilder: (
            context,
            child,
            loadingProgress,
            ) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }

    // ------------------------------------------------------------
    // LOCAL DEVICE FILE
    // ------------------------------------------------------------

    if (_isLocalFile(path)) {
      return Image.file(
        File(path),
        fit: fit,
        errorBuilder: errorBuilder,
      );
    }

    // ------------------------------------------------------------
    // FALLBACK
    // ------------------------------------------------------------

    return Image.file(
      File(path),
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }

  // ============================================================
  // LARGE IMAGE PREVIEW
  // ============================================================

  void _showImagePreview(
      BuildContext context,
      String imagePath,
      ) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.88),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(18),
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    maxWidth: 1000,
                    maxHeight: 700,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4.0,
                    panEnabled: true,
                    scaleEnabled: true,
                    boundaryMargin:
                    const EdgeInsets.all(40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 650,
                      child: _quizImage(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return const Center(
                            child: Icon(
                              Icons
                                  .broken_image_outlined,
                              size: 60,
                              color:
                              AppColors.textGrey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // ------------------------------------------------
              // CLOSE BUTTON
              // ------------------------------------------------

              Positioned(
                top: 10,
                right: 10,
                child: Material(
                  color:
                  Colors.black.withOpacity(0.65),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder:
                    const CircleBorder(),
                    onTap: () {
                      Navigator.of(
                        dialogContext,
                      ).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),

              // ------------------------------------------------
              // ZOOM LABEL
              // ------------------------------------------------

              Positioned(
                left: 14,
                bottom: 14,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color:
                    Colors.black.withOpacity(0.6),
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.zoom_in,
                        color: Colors.white,
                        size: 17,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Pinch to zoom',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final controller =
    Get.put(McqQuizController());

    final screenWidth =
        MediaQuery.of(context).size.width;

    final isWideLayout =
        screenWidth >= _kWideLayoutBreakpoint;

    final body = SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _buildHeader(
            controller,
            context,
          ),

          Container(
            decoration:
            const BoxDecoration(
              color: AppColors.background,
              borderRadius:
              BorderRadius.only(
                topLeft:
                Radius.circular(28),
                topRight:
                Radius.circular(28),
              ),
            ),
            padding:
            const EdgeInsets.only(
              top: 22,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _buildQuestionCard(
                  controller,
                  context,
                  isWideLayout,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );

    final content = isWideLayout
        ? body
        : ResponsiveWrapper(
      child: body,
    );

    return Scaffold(
      backgroundColor:
      AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: content,
          ),

          // Fixed bottom navigation.
          _buildBottomNavBar(
            controller,
            isWideLayout,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
      McqQuizController controller,
      BuildContext context,
      ) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        26,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.navyDark,
            AppColors.navyLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
        const BorderRadius.only(
          bottomLeft:
          Radius.circular(32),
          bottomRight:
          Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),

          // ========================================================
          // HEADER
          // LEFT   = SET + QUESTION
          // CENTER = ATTEMPTED
          // RIGHT  = QUESTION NAVIGATOR + TIMER
          // ========================================================

          Stack(
            alignment: Alignment.center,
            children: [
              // ----------------------------------------------------
              // LEFT: SET INFORMATION
              // ----------------------------------------------------
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding:
                        const EdgeInsets.all(8),
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
                        SizedBox(
                          width:
                          MediaQuery.of(context).size.width * 0.24,
                          child: Text(
                            controller.quizSet.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSansKr(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        Obx(
                              () => Text(
                            'Question ${controller.currentIndex.value + 1}/${controller.totalQuestions}',
                            style: GoogleFonts.notoSansKr(
                              color: Colors.white.withOpacity(0.80),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ----------------------------------------------------
              // CENTER: ATTEMPTED
              // This is the ONLY Attempted counter on the screen.
              // ----------------------------------------------------
              Center(
                child: Obx(
                      () => Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.22),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.edit_note_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Attempted',
                          style: GoogleFonts.notoSansKr(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            '${controller.answeredCount}/${controller.totalQuestions}',
                            style: GoogleFonts.notoSansKr(
                              color: AppColors.primaryBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ----------------------------------------------------
              // RIGHT: QUESTION NAVIGATOR + TIMER
              // ----------------------------------------------------
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _showQuestionNavigator(
                        context,
                        controller,
                      ),
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

                    Obx(
                          () => _timerChip(controller),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TIMER
  // ============================================================

  Widget _timerChip(
      McqQuizController controller,
      ) {
    final lowTime =
        controller.isTimeRunningLow;

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration:
      BoxDecoration(
        color: lowTime
            ? AppColors.errorColor
            .withOpacity(0.18)
            : Colors.white
            .withOpacity(0.14),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            color: lowTime
                ? AppColors.errorColor
                : Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            controller.formattedTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUESTION CARD
  // ============================================================

  Widget _buildQuestionCard(
      McqQuizController controller,
      BuildContext context,
      bool isWideLayout,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        width: double.infinity,
        padding:
        const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(
            20,
          ),
          border: Border.all(
            color:
            AppColors.borderGrey,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.03),
              blurRadius: 8,
              offset:
              const Offset(0, 3),
            ),
          ],
        ),
        child: Obx(
              () {
            final question =
                controller.currentQuestion;

            return Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                _buildQuestionMeta(
                  controller,
                  context,
                ),
                const SizedBox(
                    height: 16),
                isWideLayout
                    ? _buildWideBody(
                  controller,
                  question,
                )
                    : _buildNarrowBody(
                  controller,
                  question,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // QUESTION META
  // ============================================================

  Widget _buildQuestionMeta(
      McqQuizController controller,
      BuildContext context,
      ) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment
          .spaceBetween,
      children: [
        Text(
          'Question: ${controller.currentIndex.value + 1}/${controller.totalQuestions}',
          style: GoogleFonts.notoSansKr(
            fontSize: 14.5,
            fontWeight:
            FontWeight.w700,
            color:
            AppColors.primaryBlue,
          ),
        ),

        GestureDetector(
          onTap: () =>
              _confirmQuit(context),
          child: Text(
            'Quit',
            style: GoogleFonts.notoSansKr(
              fontSize: 16,
              fontWeight:
              FontWeight.w700,
              color:
              AppColors.errorColor,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // NARROW BODY
  // ============================================================

  Widget _buildNarrowBody(
      McqQuizController controller,
      QuizQuestion question,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment
          .start,
      children: [
        _buildQuestionContent(
          question,
        ),
        const SizedBox(height: 18),
        _buildOptionsSection(
          controller,
          question,
          isWideLayout: false,
        ),
      ],
    );
  }

  // ============================================================
  // WIDE BODY
  // ============================================================

  Widget _buildWideBody(
      McqQuizController controller,
      QuizQuestion question,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 55,
          child: SingleChildScrollView(
            child: _buildQuestionContent(question),
          ),
        ),

        const SizedBox(width: 24),

        Expanded(
          flex: 45,
          child: Container(
            padding: const EdgeInsets.only(
              left: 24,
            ),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppColors.borderGrey,
                  width: 1,
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: _buildOptionsSection(
                controller,
                question,
                isWideLayout: true,
              ),
            ),
          ),
        ),
      ],
    );
  }


  // ============================================================
  // QUESTION CONTENT
  // ============================================================

  Widget _buildQuestionContent(
      QuizQuestion question,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment
          .start,
      children: [

          if (question.hasQuestionText)
            Wrap(
              spacing: 4,
              runSpacing: 0,
              children: question.question!
                  .trim()
                  .split(RegExp(r'\s+'))
                  .map(
                    (word) => Text(
                  word,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 22.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                    height: 1.6,
                  ),
                ),
              )
                  .toList(),
            ),

        if (question.hasImage) ...[
          const SizedBox(height: 14),

          ClipRRect(
            borderRadius:
            BorderRadius.circular(
              14,
            ),
            child: Container(
              width:
              double.infinity,
              color:
              AppColors.background,
              padding:
              const EdgeInsets.all(
                10,
              ),
              child: _quizImage(
                question.imageAsset!,
                fit: BoxFit.contain,
                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return Padding(
                    padding:
                    const EdgeInsets
                        .all(20),
                    child: Text(
                      'Image not found: ${question.imageAsset}',
                      style:
                      GoogleFonts
                          .notoSansKr(
                        fontSize: 11,
                        color:
                        AppColors
                            .errorColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],

        if (question.hasAudio) ...[
          const SizedBox(height: 18),

          Center(
            child:
            AudioPlayButton(
              filePath:
              question.audioAsset!,
              isAsset:
              _isBundledAsset(
                question.audioAsset!,
              ),
              label:
              'Listen to the question',
              size: 120,
            ),
          ),
        ],
      ],
    );
  }

  // ============================================================
  // OPTIONS SECTION
  // ============================================================

  Widget _buildOptionsSection(
      McqQuizController controller,
      QuizQuestion question, {
        required bool isWideLayout,
      }) {
    final hasText =
    question.options.any(
          (text) =>
      text.trim().isNotEmpty,
    );

    final hasImages =
        question.hasOptionImages;

    // Image-only questions
    if (hasImages && !hasText) {
      return isWideLayout
          ? _buildImageOptionsList(
        controller,
        question,
      )
          : _buildImageOptionsGrid(
        controller,
        question,
      );
    }

    // Text/audio questions
    return _buildOptionsList(
      controller,
      question,
    );
  }

  // ============================================================
  // FIXED BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavBar(
      McqQuizController controller,
      bool isWideLayout,
      ) {
    final navButtons =
    _buildNavButtons(
      controller,
    );

    return Container(
      width: double.infinity,
      decoration:
      const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color:
            AppColors.borderGrey,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding:
          const EdgeInsets
              .fromLTRB(
            20,
            12,
            20,
            12,
          ),
          child: isWideLayout
              ? ResponsiveWrapper(
            child:
            navButtons,
          )
              : navButtons,
        ),
      ),
    );
  }

  Widget _buildNavButtons(
      McqQuizController controller,
      ) {
    return Obx(
          () => Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 46,
              child:
              OutlinedButton(
                onPressed:
                controller
                    .isFirstQuestion
                    ? null
                    : controller
                    .goPrevious,
                style:
                OutlinedButton
                    .styleFrom(
                  side:
                  const BorderSide(
                    color: AppColors
                        .borderGrey,
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius
                        .circular(
                      12,
                    ),
                  ),
                ),
                child: Text(
                  'Previous',
                  textAlign: TextAlign.justify,
                  style:
                  GoogleFonts
                      .notoSansKr(

                    color:
                    AppColors
                        .textDark,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: SizedBox(
              height: 46,
              child:
              ElevatedButton(
                onPressed:
                controller.selectedForCurrent ==
                    null ||
                    controller
                        .isSubmittingAnswer
                        .value
                    ? null
                    : controller
                    .goNextOrFinish,
                style:
                ElevatedButton
                    .styleFrom(
                  backgroundColor:
                  AppColors
                      .primaryBlue,
                  disabledBackgroundColor:
                  AppColors
                      .primaryBlue
                      .withOpacity(
                    0.4,
                  ),
                  foregroundColor:
                  Colors.white,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius
                        .circular(
                      12,
                    ),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  controller
                      .isLastQuestion
                      ? 'Finish'
                      : 'Next',
                  style:
                  GoogleFonts
                      .notoSansKr(
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TEXT / AUDIO OPTIONS
  // ============================================================

  Widget _buildOptionsList(
      McqQuizController controller,
      QuizQuestion question,
      ) {
    return Column(
      children: List.generate(
        question.optionCount,
            (index) {
          final selected =
              controller
                  .selectedForCurrent ==
                  index;

          final displayText =
          question
              .displayOptionText(
            index,
          );

          final hasAudioOption =
          question
              .hasOptionAudioAt(
            index,
          );

          return Padding(
            padding:
            const EdgeInsets
                .only(
              bottom: 10,
            ),
            child:
            GestureDetector(
              onTap: () {
                controller
                    .selectOption(
                  index,
                );

                if (hasAudioOption) {
                  _controllerForOption(
                    index,
                  ).play();
                }
              },
              child:
              AnimatedContainer(
                duration:
                const Duration(
                  milliseconds: 180,
                ),
                curve:
                Curves.easeOut,
                width:
                double.infinity,
                padding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration:
                BoxDecoration(
                  color: selected
                      ? AppColors
                      .primaryBlue
                      .withOpacity(
                    0.08,
                  )
                      : Colors.white,
                  borderRadius:
                  BorderRadius
                      .circular(
                    12,
                  ),
                  border:
                  Border.all(
                    color: selected
                        ? AppColors
                        .primaryBlue
                        : AppColors
                        .borderGrey,
                    width: selected
                        ? 2
                        : 1,
                  ),
                ),
                child:
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .center,
                  children: [
                    _optionNumberBadge(
                      index,
                      selected:
                      selected,
                    ),

                    const SizedBox(
                        width: 12),

                    Expanded(
                      child:
                      hasAudioOption
                          ? AudioPlayButton(
                        filePath:
                        question.optionAudios![index],
                        isAsset:
                        _isBundledAsset(
                          question.optionAudios![index],
                        ),
                        label: displayText
                            .isNotEmpty
                            ? displayText
                            : 'Listen ${index + 1}',
                        controller:
                        _controllerForOption(
                          index,
                        ),
                      )
                          : Wrap(
                        spacing: 4,
                        runSpacing: 0,
                        children: displayText
                            .trim()
                            .split(RegExp(r'\s+'))
                            .map(
                              (word) => Text(
                            word,
                            style: GoogleFonts.notoSansKr(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                              height: 1.5,
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // IMAGE OPTIONS GRID
  // ============================================================

  Widget _buildImageOptionsGrid(
      McqQuizController controller,
      QuizQuestion question,
      ) {
    return GridView.builder(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount:
      question.optionCount,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,

        // More balanced than 1.1
        childAspectRatio: 1.0,
      ),
      itemBuilder:
          (context, index) {
        final selected =
            controller
                .selectedForCurrent ==
                index;

        final imagePath =
        question
            .hasOptionImageAt(
          index,
        )
            ? question
            .optionImages![index]
            : null;

        final hasAudioOption =
        question
            .hasOptionAudioAt(
          index,
        );

        return GestureDetector(
          onTap: () {
            controller
                .selectOption(
              index,
            );

            if (hasAudioOption) {
              _controllerForOption(
                index,
              ).play();
            }
          },
          child:
          AnimatedContainer(
            duration:
            const Duration(
              milliseconds: 180,
            ),
            curve:
            Curves.easeOut,

            decoration:
            BoxDecoration(
              color: selected
                  ? AppColors
                  .primaryBlue
                  .withOpacity(
                0.08,
              )
                  : Colors.white,

              borderRadius:
              BorderRadius
                  .circular(
                16,
              ),

              border:
              Border.all(
                color: selected
                    ? AppColors
                    .primaryBlue
                    : AppColors
                    .borderGrey,
                width: selected
                    ? 2
                    : 1,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(
                    0.04,
                  ),
                  blurRadius: 8,
                  offset:
                  const Offset(
                    0,
                    3,
                  ),
                ),
              ],
            ),

            child: Stack(
              children: [
                // ----------------------------------------------
                // IMAGE AREA
                // ----------------------------------------------

                Positioned(
                  top: 42,
                  left: 10,
                  right: 10,
                  bottom:
                  hasAudioOption
                      ? 50
                      : 10,
                  child:
                  imagePath == null
                      ? hasAudioOption
                      ? Center(
                    child:
                    AudioPlayButton(
                      filePath:
                      question.optionAudioAt(
                        index,
                      )!,
                      isAsset:
                      _isBundledAsset(
                        question.optionAudioAt(
                          index,
                        )!,
                      ),
                      label:
                      'Listen ${index + 1}',
                      controller:
                      _controllerForOption(
                        index,
                      ),
                      size: 48,
                    ),
                  )
                      : const Center(
                    child:
                    Icon(
                      Icons
                          .broken_image_outlined,
                      size: 34,
                      color:
                      AppColors.textGrey,
                    ),
                  )
                      : GestureDetector(
                    onTap: () {
                      _showImagePreview(
                        context,
                        imagePath,
                      );
                    },
                    child:
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(
                        10,
                      ),
                      child:
                      Container(
                        color: AppColors
                            .background,
                        padding:
                        const EdgeInsets
                            .all(
                          8,
                        ),
                        child:
                        _quizImage(
                          imagePath,
                          fit: BoxFit
                              .contain,
                          errorBuilder:
                              (
                              context,
                              error,
                              stackTrace,
                              ) {
                            return const Center(
                              child:
                              Icon(
                                Icons
                                    .broken_image_outlined,
                                size: 34,
                                color:
                                AppColors.textGrey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // ----------------------------------------------
                // OPTION NUMBER
                // ----------------------------------------------

                Positioned(
                  top: 8,
                  left: 8,
                  child:
                  _optionNumberBadge(
                    index,
                    selected:
                    selected,
                  ),
                ),

                // ----------------------------------------------
                // ZOOM ICON
                // ----------------------------------------------

                if (imagePath != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child:
                    Container(
                      padding:
                      const EdgeInsets
                          .all(6),
                      decoration:
                      BoxDecoration(
                        color: Colors
                            .black
                            .withOpacity(
                          0.55,
                        ),
                        shape:
                        BoxShape
                            .circle,
                      ),
                      child:
                      const Icon(
                        Icons.zoom_in,
                        size: 18,
                        color:
                        Colors.white,
                      ),
                    ),
                  ),

                // ----------------------------------------------
                // AUDIO
                // ----------------------------------------------

                if (hasAudioOption)
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 8,
                    child: Center(
                      child:
                      AudioPlayButton(
                        filePath:
                        question
                            .optionAudioAt(
                          index,
                        )!,
                        isAsset:
                        _isBundledAsset(
                          question
                              .optionAudioAt(
                            index,
                          )!,
                        ),
                        label:
                        'Listen ${index + 1}',
                        controller:
                        _controllerForOption(
                          index,
                        ),
                        size: 42,
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

  // ============================================================
  // IMAGE OPTIONS WIDE LIST
  // ============================================================

  Widget _buildImageOptionsList(
      McqQuizController controller,
      QuizQuestion question,
      ) {
    return Column(
      children: List.generate(
        question.optionCount,
            (index) {
          final selected =
              controller
                  .selectedForCurrent ==
                  index;

          final imagePath =
          question
              .hasOptionImageAt(
            index,
          )
              ? question
              .optionImages![index]
              : null;

          final hasAudioOption =
          question
              .hasOptionAudioAt(
            index,
          );

          return Padding(
            padding:
            const EdgeInsets
                .only(
              bottom: 14,
            ),
            child:
            GestureDetector(
              onTap: () {
                controller
                    .selectOption(
                  index,
                );

                if (hasAudioOption) {
                  _controllerForOption(
                    index,
                  ).play();
                }
              },
              child:
              AnimatedContainer(
                duration:
                const Duration(
                  milliseconds: 180,
                ),
                curve:
                Curves.easeOut,

                width:
                double.infinity,

                padding:
                const EdgeInsets
                    .all(
                  12,
                ),

                decoration:
                BoxDecoration(
                  color: selected
                      ? AppColors
                      .primaryBlue
                      .withOpacity(
                    0.08,
                  )
                      : Colors.white,

                  borderRadius:
                  BorderRadius
                      .circular(
                    16,
                  ),

                  border:
                  Border.all(
                    color: selected
                        ? AppColors
                        .primaryBlue
                        : AppColors
                        .borderGrey,
                    width: selected
                        ? 2
                        : 1,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors
                          .black
                          .withOpacity(
                        0.04,
                      ),
                      blurRadius:
                      8,
                      offset:
                      const Offset(
                        0,
                        3,
                      ),
                    ),
                  ],
                ),

                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    // ------------------------------------------
                    // OPTION NUMBER
                    // ------------------------------------------

                    _optionNumberBadge(
                      index,
                      selected:
                      selected,
                    ),

                    const SizedBox(
                        width: 14),

                    // ------------------------------------------
                    // IMAGE + AUDIO
                    // ------------------------------------------

                    Expanded(
                      child:
                      Column(
                        children: [
                          SizedBox(
                            height: 210,
                            width: double
                                .infinity,

                            child:
                            imagePath ==
                                null
                                ? hasAudioOption
                                ? Center(
                              child:
                              AudioPlayButton(
                                filePath:
                                question.optionAudioAt(
                                  index,
                                )!,
                                isAsset:
                                _isBundledAsset(
                                  question.optionAudioAt(
                                    index,
                                  )!,
                                ),
                                label:
                                'Listen ${index + 1}',
                                controller:
                                _controllerForOption(
                                  index,
                                ),
                                size:
                                50,
                              ),
                            )
                                : const Center(
                              child:
                              Icon(
                                Icons
                                    .broken_image_outlined,
                                size:
                                34,
                                color:
                                AppColors.textGrey,
                              ),
                            )
                                : GestureDetector(
                              onTap:
                                  () {
                                _showImagePreview(
                                  context,
                                  imagePath,
                                );
                              },
                              child:
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(
                                  12,
                                ),
                                child:
                                Container(
                                  width:
                                  double.infinity,
                                  color:
                                  AppColors.background,
                                  padding:
                                  const EdgeInsets.all(
                                    8,
                                  ),
                                  child:
                                  _quizImage(
                                    imagePath,
                                    fit:
                                    BoxFit.contain,
                                    errorBuilder:
                                        (
                                        context,
                                        error,
                                        stackTrace,
                                        ) {
                                      return const Center(
                                        child:
                                        Icon(
                                          Icons
                                              .broken_image_outlined,
                                          size:
                                          34,
                                          color:
                                          AppColors.textGrey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          if (hasAudioOption) ...[
                            const SizedBox(
                              height: 10,
                            ),
                            AudioPlayButton(
                              filePath:
                              question
                                  .optionAudioAt(
                                index,
                              )!,
                              isAsset:
                              _isBundledAsset(
                                question
                                    .optionAudioAt(
                                  index,
                                )!,
                              ),
                              label:
                              'Listen ${index + 1}',
                              controller:
                              _controllerForOption(
                                index,
                              ),
                              size: 46,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // OPTION NUMBER BADGE
  // ============================================================

  Widget _optionNumberBadge(
      int index, {
        required bool selected,
        bool onColoredBackground =
        false,
      }) {
    final Color background;
    final Color border;
    final Color text;

    if (onColoredBackground) {
      background = selected
          ? Colors.white
          : AppColors.background;

      border = selected
          ? Colors.white
          : AppColors.borderGrey;

      text = selected
          ? AppColors.primaryBlue
          : AppColors.textDark;
    } else {
      background = selected
          ? AppColors.primaryBlue
          : AppColors.background;

      border = selected
          ? AppColors.primaryBlue
          : AppColors.borderGrey;

      text = selected
          ? Colors.white
          : AppColors.textDark;
    }

    return Container(
      width: 34,
      height: 34,
      alignment:
      Alignment.center,
      decoration:
      BoxDecoration(
        shape:
        BoxShape.circle,
        color: background,
        border: Border.all(
          color: border,
          width: 1.5,
        ),
      ),
      child: Text(
        '${index + 1}',
        style: TextStyle(
          fontSize: 18,
          fontWeight:
          FontWeight.bold,
          color: text,
        ),
      ),
    );
  }

  // ============================================================
  // QUESTION NAVIGATOR
  // ============================================================

  void _showQuestionNavigator(
      BuildContext context,
      McqQuizController controller,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
      Colors.white,
      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(
            24,
          ),
        ),
      ),
      constraints:
      BoxConstraints(
        maxHeight:
        MediaQuery.of(
          context,
        ).size.height *
            0.85,
      ),
      builder: (
          sheetContext,
          ) {
        return SafeArea(
          child: Padding(
            padding:
            const EdgeInsets
                .fromLTRB(
              20,
              12,
              20,
              20,
            ),
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin:
                    const EdgeInsets
                        .only(
                      bottom: 16,
                    ),
                    decoration:
                    BoxDecoration(
                      color: AppColors
                          .borderGrey,
                      borderRadius:
                      BorderRadius
                          .circular(
                        4,
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Text(
                      'Jump to Question',
                      style:
                      GoogleFonts
                          .notoSansKr(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        AppColors
                            .textDark,
                      ),
                    ),

                    Obx(
                          () => Text(
                        '${controller.answeredCount}/${controller.totalQuestions} answered',
                        style:
                        GoogleFonts
                            .notoSansKr(
                          fontSize:
                          14.5,
                          fontWeight:
                          FontWeight.w600,
                          color:
                          AppColors
                              .textGrey,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                    height: 14),

                _buildNavigatorLegend(),

                const SizedBox(
                    height: 16),

                Flexible(
                  child:
                  SingleChildScrollView(
                    child: Builder(
                      builder:
                          (context) {
                        final totalQuestions =
                            controller
                                .totalQuestions;

                        final midpoint =
                        (totalQuestions /
                            2)
                            .ceil();

                        final readingCount =
                            midpoint;

                        final listeningCount =
                            totalQuestions -
                                midpoint;

                        return Row(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            // --------------------------------------
                            // READING
                            // --------------------------------------

                            Expanded(
                              child:
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Text(
                                    'Reading',
                                    style:
                                    GoogleFonts
                                        .notoSansKr(
                                      fontSize:
                                      16,
                                      fontWeight:
                                      FontWeight.w700,
                                      color:
                                      AppColors.textDark,
                                    ),
                                  ),

                                  const SizedBox(
                                    height:
                                    12,
                                  ),

                                  GridView.builder(
                                    shrinkWrap:
                                    true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemCount:
                                    readingCount,
                                    gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent:
                                      64,
                                      mainAxisSpacing:
                                      10,
                                      crossAxisSpacing:
                                      10,
                                      childAspectRatio:
                                      1,
                                    ),
                                    itemBuilder:
                                        (
                                        context,
                                        index,
                                        ) {
                                      return Obx(
                                            () {
                                          final isCurrent =
                                              controller.currentIndex.value ==
                                                  index;

                                          final answered =
                                          controller.isAnswered(
                                            index,
                                          );

                                          final Color background;
                                          final Color border;
                                          final Color text;

                                          if (isCurrent) {
                                            background =
                                                AppColors.primaryBlue;
                                            border =
                                                AppColors.primaryBlue;
                                            text =
                                                Colors.white;
                                          } else if (answered) {
                                            background =
                                                AppColors.primaryBlue.withOpacity(
                                                  0.1,
                                                );
                                            border =
                                                AppColors.primaryBlue.withOpacity(
                                                  0.4,
                                                );
                                            text =
                                                AppColors.primaryBlue;
                                          } else {
                                            background =
                                                Colors.white;
                                            border =
                                                AppColors.borderGrey;
                                            text =
                                                AppColors.textDark;
                                          }

                                          return GestureDetector(
                                            onTap:
                                                () {
                                              controller
                                                  .jumpToQuestion(
                                                index,
                                              );
                                              Get.back();
                                            },
                                            child:
                                            Container(
                                              alignment:
                                              Alignment.center,
                                              decoration:
                                              BoxDecoration(
                                                color:
                                                background,
                                                borderRadius:
                                                BorderRadius.circular(
                                                  10,
                                                ),
                                                border:
                                                Border.all(
                                                  color:
                                                  border,
                                                  width:
                                                  1.4,
                                                ),
                                              ),
                                              child:
                                              Text(
                                                '${index + 1}',
                                                style:
                                                TextStyle(
                                                  fontSize:
                                                  15,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color:
                                                  text,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                                width: 24),

                            // --------------------------------------
                            // LISTENING
                            // --------------------------------------

                            Expanded(
                              child:
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Text(
                                    'Listening',
                                    style:
                                    GoogleFonts
                                        .notoSansKr(
                                      fontSize:
                                      16,
                                      fontWeight:
                                      FontWeight.w700,
                                      color:
                                      AppColors.textDark,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                      12),

                                  GridView.builder(
                                    shrinkWrap:
                                    true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemCount:
                                    listeningCount,
                                    gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent:
                                      64,
                                      mainAxisSpacing:
                                      10,
                                      crossAxisSpacing:
                                      10,
                                      childAspectRatio:
                                      1,
                                    ),
                                    itemBuilder:
                                        (
                                        context,
                                        index,
                                        ) {
                                      final questionIndex =
                                          index +
                                              midpoint;

                                      return Obx(
                                            () {
                                          final isCurrent =
                                              controller.currentIndex.value ==
                                                  questionIndex;

                                          final answered =
                                          controller.isAnswered(
                                            questionIndex,
                                          );

                                          final Color background;
                                          final Color border;
                                          final Color text;

                                          if (isCurrent) {
                                            background =
                                                AppColors.primaryBlue;
                                            border =
                                                AppColors.primaryBlue;
                                            text =
                                                Colors.white;
                                          } else if (answered) {
                                            background =
                                                AppColors.primaryBlue.withOpacity(
                                                  0.1,
                                                );
                                            border =
                                                AppColors.primaryBlue.withOpacity(
                                                  0.4,
                                                );
                                            text =
                                                AppColors.primaryBlue;
                                          } else {
                                            background =
                                                Colors.white;
                                            border =
                                                AppColors.borderGrey;
                                            text =
                                                AppColors.textDark;
                                          }

                                          return GestureDetector(
                                            onTap:
                                                () {
                                              controller
                                                  .jumpToQuestion(
                                                questionIndex,
                                              );
                                              Get.back();
                                            },
                                            child:
                                            Container(
                                              alignment:
                                              Alignment.center,
                                              decoration:
                                              BoxDecoration(
                                                color:
                                                background,
                                                borderRadius:
                                                BorderRadius.circular(
                                                  10,
                                                ),
                                                border:
                                                Border.all(
                                                  color:
                                                  border,
                                                  width:
                                                  1.4,
                                                ),
                                              ),
                                              child:
                                              Text(
                                                '${questionIndex + 1}',
                                                style:
                                                TextStyle(
                                                  fontSize:
                                                  15,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color:
                                                  text,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(
                    height: 18),

                SizedBox(
                  width:
                  double.infinity,
                  height: 50,
                  child:
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _confirmSubmit(
                        context,
                        controller,
                      );
                    },
                    style:
                    ElevatedButton
                        .styleFrom(
                      backgroundColor:
                      AppColors
                          .primaryBlue,
                      foregroundColor:
                      Colors.white,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          12,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Submit and Finish Exam',
                      style:
                      GoogleFonts
                          .notoSansKr(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w700,
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

  // ============================================================
  // NAVIGATOR LEGEND
  // ============================================================

  Widget _buildNavigatorLegend() {
    return Row(
      children: [
        _legendDot(
          AppColors.primaryBlue,
          'Current',
        ),
        const SizedBox(width: 16),
        _legendDot(
          AppColors.primaryBlue
              .withOpacity(0.15),
          'Answered',
          borderColor:
          AppColors.primaryBlue
              .withOpacity(0.4),
        ),
        const SizedBox(width: 16),
        _legendDot(
          Colors.white,
          'Unanswered',
          borderColor:
          AppColors.borderGrey,
        ),
      ],
    );
  }

  Widget _legendDot(
      Color color,
      String label, {
        Color? borderColor,
      }) {
    return Row(
      mainAxisSize:
      MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration:
          BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color:
              borderColor ?? color,
            ),
          ),
        ),

        const SizedBox(width: 6),

        Text(
          label,
          style:
          GoogleFonts.notoSansKr(
            fontSize: 14,
            color:
            AppColors.textGrey,
            fontWeight:
            FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CONFIRM SUBMIT
  // ============================================================

  void _confirmSubmit(
      BuildContext context,
      McqQuizController controller,
      ) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                16,
              ),
            ),
            title: Text(
              'Submit Exam?',
              style:
              GoogleFonts.notoSansKr(
                fontWeight:
                FontWeight.w700,
              ),
            ),
            content: Obx(
                  () => Text(
                controller.answeredCount <
                    controller
                        .totalQuestions
                    ? 'You have answered ${controller.answeredCount} of ${controller.totalQuestions} questions. Unanswered questions will be marked wrong.'
                    : 'You have answered all questions. Submit now?',
                style:
                GoogleFonts.notoSansKr(
                  height: 1.5,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Get.back(),
                child: Text(
                  'Cancel',
                  style:
                  GoogleFonts
                      .notoSansKr(
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                style:
                ElevatedButton
                    .styleFrom(
                  backgroundColor:
                  AppColors
                      .primaryBlue,
                  foregroundColor:
                  Colors.white,
                ),
                onPressed: () {
                  Get.back();
                  controller
                      .submitExam();
                },
                child: Text(
                  'Submit',
                  style:
                  GoogleFonts
                      .notoSansKr(
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  // ============================================================
  // CONFIRM QUIT
  // ============================================================

  void _confirmQuit(
      BuildContext context,
      ) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                16,
              ),
            ),
            title: Text(
              'Quit Quiz?',
              style:
              GoogleFonts.notoSansKr(
                fontWeight:
                FontWeight.w700,
              ),
            ),
            content: Text(
              'Your progress on this attempt will be lost.',
              style:
              GoogleFonts.notoSansKr(
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Get.back(),
                child: Text(
                  'Cancel',
                  style:
                  GoogleFonts
                      .notoSansKr(
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                style:
                ElevatedButton
                    .styleFrom(
                  backgroundColor:
                  AppColors
                      .errorColor,
                  foregroundColor:
                  Colors.white,
                ),
                onPressed: () {
                  Get.back();

                  Get.until(
                        (route) =>
                    route.settings
                        .name ==
                        AppRoute.home,
                  );
                },
                child: Text(
                  'Quit',
                  style:
                  GoogleFonts
                      .notoSansKr(
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
