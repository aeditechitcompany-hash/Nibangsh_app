import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/models/mcq_model.dart';
import '../../../common/services/mcq_repository.dart';

class AdminMcqController extends GetxController {
  final McqRepository _repo = McqRepository.to;

  List<McqQuestion> get questions => _repo.questions;

  final questionController = TextEditingController();

  final optionControllers =
  List.generate(4, (_) => TextEditingController());

  final correctOptionIndex = Rx<int?>(null);

  final pickedAudioName = ''.obs;
  final pickedAudioPath = ''.obs;

  final questionImageName = ''.obs;
  final questionImagePath = ''.obs;

  final optionImageNames =
  RxList<String>.from(['', '', '', '']);

  final optionImagePaths =
  RxList<String>.from(['', '', '', '']);

  final optionAudioNames =
  RxList<String>.from(['', '', '', '']);

  final optionAudioPaths =
  RxList<String>.from(['', '', '', '']);

  final isPicking = false.obs;

  // The set the current add/edit sheet is scoped to.
  final selectedSet = ''.obs;

  // Set when editing an existing question instead of adding a new one.
  final editingQuestionId = Rxn<String>();

  bool get isEditing => editingQuestionId.value != null;

  bool get hasPickedAudio =>
      pickedAudioPath.value.isNotEmpty;

  bool get hasPickedQuestionImage =>
      questionImagePath.value.isNotEmpty;

  bool hasPickedOptionImage(int index) =>
      optionImagePaths[index].isNotEmpty;

  bool hasPickedOptionAudio(int index) =>
      optionAudioPaths[index].isNotEmpty;

  // ============================================================
  // QUESTION AUDIO
  // ============================================================

  Future<void> pickAudio() async {
    isPicking.value = true;

    try {
      final file = await FilePicker.pickFile(
        type: FileType.audio,
      );

      if (file == null) {
        return;
      }

      final path = file.path;

      if (path == null || path.isEmpty) {
        Get.snackbar(
          'Error',
          'Could not access that audio file on this device.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      pickedAudioName.value = file.name;
      pickedAudioPath.value = path;
    } catch (e) {
      debugPrint('Audio picker failed: $e');

      Get.snackbar(
        'Error',
        'Could not open the audio picker.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isPicking.value = false;
    }
  }

  // ============================================================
  // QUESTION IMAGE
  // ============================================================

  Future<void> pickQuestionImage() async {
    isPicking.value = true;

    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'webp',
        ],
      );

      if (file == null) {
        return;
      }

      final path = file.path;

      if (path == null || path.isEmpty) {
        Get.snackbar(
          'Error',
          'Could not access that image on this device.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      questionImageName.value = file.name;
      questionImagePath.value = path;
    } catch (e) {
      debugPrint('Question image picker failed: $e');

      Get.snackbar(
        'Error',
        'Could not open the image picker.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isPicking.value = false;
    }
  }

  void clearPickedQuestionImage() {
    questionImageName.value = '';
    questionImagePath.value = '';
  }

  void clearPickedAudio() {
    pickedAudioName.value = '';
    pickedAudioPath.value = '';
  }

  // ============================================================
  // OPTION IMAGE
  // ============================================================

  Future<void> pickOptionImage(int index) async {
    isPicking.value = true;

    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'webp',
        ],
      );

      if (file == null) {
        return;
      }

      final path = file.path;

      if (path == null || path.isEmpty) {
        Get.snackbar(
          'Error',
          'Could not access that image on this device.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      optionImageNames[index] = file.name;
      optionImagePaths[index] = path;
    } catch (e) {
      debugPrint('Option image picker failed: $e');

      Get.snackbar(
        'Error',
        'Could not open the image picker.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isPicking.value = false;
    }
  }

  void clearOptionImage(int index) {
    optionImageNames[index] = '';
    optionImagePaths[index] = '';
  }

  // ============================================================
  // OPTION AUDIO
  // ============================================================

  Future<void> pickOptionAudio(int index) async {
    isPicking.value = true;

    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: [
          'mp3',
          'wav',
          'm4a',
          'aac',
          'ogg',
        ],
      );

      if (file == null) {
        return;
      }

      final path = file.path;

      if (path == null || path.isEmpty) {
        Get.snackbar(
          'Error',
          'Could not access that audio file on this device.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      optionAudioNames[index] = file.name;
      optionAudioPaths[index] = path;
    } catch (e) {
      debugPrint('Option audio picker failed: $e');

      Get.snackbar(
        'Error',
        'Could not open the audio picker.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isPicking.value = false;
    }
  }

  void clearOptionAudio(int index) {
    optionAudioNames[index] = '';
    optionAudioPaths[index] = '';
  }

  // ============================================================
  // START ADD
  // ============================================================

  void startAdd({
    String? presetSetName,
  }) {
    editingQuestionId.value = null;

    selectedSet.value =
        presetSetName ?? '';

    questionController.clear();

    for (final controller in optionControllers) {
      controller.clear();
    }

    correctOptionIndex.value = null;

    clearPickedAudio();
    clearPickedQuestionImage();

    for (var i = 0; i < 4; i++) {
      clearOptionImage(i);
      clearOptionAudio(i);
    }
  }

  // ============================================================
  // START EDIT
  // ============================================================

  void startEdit(McqQuestion q) {
    editingQuestionId.value = q.id;

    selectedSet.value =
        q.setName ?? '';

    questionController.text =
        q.question;

    for (var i = 0;
    i < optionControllers.length;
    i++) {
      optionControllers[i].text =
      i < q.options.length
          ? q.options[i]
          : '';

      optionImageNames[i] =
      q.optionImagePaths != null &&
          i < q.optionImagePaths!.length
          ? q.optionImagePaths![i]
          .split('/')
          .last
          : '';

      optionImagePaths[i] =
      q.optionImagePaths != null &&
          i < q.optionImagePaths!.length
          ? q.optionImagePaths![i]
          : '';

      optionAudioNames[i] =
      q.optionAudioPaths != null &&
          i < q.optionAudioPaths!.length
          ? q.optionAudioPaths![i]
          .split('/')
          .last
          : '';

      optionAudioPaths[i] =
      q.optionAudioPaths != null &&
          i < q.optionAudioPaths!.length
          ? q.optionAudioPaths![i]
          : '';
    }

    correctOptionIndex.value =
        q.correctOptionIndex;

    // Existing question audio is preserved.
    pickedAudioName.value = '';
    pickedAudioPath.value = '';

    questionImageName.value =
        q.questionImagePath
            ?.split('/')
            .last ??
            '';

    questionImagePath.value =
        q.questionImagePath ?? '';
  }

  // ============================================================
  // SAVE QUESTION
  // ============================================================

  void saveQuestion() {
    final question =
    questionController.text.trim();

    final options = optionControllers
        .map((c) => c.text.trim())
        .toList();

    final editingId =
        editingQuestionId.value;

    final hasOptionMedia =
    List.generate(
      options.length,
          (i) =>
      optionImagePaths[i].isNotEmpty ||
          optionAudioPaths[i].isNotEmpty,
    );

    // ------------------------------------------------------------
    // Validate set
    // ------------------------------------------------------------

    if (editingId == null &&
        selectedSet.value.isEmpty) {
      Get.snackbar(
        'Missing Set',
        'Open this form from inside a set before adding an MCQ.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // ------------------------------------------------------------
    // Validate question
    // ------------------------------------------------------------

    if (question.isEmpty &&
        !hasPickedAudio &&
        questionImagePath.value.isEmpty) {
      Get.snackbar(
        'Missing info',
        'Add the question text, image, or audio first.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // ------------------------------------------------------------
    // Validate options
    // ------------------------------------------------------------

    if (options.asMap().entries.any((entry) {
      final i = entry.key;
      final text = entry.value.trim();

      return text.isEmpty &&
          !hasOptionMedia[i];
    })) {
      Get.snackbar(
        'Missing info',
        'Add text, image, or audio for all 4 options.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // ------------------------------------------------------------
    // Validate correct answer
    // ------------------------------------------------------------

    if (correctOptionIndex.value == null) {
      Get.snackbar(
        'Missing info',
        'Select which option is the correct answer.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // Keep indexes aligned with options.
    final optionImageList =
    List<String>.from(optionImagePaths);

    final optionAudioList =
    List<String>.from(optionAudioPaths);

    final hasAnyOptionImage =
    optionImageList.any(
          (path) => path.isNotEmpty,
    );

    final hasAnyOptionAudio =
    optionAudioList.any(
          (path) => path.isNotEmpty,
    );

    // ============================================================
    // EDIT EXISTING QUESTION
    // ============================================================

    if (editingId != null) {
      final existing =
      questions.firstWhereOrNull(
            (q) => q.id == editingId,
      );

      if (existing == null) {
        return;
      }

      _repo.updateQuestion(
        existing.copyWith(
          question: question,
          options: options,
          correctOptionIndex:
          correctOptionIndex.value!,

          audioFileName:
          hasPickedAudio
              ? pickedAudioName.value
              : existing.audioFileName,

          audioFilePath:
          hasPickedAudio
              ? pickedAudioPath.value
              : existing.audioFilePath,

          questionImagePath:
          hasPickedQuestionImage
              ? questionImagePath.value
              : existing.questionImagePath,

          optionImagePaths:
          hasAnyOptionImage
              ? optionImageList
              : null,

          optionAudioPaths:
          hasAnyOptionAudio
              ? optionAudioList
              : null,

          setName:
          existing.setName ??
              selectedSet.value,
        ),
      );

      Get.back();

      Get.snackbar(
        'Updated',
        'Changes are now visible to students.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor:
        const Color(0xFF16A34A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }

    // ============================================================
    // ADD NEW QUESTION
    // ============================================================

    else {
      _repo.addQuestion(
        McqQuestion(
          id: DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),

          question: question,

          options: options,

          correctOptionIndex:
          correctOptionIndex.value!,

          audioFileName:
          hasPickedAudio
              ? pickedAudioName.value
              : null,

          audioFilePath:
          hasPickedAudio
              ? pickedAudioPath.value
              : null,

          questionImagePath:
          questionImagePath.value.isNotEmpty
              ? questionImagePath.value
              : null,

          optionImagePaths:
          hasAnyOptionImage
              ? optionImageList
              : null,

          optionAudioPaths:
          hasAnyOptionAudio
              ? optionAudioList
              : null,

          setName:
          selectedSet.value,

          createdAt:
          DateTime.now(),
        ),
      );

      Get.back();

      Get.snackbar(
        'Added',
        'MCQ is now visible to students.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor:
        const Color(0xFF16A34A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }

    // ============================================================
    // RESET FORM
    // ============================================================

    questionController.clear();

    for (final controller in optionControllers) {
      controller.clear();
    }

    correctOptionIndex.value = null;

    clearPickedAudio();
    clearPickedQuestionImage();

    editingQuestionId.value = null;
  }

  // ============================================================
  // DELETE
  // ============================================================

  void deleteQuestion(String id) {
    _repo.removeQuestion(id);

    Get.snackbar(
      'Removed',
      'MCQ removed from the quiz.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    questionController.dispose();

    for (final controller in optionControllers) {
      controller.dispose();
    }

    super.onClose();
  }
}