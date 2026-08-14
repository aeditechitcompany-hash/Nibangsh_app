import 'dart:async';

import 'package:get/get.dart';

import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_route.dart';
import '../../../common/api_services/api_service.dart';
import '../../../common/api_services/api_constants.dart';

import 'mcq_home_controller.dart';

class McqQuizController extends GetxController {
  // ============================================================
  // QUIZ SETTINGS
  // ============================================================

  static const int quizDurationSeconds = 50 * 60;

  late final QuizSet quizSet;

  // ============================================================
  // API
  // ============================================================

  final ApiService _apiService = const ApiService();

  // ============================================================
  // QUIZ STATE
  // ============================================================

  final currentIndex = 0.obs;

  final selectedAnswers = <int, int>{}.obs;

  final remainingSeconds = quizDurationSeconds.obs;

  Timer? _timer;

  bool _finished = false;

  // ============================================================
  // INITIALIZATION
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments is QuizSet) {
      quizSet = arguments;
    } else {
      // Safety fallback.
      Get.back();
      return;
    }

    _startTimer();
  }

  // ============================================================
  // CLEANUP
  // ============================================================

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // ============================================================
  // CURRENT QUESTION
  // ============================================================

  QuizQuestion get currentQuestion {
    return quizSet.questions[currentIndex.value];
  }

  int get totalQuestions {
    return quizSet.questions.length;
  }

  bool get isLastQuestion {
    return currentIndex.value == totalQuestions - 1;
  }

  bool get isFirstQuestion {
    return currentIndex.value == 0;
  }

  int? get selectedForCurrent {
    return selectedAnswers[currentIndex.value];
  }

  int get answeredCount {
    return selectedAnswers.length;
  }

  bool isAnswered(int questionIndex) {
    return selectedAnswers.containsKey(questionIndex);
  }

  // ============================================================
  // TIMER
  // ============================================================

  String get formattedTime {
    final minutes =
        (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');

    final seconds =
        (remainingSeconds.value % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  bool get isTimeRunningLow {
    return remainingSeconds.value <= 30;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (remainingSeconds.value <= 1) {
          remainingSeconds.value = 0;

          timer.cancel();

          _finish(timeUp: true);
        } else {
          remainingSeconds.value--;
        }
      },
    );
  }

  // ============================================================
  // ANSWER SELECTION
  // ============================================================

  void selectOption(int optionIndex) {
    selectedAnswers[currentIndex.value] = optionIndex;

    // Make sure Obx widgets listening to selectedAnswers rebuild.
    selectedAnswers.refresh();
  }

  // ============================================================
  // QUESTION NAVIGATION
  // ============================================================

  void goPrevious() {
    if (!isFirstQuestion) {
      currentIndex.value--;
    }
  }

  void goNextOrFinish() {
    if (isLastQuestion) {
      _finish();
    } else {
      currentIndex.value++;
    }
  }

  void jumpToQuestion(int index) {
    if (index >= 0 && index < totalQuestions) {
      currentIndex.value = index;
    }
  }

  // ============================================================
  // SUBMIT EXAM
  // ============================================================

  void submitExam() {
    _finish();
  }

  // ============================================================
  // FINISH QUIZ
  // ============================================================

  Future<void> _finish({
    bool timeUp = false,
  }) async {
    if (_finished) {
      return;
    }

    _finished = true;

    _timer?.cancel();

    // ==========================================================
    // CALCULATE SCORE
    // ==========================================================

    var score = 0;

    for (var i = 0; i < quizSet.questions.length; i++) {
      final selectedAnswer = selectedAnswers[i];

      final correctAnswer =
          quizSet.questions[i].correctIndex;

      if (selectedAnswer == correctAnswer) {
        score++;
      }
    }

    // ==========================================================
    // SAVE BEST SCORE LOCALLY
    // ==========================================================

    if (Get.isRegistered<McqHomeController>()) {
      Get.find<McqHomeController>().recordScore(
        quizSet.id,
        score,
      );
    }

    // ==========================================================
    // GO TO RESULT SCREEN
    // ==========================================================

    Get.offNamed(
      AppRoute.mcqResult,
      arguments: {
        'quizSet': quizSet,
        'score': score,
        'timeUp': timeUp,
      },
    );
  }
}