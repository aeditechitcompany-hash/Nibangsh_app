import '../../../common/models/quiz_models.dart';

class McqReviewItem {
  final QuizQuestion question;

  /// Index selected by the student.
  /// null = unanswered.
  final int? selectedIndex;

  /// Correct answer index.
  final int correctIndex;

  const McqReviewItem({
    required this.question,
    required this.selectedIndex,
    required this.correctIndex,
  });

  bool get isAnswered => selectedIndex != null;

  bool get isCorrect =>
      selectedIndex != null &&
          selectedIndex == correctIndex;
}