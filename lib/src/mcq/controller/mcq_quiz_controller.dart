import 'dart:async';
import 'package:get/get.dart';
import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_route.dart';
import 'mcq_home_controller.dart';

class McqQuizController extends GetxController {
  static const int quizDurationSeconds = 5 * 60;

  late final QuizSet quizSet;

  final currentIndex = 0.obs;
  final selectedAnswers = <int, int>{}.obs;

  final remainingSeconds = quizDurationSeconds.obs;

  Timer? _timer;
  bool _finished = false;

  @override
  void onInit() {
    super.onInit();
    quizSet = Get.arguments as QuizSet;
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  QuizQuestion get currentQuestion => quizSet.questions[currentIndex.value];
  int get totalQuestions => quizSet.questions.length;
  bool get isLastQuestion => currentIndex.value == totalQuestions - 1;
  bool get isFirstQuestion => currentIndex.value == 0;
  int? get selectedForCurrent => selectedAnswers[currentIndex.value];

  String get formattedTime {
    final minutes = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool get isTimeRunningLow => remainingSeconds.value <= 30;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value <= 1) {
        remainingSeconds.value = 0;
        timer.cancel();
        _finish(timeUp: true);
      } else {
        remainingSeconds.value--;
      }
    });
  }

  void selectOption(int optionIndex) {
    selectedAnswers[currentIndex.value] = optionIndex;
  }

  void goPrevious() {
    if (!isFirstQuestion) currentIndex.value--;
  }

  void goNextOrFinish() {
    if (isLastQuestion) {
      _finish();
    } else {
      currentIndex.value++;
    }
  }

  void _finish({bool timeUp = false}) {
    if (_finished) return;
    _finished = true;
    _timer?.cancel();

    var score = 0;
    for (var i = 0; i < quizSet.questions.length; i++) {
      if (selectedAnswers[i] == quizSet.questions[i].correctIndex) score++;
    }

    if (Get.isRegistered<McqHomeController>()) {
      Get.find<McqHomeController>().recordScore(quizSet.id, score);
    }

    Get.offNamed(
      AppRoute.mcqResult,
      arguments: {'quizSet': quizSet, 'score': score, 'timeUp': timeUp},
    );
  }
}