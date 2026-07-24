import 'package:get/get.dart';
import '../../../common/models/mcq_model.dart';
import '../../../common/services/mcq_repository.dart';

class McqController extends GetxController {
  final McqRepository _repo = McqRepository.to;

  List<McqQuestion> get questions => _repo.questions;

  final currentIndex = 0.obs;
  final selectedAnswers = <String, int>{}.obs;
  final submitted = false.obs;

  McqQuestion? get currentQuestion =>
      questions.isEmpty ? null : questions[currentIndex.value];

  bool get isLastQuestion => currentIndex.value == questions.length - 1;
  bool get isFirstQuestion => currentIndex.value == 0;

  int? get selectedForCurrent =>
      currentQuestion == null ? null : selectedAnswers[currentQuestion!.id];

  int get score {
    int total = 0;
    for (final q in questions) {
      if (selectedAnswers[q.id] == q.correctOptionIndex) total++;
    }
    return total;
  }

  void selectOption(int optionIndex) {
    final q = currentQuestion;
    if (q == null || submitted.value) return;
    selectedAnswers[q.id] = optionIndex;
    selectedAnswers.refresh();
  }

  void nextQuestion() {
    if (!isLastQuestion) currentIndex.value++;
  }

  void previousQuestion() {
    if (!isFirstQuestion) currentIndex.value--;
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < questions.length) currentIndex.value = index;
  }

  void submitQuiz() {
    submitted.value = true;
  }

  void restartQuiz() {
    selectedAnswers.clear();
    currentIndex.value = 0;
    submitted.value = false;
  }
}
