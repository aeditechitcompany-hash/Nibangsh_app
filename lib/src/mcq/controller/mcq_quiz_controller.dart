import 'dart:async';

import 'package:get/get.dart';

import '../../../common/api_services/mcq_service.dart';
import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_route.dart';
import 'mcq_home_controller.dart';

class McqQuizController extends GetxController {
  // QUIZ SETTINGS
  static const int quizDurationSeconds = 50 * 60;
  late final QuizSet quizSet;

  // API
  final McqService _mcqService = McqService();

  // QUIZ STATE
  final currentIndex = 0.obs;
  final selectedAnswers = <int, int>{}.obs;
  int? attemptId;
  final remainingSeconds = quizDurationSeconds.obs;
  Timer? _timer;
  bool _finished = false;
  bool _startingAttempt = true;

  // INITIALIZATION
  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments is QuizSet) {
      quizSet = arguments;
    } else {
      Get.back();
      return;
    }

    _initializeQuiz();
  }

  Future<void> _initializeQuiz() async {
    try {
      await _startAttempt();

      // Only start the timer after the backend successfully creates the attempt.
      _startTimer();
    } catch (e) {
      Get.snackbar(
        'Quiz Error',
        'Could not start the quiz: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _startingAttempt = false;
    }
  }

  // CLEANUP
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // CURRENT QUESTION
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

  // TIMER
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

  // ANSWER SELECTION
  Future<void> selectOption(int optionIndex) async {
    // Don't allow an answer before the backend attempt exists.
    if (_startingAttempt || attemptId == null) {
      Get.snackbar(
        'Please wait',
        'The quiz is still being initialized.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    selectedAnswers[currentIndex.value] = optionIndex;

    final question = currentQuestion;

    // Get the actual option ID from the backend
    final quizOptions = question.quizOptions;
    
    if (quizOptions.isEmpty || optionIndex >= quizOptions.length) {
      Get.snackbar(
        'Error',
        'Invalid option selected.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final selectedOptionId = quizOptions[optionIndex].id;

    if (selectedOptionId == null) {
      Get.snackbar(
        'Error',
        'Option ID is missing from the backend.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await _mcqService.submitAnswer(
        attemptId: attemptId!,
        questionId: int.parse(question.id.toString()),
        selectedOptionId: int.parse(selectedOptionId),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not save your answer',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // QUESTION NAVIGATION
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

  // SUBMIT EXAM
  void submitExam() {
    _finish();
  }

  // START ATTEMPT
  Future<void> _startAttempt() async {
    final response = await _mcqService.createAttempt(
      questionSetId: quizSet.id,
    );

    final idValue = response['id'];
    
    if (idValue == null) {
      throw Exception('Backend did not return an attempt ID.');
    }

    attemptId = int.tryParse(idValue.toString());

    if (attemptId == null) {
      throw Exception(
        'Invalid attempt ID from backend: $idValue',
      );
    }
  }

  // FINISH QUIZ
  Future<void> _finish({
    bool timeUp = false,
  }) async {
    if (_finished) return;

    if (attemptId == null) {
      Get.snackbar(
        'Error',
        'Quiz attempt was not created.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _finished = true;

    _timer?.cancel();

    try {
      final result = await _mcqService.finishAttempt(
        attemptId: attemptId!,
      );

      final score =
          double.tryParse(
                result['score']?.toString() ?? '0',
              )?.round() ??
              0;

      final maxScore =
          double.tryParse(
                result['max_score']?.toString() ?? '0',
              )?.round() ??
              0;

      final percentage =
          double.tryParse(
                result['percentage']?.toString() ?? '0',
              ) ??
              0.0;

      final passed =
          result['passed'] == true;

      // Record the score in the home controller
      // so the score ring updates on the home screen
      try {
        final homeController = Get.find<McqHomeController>();
        homeController.recordScore(quizSet.id, score.toInt());
      } catch (e) {
        print('Could not record score: $e');
      }

      // SEND DATABASE RESULT TO RESULT SCREEN
      Get.offNamed(
        AppRoute.mcqResult,
        arguments: {
          'quizSet': quizSet,

          // Score calculated by Django
          'score': score,

          // Maximum score calculated by Django
          'maxScore': maxScore,

          // Percentage calculated by Django
          'percentage': percentage,

          // Passed calculated by Django
          'passed': passed,

          'timeUp': timeUp,
        },
      );
    } catch (e) {
      _finished = false;

      Get.snackbar(
        'Error',
        'Could not submit the quiz: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}