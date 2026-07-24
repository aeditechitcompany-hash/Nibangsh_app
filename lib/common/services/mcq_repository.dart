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
  static McqRepository get to =>
      Get.isRegistered<McqRepository>()
          ? Get.find<McqRepository>()
          : Get.put(McqRepository(), permanent: true);

  final questions = <McqQuestion>[].obs;

  void addQuestion(McqQuestion question) => questions.insert(0, question);

  void removeQuestion(String id) =>
      questions.removeWhere((q) => q.id == id);
}
