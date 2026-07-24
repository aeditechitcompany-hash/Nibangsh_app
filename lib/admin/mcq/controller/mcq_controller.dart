import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/models/mcq_model.dart';
import '../../../common/services/mcq_repository.dart';

class AdminMcqController extends GetxController {
  final McqRepository _repo = McqRepository.to;

  List<McqQuestion> get questions => _repo.questions;

  final questionController = TextEditingController();
  final optionControllers = List.generate(4, (_) => TextEditingController());

  final correctOptionIndex = Rx<int?>(null);

  final pickedAudioName = ''.obs;
  final pickedAudioPath = ''.obs;
  final isPicking = false.obs;

  bool get hasPickedAudio => pickedAudioPath.value.isNotEmpty;

  Future<void> pickAudio() async {
    isPicking.value = true;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.single;
      if (file.path == null) {
        Get.snackbar(
          'Error',
          'Could not access that file on this device.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }
      pickedAudioName.value = file.name;
      pickedAudioPath.value = file.path!;
    } catch (e) {
      debugPrint('Audio picker failed: $e');
      Get.snackbar(
        'Error',
        'Could not open the file picker.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isPicking.value = false;
    }
  }

  void clearPickedAudio() {
    pickedAudioName.value = '';
    pickedAudioPath.value = '';
  }

  void clearForm() {
    questionController.clear();
    for (final c in optionControllers) {
      c.clear();
    }
    correctOptionIndex.value = null;
    clearPickedAudio();
  }

  void saveQuestion() {
    final question = questionController.text.trim();
    final options = optionControllers.map((c) => c.text.trim()).toList();

    if (question.isEmpty || options.any((o) => o.isEmpty)) {
      Get.snackbar(
        'Missing info',
        'Add the question and all 4 options first.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (correctOptionIndex.value == null) {
      Get.snackbar(
        'Missing info',
        'Select which option is the correct answer.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    _repo.addQuestion(
      McqQuestion(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        question: question,
        options: options,
        correctOptionIndex: correctOptionIndex.value!,
        audioFileName: hasPickedAudio ? pickedAudioName.value : null,
        audioFilePath: hasPickedAudio ? pickedAudioPath.value : null,
        createdAt: DateTime.now(),
      ),
    );

    clearForm();

    Get.back();
    Get.snackbar(
      'Added',
      'MCQ is now visible to students.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF16A34A),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  void deleteQuestion(String id) {
    _repo.removeQuestion(id);
    Get.snackbar(
      'Removed',
      'MCQ removed from the quiz.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    questionController.dispose();
    for (final c in optionControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
