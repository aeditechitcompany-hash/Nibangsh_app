import 'dart:async';

import 'package:get/get.dart';

import '../../../common/api_services/mcq_service.dart';
import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_route.dart';
import 'mcq_home_controller.dart';

class McqQuizController extends GetxController {
  static const int quizDurationSeconds = 50 * 60;

  late final QuizSet quizSet;

  final McqService _mcqService = McqService();

  // ============================================================
  // CURRENT QUESTION
  // ============================================================

  final currentIndex = 0.obs;

  // ============================================================
  // SELECTED ANSWERS
  //
  // question index -> selected option index
  //
  // Example:
  // {
  //   0: 2,
  //   1: 0,
  //   2: 1,
  // }
  // ============================================================

  final selectedAnswers = <int, int>{}.obs;

  // ============================================================
  // ANSWER SUBMISSION STATE
  // ============================================================

  final isSubmittingAnswer = false.obs;

  // ============================================================
  // BACKEND ATTEMPT ID
  // ============================================================

  int? attemptId;

  // ============================================================
  // TIMER
  // ============================================================

  final remainingSeconds = quizDurationSeconds.obs;

  Timer? _timer;

  bool _finished = false;

  bool _startingAttempt = true;

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
      Get.back();
      return;
    }

    _initializeQuiz();
  }

  Future<void> _initializeQuiz() async {
    try {
      await _startAttempt();

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

  // ============================================================
  // CURRENT SELECTED OPTION
  // ============================================================

  int? get selectedForCurrent {
    return selectedAnswers[currentIndex.value];
  }

  // ============================================================
  // ANSWER COUNT
  // ============================================================

  int get answeredCount {
    return selectedAnswers.length;
  }

  bool isAnswered(int questionIndex) {
    return selectedAnswers.containsKey(questionIndex);
  }

  // ============================================================
  // TIME FORMATTING
  // ============================================================

  String get formattedTime {
    final minutes = (remainingSeconds.value ~/ 60)
        .toString()
        .padLeft(2, '0');

    final seconds = (remainingSeconds.value % 60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  bool get isTimeRunningLow {
    return remainingSeconds.value <= 30;
  }

  // ============================================================
  // START TIMER
  // ============================================================

  void _startTimer() {
    _timer?.cancel();


  }

  // ============================================================
  // SELECT OPTION
  // ============================================================

  Future<void> selectOption(int optionIndex) async {
    if (isSubmittingAnswer.value) {
      return;
    }

    if (_startingAttempt || attemptId == null) {
      Get.snackbar(
        'Please wait',
        'The quiz is still being initialized.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    final question = currentQuestion;

    final quizOptions = question.quizOptions;

    // ============================================================
    // VALIDATE OPTION
    // ============================================================

    if (quizOptions.isEmpty ||
        optionIndex < 0 ||
        optionIndex >= quizOptions.length) {
      Get.snackbar(
        'Error',
        'Invalid option selected.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    final selectedOption = quizOptions[optionIndex];

    final selectedOptionId = selectedOption.id;

    if (selectedOptionId == null) {
      Get.snackbar(
        'Error',
        'Option ID is missing from the backend.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // ============================================================
    // SAVE PREVIOUS VALUE
    // ============================================================

    final previousSelection =
    selectedAnswers[currentIndex.value];

    // ============================================================
    // SAVE LOCALLY FIRST
    // ============================================================

    selectedAnswers[currentIndex.value] = optionIndex;

    isSubmittingAnswer.value = true;

    try {
      // ============================================================
      // SAVE TO BACKEND
      // ============================================================

      await _mcqService.submitAnswer(
        attemptId: attemptId!,
        questionId: int.parse(
          question.id.toString(),
        ),
        selectedOptionId: int.parse(
          selectedOptionId.toString(),
        ),
      );
    } catch (e) {
      // ============================================================
      // RESTORE PREVIOUS VALUE IF API FAILED
      // ============================================================

      if (previousSelection == null) {
        selectedAnswers.remove(
          currentIndex.value,
        );
      } else {
        selectedAnswers[currentIndex.value] =
            previousSelection;
      }

      Get.snackbar(
        'Error',
        'Could not save your answer.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmittingAnswer.value = false;
    }
  }

  // ============================================================
  // PREVIOUS QUESTION
  // ============================================================

  void goPrevious() {
    if (!isFirstQuestion) {
      currentIndex.value--;
    }
  }

  // ============================================================
  // NEXT QUESTION / FINISH
  // ============================================================

  void goNextOrFinish() {
    if (isSubmittingAnswer.value) {
      return;
    }

    if (isLastQuestion) {
      _finish();
    } else {
      currentIndex.value++;
    }
  }

  // ============================================================
  // COMPATIBILITY METHOD
  //
  // If any old part of your quiz screen still calls goNext(),
  // this prevents:
  //
  // "The getter 'goNext' isn't defined..."
  //
  // ============================================================

  void goNext() {
    goNextOrFinish();
  }

  // ============================================================
  // JUMP TO QUESTION
  // ============================================================

  void jumpToQuestion(int index) {
    if (index >= 0 && index < totalQuestions) {
      currentIndex.value = index;
    }
  }

  // ============================================================
  // SUBMIT EXAM BUTTON
  // ============================================================

  void submitExam() {
    if (isSubmittingAnswer.value) {
      Get.snackbar(
        'Please wait',
        'Your last answer is still being saved.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    _finish();
  }

  // ============================================================
  // CREATE ATTEMPT
  // ============================================================

  Future<void> _startAttempt() async {
    final response = await _mcqService.createAttempt(
      questionSetId: quizSet.id,
    );

    final idValue = response['id'];

    if (idValue == null) {
      throw Exception(
        'Backend did not return an attempt ID.',
      );
    }

    attemptId = int.tryParse(
      idValue.toString(),
    );

    if (attemptId == null) {
      throw Exception(
        'Invalid attempt ID from backend: $idValue',
      );
    }
  }

  // ============================================================
  // FINISH QUIZ
  // ============================================================

  Future<void> _finish({
    bool timeUp = false,
  }) async {
    // Prevent duplicate submissions
    if (_finished) {
      return;
    }

    // Don't finish while an answer is being saved
    if (isSubmittingAnswer.value) {
      return;
    }

    if (attemptId == null) {
      Get.snackbar(
        'Error',
        'Quiz attempt was not created.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    _finished = true;

    // Stop timer
    _timer?.cancel();

    try {
      // ============================================================
      // FINISH BACKEND ATTEMPT
      // ============================================================

      final result = await _mcqService.finishAttempt(
        attemptId: attemptId!,
      );

      // ============================================================
      // SCORE
      // ============================================================

      final attemptData =
      result['attempt'] is Map
          ? Map<String, dynamic>.from(result['attempt'])
          : <String, dynamic>{};

      final score =
          double.tryParse(
            attemptData['score']?.toString() ?? '0',
          )?.round() ??
              0;

      final maxScore =
          double.tryParse(
            attemptData['max_score']?.toString() ?? '0',
          )?.round() ??
              quizSet.totalQuestions;

      final percentage =
          double.tryParse(
            attemptData['percentage']?.toString() ?? '0',
          ) ??
              0.0;

      final passedValue = attemptData['passed'];

      final bool passed =
          passedValue == true ||
              passedValue.toString().toLowerCase() == 'true';

      // ============================================================
      // ATTEMPTED QUESTIONS
      // ============================================================

      final int attemptedQuestions = selectedAnswers.length;

      // ============================================================
      // CONVERT SELECTED ANSWERS TO LIST
      //
      // Example:
      //
      // [2, 0, null, 1]
      //
      // ============================================================

      final List<int?> selectedAnswersList =
      List<int?>.generate(
        quizSet.questions.length,
            (index) {
          return selectedAnswers[index];
        },
      );

      // ============================================================
      // GET CORRECT ANSWERS FROM BACKEND
      // ============================================================

      final List<int> correctAnswersList =
      _extractCorrectAnswers(result);

      // ============================================================
      // DEBUG
      // ============================================================

      print('========================================');
      print('MCQ FINISHED');
      print('Selected answers: $selectedAnswersList');
      print('Correct answers: $correctAnswersList');
      print('Attempted: $attemptedQuestions');
      print('Score: $score');
      print('Max score: $maxScore');
      print('Percentage: $percentage');
      print('Passed: $passed');
      print('Time up: $timeUp');
      print('========================================');

      // ============================================================
      // SAVE SCORE LOCALLY
      // ============================================================

      try {
        final homeController =
        Get.find<McqHomeController>();

        homeController.recordScore(
          quizSet.id,
          score,
        );
      } catch (e) {
        print(
          'Could not record score: $e',
        );
      }

      // ============================================================
      // GO TO RESULT SCREEN
      // ============================================================

      Get.offNamed(
        AppRoute.mcqResult,
        arguments: {
          // Quiz
          'quizSet': quizSet,

          // Score
          'score': score,

          // IMPORTANT:
          // Your result screen reads totalQuestions.
          'totalQuestions': maxScore,

          // IMPORTANT:
          // Your result screen reads answeredCount.
          'answeredCount': attemptedQuestions,

          // Percentage
          'percentage': percentage,

          // Pass/fail
          'passed': passed,

          // Time
          'timeUp': timeUp,

          // Student selected answers
          'selectedAnswers': selectedAnswersList,

          // Correct answers from Django
          'correctAnswers': correctAnswersList,
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

  // ============================================================
  // EXTRACT CORRECT ANSWER INDEXES
  // ============================================================
  //
  // Backend:
  //
  // question_results: [
  //   {
  //     question_id: 1,
  //     selected_option_id: 5,
  //     correct_option_id: 6,
  //     is_correct: false
  //   }
  // ]
  //
  // Flutter converts correct_option_id
  // into the option INDEX used by the UI.
  //
  // ============================================================

  List<int> _extractCorrectAnswers(
      Map<String, dynamic> result,
      ) {
    final List<int> correctIndexes =
    List<int>.filled(
      quizSet.questions.length,
      -1,
    );

    final rawResults =
    result['question_results'];

    if (rawResults is! List) {
      print(
        'WARNING: question_results missing from backend.',
      );

      return correctIndexes;
    }

    for (final rawResult in rawResults) {
      if (rawResult is! Map) {
        continue;
      }

      // ============================================================
      // QUESTION ID
      // ============================================================

      final questionId =
      int.tryParse(
        rawResult['question_id']?.toString() ?? '',
      );

      if (questionId == null) {
        continue;
      }

      // ============================================================
      // CORRECT OPTION ID
      // ============================================================

      final correctOptionId =
      int.tryParse(
        rawResult['correct_option_id']?.toString() ?? '',
      );

      if (correctOptionId == null) {
        continue;
      }

      // ============================================================
      // FIND QUESTION INDEX
      // ============================================================

      final questionIndex =
      quizSet.questions.indexWhere(
            (question) {
          final id =
          int.tryParse(
            question.id.toString(),
          );

          return id == questionId;
        },
      );

      if (questionIndex == -1) {
        print(
          'WARNING: Question $questionId '
              'was not found in quizSet.',
        );

        continue;
      }

      // ============================================================
      // FIND CORRECT OPTION INDEX
      // ============================================================

      final question =
      quizSet.questions[questionIndex];

      final optionIndex =
      question.quizOptions.indexWhere(
            (option) {
          final optionId =
          int.tryParse(
            option.id.toString(),
          );

          return optionId == correctOptionId;
        },
      );

      if (optionIndex == -1) {
        print(
          'WARNING: Correct option '
              '$correctOptionId was not found '
              'for question $questionId.',
        );

        continue;
      }

      // ============================================================
      // SAVE CORRECT INDEX
      // ============================================================

      correctIndexes[questionIndex] =
          optionIndex;
    }

    return correctIndexes;
  }
}