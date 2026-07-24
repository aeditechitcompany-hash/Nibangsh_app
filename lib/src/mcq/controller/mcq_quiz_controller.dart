import 'package:get/get.dart';
import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_route.dart';
import 'mcq_home_controller.dart';

class McqQuizController extends GetxController {
  late final QuizSet quizSet;

  final currentIndex = 0.obs;
  final selectedAnswers = <int, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    quizSet = Get.arguments as QuizSet;
  }

  QuizQuestion get currentQuestion => quizSet.questions[currentIndex.value];
  int get totalQuestions => quizSet.questions.length;
  bool get isLastQuestion => currentIndex.value == totalQuestions - 1;
  bool get isFirstQuestion => currentIndex.value == 0;
  int? get selectedForCurrent => selectedAnswers[currentIndex.value];

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

  void _finish() {
    var score = 0;
    for (var i = 0; i < quizSet.questions.length; i++) {
      if (selectedAnswers[i] == quizSet.questions[i].correctIndex) score++;
    }

    if (Get.isRegistered<McqHomeController>()) {
      Get.find<McqHomeController>().recordScore(quizSet.id, score);
    }

    Get.offNamed(
      AppRoute.mcqResult,
      arguments: {'quizSet': quizSet, 'score': score},
    );
  }
}