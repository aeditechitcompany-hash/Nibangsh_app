import 'package:get/get.dart';
import '../models/mcq_model.dart';

// Shared store for admin-created MCQs, so a question the admin adds
// instantly shows up on the student's MCQ screen.
//
// NOTE: this is in-memory/local, matching the rest of this app's mock data
// (no backend yet). It works great for demoing on one device/simulator. To
// make MCQs actually appear on a *different* student's phone than the one
// the admin created them from, this repository should fetch/save from a
// real backend (e.g. Firebase Firestore) instead, and the audio file itself
// needs to live somewhere all devices can reach (e.g. Firebase Storage).
class McqRepository extends GetxService {
  static McqRepository get to => Get.isRegistered<McqRepository>()
      ? Get.find<McqRepository>()
      : Get.put(McqRepository(), permanent: true);

  final questions = <McqQuestion>[].obs;

  void addQuestion(McqQuestion question) {
    questions.add(question);
    _sortQuestions();
  }

  void updateQuestion(McqQuestion updated) {
    final index = questions.indexWhere((q) => q.id == updated.id);
    if (index != -1) {
      questions[index] = updated;
      _sortQuestions();
    }
  }

  void removeQuestion(String id) => questions.removeWhere((q) => q.id == id);

  void _sortQuestions() {
    questions.sort((a, b) {
      final createdAtOrder = a.createdAt.compareTo(b.createdAt);
      if (createdAtOrder != 0) return createdAtOrder;
      return a.id.compareTo(b.id);
    });
  }
}
