import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/api_services/api_constants.dart';
import '../../../common/api_services/api_service.dart';
import '../../../common/models/mcq_model.dart';
import '../../../common/services/mcq_repository.dart';

class AdminMcqController extends GetxController {
  final McqRepository _repo = McqRepository.to;
  final ApiService _api = const ApiService();

  // ============================================================
  // DATA
  // ============================================================

  List<McqQuestion> get questions => _repo.questions;

  final isLoadingQuestions = false.obs;

  // ============================================================
  // FORM
  // ============================================================

  final questionController = TextEditingController();

  final optionControllers =
  List.generate(4, (_) => TextEditingController());

  final correctOptionIndex = Rx<int?>(null);

  // ============================================================
  // QUESTION AUDIO
  // ============================================================

  final pickedAudioName = ''.obs;
  final pickedAudioPath = ''.obs;

  // ============================================================
  // QUESTION IMAGE
  // ============================================================

  final questionImageName = ''.obs;
  final questionImagePath = ''.obs;

  // ============================================================
  // OPTION IMAGES
  // ============================================================

  final optionImageNames =
  RxList<String>.from(['', '', '', '']);

  final optionImagePaths =
  RxList<String>.from(['', '', '', '']);

  // ============================================================
  // OPTION AUDIO
  // ============================================================

  final optionAudioNames =
  RxList<String>.from(['', '', '', '']);

  final optionAudioPaths =
  RxList<String>.from(['', '', '', '']);

  // ============================================================
  // FILE PICKING
  // ============================================================

  final isPicking = false.obs;

  // ============================================================
  // CURRENT SET
  // ============================================================

  final selectedSet = ''.obs;

  // ============================================================
  // EDITING
  // ============================================================

  final editingQuestionId = Rxn<String>();

  bool get isEditing =>
      editingQuestionId.value != null;

  bool get hasPickedAudio =>
      pickedAudioPath.value.isNotEmpty;

  bool get hasPickedQuestionImage =>
      questionImagePath.value.isNotEmpty;

  bool hasPickedOptionImage(int index) =>
      optionImagePaths[index].isNotEmpty;

  bool hasPickedOptionAudio(int index) =>
      optionAudioPaths[index].isNotEmpty;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    loadAdminMcqs();
  }

  // ============================================================
  // LOAD ALL ADMIN MCQS
  // ============================================================

  Future<void> loadAdminMcqs() async {
    try {
      isLoadingQuestions.value = true;

      debugPrint('====================================');
      debugPrint('LOADING ADMIN MCQS');
      debugPrint('====================================');

      final questionSets =
      await _repo.fetchQuestionSets();

      final allQuestions = <McqQuestion>[];

      debugPrint(
        'QUESTION SETS FOUND: ${questionSets.length}',
      );

      // ----------------------------------------------------------
      // The list endpoint only gives question-set metadata.
      //
      // Therefore we must retrieve each question set individually
      // to get:
      //
      // questions
      // options
      // is_correct
      // explanation
      // ----------------------------------------------------------

      for (final set in questionSets) {
        final setId =
        set['id']?.toString();

        if (setId == null ||
            setId.isEmpty) {
          continue;
        }

        debugPrint(
          'Loading question set: $setId',
        );

        final detail =
        await _repo.fetchAdminQuestionSet(
          setId,
        );

        if (detail == null) {
          debugPrint(
            'Could not load question set: $setId',
          );
          continue;
        }

        final setQuestions =
        _repo.questionsFromBackend(
          detail,
          admin: true,
        );

        debugPrint(
          'SET "${detail['title']}" '
              'QUESTIONS: ${setQuestions.length}',
        );

        allQuestions.addAll(
          setQuestions,
        );
      }

      _repo.setQuestions(
        allQuestions,
      );

      debugPrint(
        'TOTAL ADMIN QUESTIONS: '
            '${allQuestions.length}',
      );

      debugPrint('====================================');
    } catch (e, stackTrace) {
      debugPrint(
        'LOAD ADMIN MCQS ERROR: $e',
      );

      debugPrint(
        stackTrace.toString(),
      );

      Get.snackbar(
        'Error',
        'Could not load MCQs from server.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoadingQuestions.value = false;
    }
  }

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

      if (path == null ||
          path.isEmpty) {
        Get.snackbar(
          'Error',
          'Could not access that audio file.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      pickedAudioName.value = file.name;
      pickedAudioPath.value = path;
    } catch (e) {
      debugPrint(
        'Audio picker failed: $e',
      );

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

  void clearPickedAudio() {
    pickedAudioName.value = '';
    pickedAudioPath.value = '';
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

      if (path == null ||
          path.isEmpty) {
        Get.snackbar(
          'Error',
          'Could not access that image.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      questionImageName.value =
          file.name;

      questionImagePath.value =
          path;
    } catch (e) {
      debugPrint(
        'Question image picker failed: $e',
      );

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

  // ============================================================
  // OPTION IMAGE
  // ============================================================

  Future<void> pickOptionImage(
      int index,
      ) async {
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

      if (path == null ||
          path.isEmpty) {
        Get.snackbar(
          'Error',
          'Could not access that image.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      optionImageNames[index] =
          file.name;

      optionImagePaths[index] =
          path;
    } catch (e) {
      debugPrint(
        'Option image picker failed: $e',
      );

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

  void clearOptionImage(
      int index,
      ) {
    optionImageNames[index] = '';
    optionImagePaths[index] = '';
  }

  // ============================================================
  // OPTION AUDIO
  // ============================================================

  Future<void> pickOptionAudio(
      int index,
      ) async {
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

      if (path == null ||
          path.isEmpty) {
        Get.snackbar(
          'Error',
          'Could not access that audio file.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      optionAudioNames[index] =
          file.name;

      optionAudioPaths[index] =
          path;
    } catch (e) {
      debugPrint(
        'Option audio picker failed: $e',
      );

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

  void clearOptionAudio(
      int index,
      ) {
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

    for (final controller
    in optionControllers) {
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

  void startEdit(
      McqQuestion q,
      ) {
    editingQuestionId.value =
        q.id;

    selectedSet.value =
        q.setName ?? '';

    questionController.text =
        q.question;

    // ----------------------------------------------------------
    // QUESTION IMAGE
    // ----------------------------------------------------------

    questionImagePath.value =
        q.questionImagePath ?? '';

    questionImageName.value =
        q.questionImagePath
            ?.split('/')
            .last ??
            '';

    // ----------------------------------------------------------
    // QUESTION AUDIO
    // ----------------------------------------------------------

    // Do NOT put an existing remote URL into pickedAudioPath.
    //
    // pickedAudioPath is specifically for a NEW local file.
    //
    // Existing server audio is preserved by the model.
    pickedAudioName.value = '';
    pickedAudioPath.value = '';

    // ----------------------------------------------------------
    // OPTIONS
    // ----------------------------------------------------------

    for (
    var i = 0;
    i < optionControllers.length;
    i++
    ) {
      optionControllers[i].text =
      i < q.options.length
          ? q.options[i]
          : '';

      // Option image
      if (q.optionImagePaths != null &&
          i < q.optionImagePaths!.length) {
        optionImagePaths[i] =
        q.optionImagePaths![i];

        optionImageNames[i] =
            q.optionImagePaths![i]
                .split('/')
                .last;
      } else {
        optionImagePaths[i] = '';
        optionImageNames[i] = '';
      }

      // Option audio
      if (q.optionAudioPaths != null &&
          i < q.optionAudioPaths!.length) {
        optionAudioPaths[i] =
        q.optionAudioPaths![i];

        optionAudioNames[i] =
            q.optionAudioPaths![i]
                .split('/')
                .last;
      } else {
        optionAudioPaths[i] = '';
        optionAudioNames[i] = '';
      }
    }

    correctOptionIndex.value =
        q.correctOptionIndex;
  }

  // ============================================================
  // SAVE QUESTION
  // ============================================================

  Future<void> saveQuestion() async {
    final question =
    questionController.text.trim();

    final options = optionControllers
        .map(
          (controller) =>
          controller.text.trim(),
    )
        .toList();

    final editingId =
        editingQuestionId.value;

    // ----------------------------------------------------------
    // VALIDATE SET
    // ----------------------------------------------------------

    if (editingId == null &&
        selectedSet.value.isEmpty) {
      Get.snackbar(
        'Missing Set',
        'Open this form from inside a question set.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // ----------------------------------------------------------
    // VALIDATE QUESTION
    // ----------------------------------------------------------

    final hasQuestionImage =
        questionImagePath.value.isNotEmpty;

    final hasQuestionAudio =
        pickedAudioPath.value.isNotEmpty;

    if (question.isEmpty &&
        !hasQuestionImage &&
        !hasQuestionAudio) {
      Get.snackbar(
        'Missing info',
        'Add question text, image, or audio.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // ----------------------------------------------------------
    // VALIDATE OPTIONS
    // ----------------------------------------------------------

    for (var i = 0;
    i < options.length;
    i++) {
      final hasImage =
          optionImagePaths[i].isNotEmpty;

      final hasAudio =
          optionAudioPaths[i].isNotEmpty;

      if (options[i].isEmpty &&
          !hasImage &&
          !hasAudio) {
        Get.snackbar(
          'Missing option',
          'Option ${i + 1} needs text, image, or audio.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }
    }

    // ----------------------------------------------------------
    // VALIDATE CORRECT ANSWER
    // ----------------------------------------------------------

    final correctIndex =
        correctOptionIndex.value;

    if (correctIndex == null ||
        correctIndex < 0 ||
        correctIndex >= options.length) {
      Get.snackbar(
        'Missing answer',
        'Select the correct answer.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // ==========================================================
    // EDIT EXISTING QUESTION
    // ==========================================================

    if (editingId != null) {
      await _updateExistingQuestion(
        editingId: editingId,
        question: question,
        options: options,
        correctIndex: correctIndex,
      );

      return;
    }

    // ==========================================================
    // ADD NEW QUESTION
    // ==========================================================

    await _createNewQuestion(
      question: question,
      options: options,
      correctIndex: correctIndex,
    );
  }

  // ============================================================
  // UPDATE EXISTING QUESTION
  // ============================================================

  Future<void> _updateExistingQuestion({
    required String editingId,
    required String question,
    required List<String> options,
    required int correctIndex,
  }) async {
    final existing =
    questions.firstWhereOrNull(
          (q) => q.id == editingId,
    );

    if (existing == null) {
      Get.snackbar(
        'Error',
        'Question could not be found.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isPicking.value = true;

      final updated =
      existing.copyWith(
        question: question,
        options: options,
        correctOptionIndex:
        correctIndex,
        setName:
        existing.setName ??
            selectedSet.value,
      );

      await _repo.updateQuestionOnServer(
        updated,
      );

      Get.back();

      Get.snackbar(
        'Updated',
        'MCQ has been updated successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor:
        const Color(0xFF16A34A),
        colorText: Colors.white,
        margin:
        const EdgeInsets.all(16),
      );

      await loadAdminMcqs();
    } catch (e) {
      debugPrint(
        'UPDATE MCQ ERROR: $e',
      );

      Get.snackbar(
        'Error',
        'Could not update MCQ: $e',
        snackPosition: SnackPosition.BOTTOM,
        margin:
        const EdgeInsets.all(16),
      );
    } finally {
      isPicking.value = false;
    }
  }

  // ============================================================
  // CREATE NEW QUESTION
  // ============================================================

  Future<void> _createNewQuestion({
    required String question,
    required List<String> options,
    required int correctIndex,
  }) async {
    try {
      isPicking.value = true;

      // --------------------------------------------------------
      // IMPORTANT
      //
      // Your current repository does NOT yet have a server
      // createQuestion() method.
      //
      // So we should NOT pretend that the new question has been
      // saved to Django.
      // --------------------------------------------------------

      Get.snackbar(
        'Not implemented yet',
        'Creating a new MCQ on the server needs the question/option POST API.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      debugPrint(
        'CREATE MCQ requested',
      );

      debugPrint(
        'SET: ${selectedSet.value}',
      );

      debugPrint(
        'QUESTION: $question',
      );

      debugPrint(
        'OPTIONS: $options',
      );

      debugPrint(
        'CORRECT INDEX: $correctIndex',
      );
    } finally {
      isPicking.value = false;
    }
  }

  // ============================================================
  // DELETE QUESTION
  // ============================================================

  Future<void> deleteQuestion(
      String id,
      ) async {
    if (id.isEmpty) {
      return;
    }

    try {
      isLoadingQuestions.value = true;

      debugPrint(
        'DELETE MCQ: $id',
      );

      await _repo.deleteQuestionOnServer(
        id,
      );

      Get.snackbar(
        'Removed',
        'MCQ has been removed successfully.',
        snackPosition: SnackPosition.BOTTOM,
        margin:
        const EdgeInsets.all(16),
      );
    } catch (e) {
      debugPrint(
        'DELETE MCQ ERROR: $e',
      );

      Get.snackbar(
        'Error',
        'Could not delete MCQ: $e',
        snackPosition: SnackPosition.BOTTOM,
        margin:
        const EdgeInsets.all(16),
      );
    } finally {
      isLoadingQuestions.value = false;
    }
  }

  // ============================================================
  // RESET FORM
  // ============================================================

  void resetForm() {
    questionController.clear();

    for (final controller
    in optionControllers) {
      controller.clear();
    }

    correctOptionIndex.value = null;

    clearPickedAudio();
    clearPickedQuestionImage();

    for (var i = 0; i < 4; i++) {
      clearOptionImage(i);
      clearOptionAudio(i);
    }

    editingQuestionId.value = null;
    selectedSet.value = '';
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    questionController.dispose();

    for (final controller
    in optionControllers) {
      controller.dispose();
    }

    super.onClose();
  }
}