import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nibangsh_consultancy/common/api_services/process_service.dart';
import 'package:nibangsh_consultancy/common/api_services/academic_details_service.dart';
import 'package:nibangsh_consultancy/common/api_services/api_constants.dart';
import 'package:nibangsh_consultancy/common/api_services/api_service.dart';
import 'package:nibangsh_consultancy/common/models/application_step_model.dart';
import 'package:nibangsh_consultancy/common/services/storage.dart';

import '../../../common/api_services/mcq_access_service.dart';
import '../../../common/api_services/student_application_service.dart';

class HomeController extends GetxController {
  final RxnString step1FilePath = RxnString();
  final RxnString step1FileName = RxnString();
  final McqAccessService _mcqAccessService = McqAccessService();

  final mcqAccess = false.obs;
  final isLoadingMcqAccess = false.obs;
  final StudentApplicationService _applicationService =
  StudentApplicationService();

  final ImagePicker _picker = ImagePicker();
  Future<void> loadMcqAccess() async {
    try {
      isLoadingMcqAccess.value = true;

      final hasAccess = await _mcqAccessService.hasMcqAccess();

      mcqAccess.value = hasAccess;

      print('========== MCQ ACCESS ==========');
      print('MCQ Access: ${mcqAccess.value}');
      print('================================');
    } catch (e) {
      print('LOAD MCQ ACCESS ERROR: $e');
      mcqAccess.value = false;
    } finally {
      isLoadingMcqAccess.value = false;
    }
  }

  Future<void> pickStepPhoto(

      int stepId,
      ImageSource source,
      ) async {
    if (stepId != 1) return;

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final file = File(pickedFile.path);

      // Show selected image immediately.
      step1FilePath.value = pickedFile.path;
      step1FileName.value = pickedFile.name;

      print('STEP 1 LOCAL FILE: ${pickedFile.path}');
      print('STEP 1 FILE NAME: ${pickedFile.name}');

      // --------------------------------------------------
      // 1. UPLOAD FILE
      // --------------------------------------------------

      final uploadResponse =
      await _applicationService.updateApplication(
        files: {
          'transcript_file': file,
        },
      );

      print('========== STEP 1 UPLOAD RESPONSE ==========');
      print(uploadResponse);
      print('=============================================');

      // --------------------------------------------------
      // 2. COMPLETE STEP 1 ONLY AFTER UPLOAD SUCCEEDS
      // --------------------------------------------------
      final completed = await completeStudentStep(1);

      if (completed) {
        Get.snackbar(
          'Success',
          'Transcript uploaded successfully.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      print('STEP 1 IMAGE UPLOAD ERROR: $e');

      Get.snackbar(
        'Upload failed',
        'Could not upload your transcript. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  final selectedNavIndex = 0.obs;

  final email = ''.obs;
  final country = ''.obs;
  final gpa = ''.obs;
  final passoutYear = ''.obs;
  final degree = ''.obs;


  // ─────────────────────────────────────────────
  // APPLICATION PROCESS STATE
  // ─────────────────────────────────────────────

  final steps = <ApplicationStepModel>[].obs;

  final progressPercent = 0.obs;

  /// Current process step from Django.
  final currentStep = 1.obs;

  /// Steps that Django says are completed.
  final completedSteps = <int>[].obs;

  /// Backend process ID.
  final processId = ''.obs;

  /// Whether the whole process is finished.
  final processCompleted = false.obs;

  final isLoadingProcess = false.obs;

  // Student's locally selected information.
  String _step2LanguageTest = '';

  final userName = ''.obs;

  final ApiService _api = const ApiService();

  final AcademicDetailsService _academicDetailsService =
  AcademicDetailsService();
  final ProcessService _processService = ProcessService();
  final isLoadingAcademicDetails = false.obs;

  // ─────────────────────────────────────────────
  // STEP FILTERS
  // ─────────────────────────────────────────────

  List<ApplicationStepModel> get userSteps =>
      steps.where((s) => s.owner == StepOwner.user).toList();

  List<ApplicationStepModel> get adminSteps =>
      steps.where((s) => s.owner == StepOwner.admin).toList();

  int get userStepsDoneCount =>
      userSteps.where((s) => s.status == StepStatus.done).length;

  int get adminStepsDoneCount =>
      adminSteps.where((s) => s.status == StepStatus.done).length;

  // ─────────────────────────────────────────────
  // GREETING
  // ─────────────────────────────────────────────

  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning';
    }

    if (hour < 17) {
      return 'Good afternoon';
    }

    return 'Good evening';
  }

  // ─────────────────────────────────────────────
  // NAME
  // ─────────────────────────────────────────────

  String nameFromEmail(
      String email, {
        String fallback = 'Student',
      }) {
    if (email.isEmpty || !email.contains('@')) {
      return fallback;
    }

    final localPart = email.split('@').first;

    return localPart.isEmpty ? fallback : localPart;
  }

  String get initials {
    final name = userName.trim();

    if (name.isEmpty) {
      return '?';
    }

    final parts = name
        .split(RegExp(r'[\s._-]+'))
        .where((p) => p.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (
        parts.first.substring(0, 1) +
            parts.last.substring(0, 1)
    ).toUpperCase();
  }

  // ─────────────────────────────────────────────
  // INIT
  // ─────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map) {
      email.value = args['email']?.toString() ?? '';
    }

    userName.value = nameFromEmail(email.value);

    _loadUserName();
    _loadAcademicDetailsFromBackend();

    // IMPORTANT:
    // Load the real process from Django first.
    loadProcessFromBackend();
  }

  // ─────────────────────────────────────────────
  // LOAD USER NAME
  // ─────────────────────────────────────────────

  Future<void> _loadUserName() async {
    final storedName = await StorageService.getUserName();

    if (storedName != null && storedName.trim().isNotEmpty) {
      userName.value = storedName.trim();
    }
  }

  // ─────────────────────────────────────────────
  // LOAD ACADEMIC DETAILS
  // ─────────────────────────────────────────────

  Future<void> _loadAcademicDetailsFromBackend() async {
    try {
      isLoadingAcademicDetails.value = true;

      final education =
      await _academicDetailsService.getMyAcademicDetails();

      if (education == null) {
        return;
      }

      final countryName =
          education['country_name']?.toString() ?? '';

      final degreeName =
          education['degree_level']?.toString() ?? '';

      final gpaValue =
          education['gpa']?.toString() ?? '';

      final passoutValue =
          education['passout_year']?.toString() ?? '';

      country.value = countryName;
      gpa.value = gpaValue;
      passoutYear.value = passoutValue;

      switch (degreeName) {
        case 'bachelor':
          degree.value = 'Bachelors';
          break;

        case 'master':
          degree.value = 'Masters';
          break;

        case 'phd':
          degree.value = 'PHD';
          break;

        default:
          degree.value = degreeName;
      }
    } catch (e) {
      print(
        'LOAD ACADEMIC DETAILS ERROR: $e',
      );
    } finally {
      isLoadingAcademicDetails.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // LOAD PROCESS FROM DJANGO
  // ─────────────────────────────────────────────

  Future<void> loadProcessFromBackend() async {
    try {
      isLoadingProcess.value = true;

      final response = await _api.get(
        url: '${ApiConstants.baseUrl}/accounts/auth/me/',
      );

      print(
          '========== HOME PROCESS RESPONSE =========='
      );
      print(response);
      print(
          '==========================================='
      );

      if (response is! Map) {
        throw Exception(
          'Invalid user response from server.',
        );
      }

      final data =
      Map<String, dynamic>.from(response);

      _applyProcessResponse(data);
    } catch (e) {
      print(
        'LOAD PROCESS ERROR: $e',
      );

      // Do not destroy existing process state
      // if the refresh temporarily fails.
      _rebuildSteps();
    } finally {
      isLoadingProcess.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // APPLY BACKEND PROCESS DATA
  // ─────────────────────────────────────────────

  void _applyProcessResponse(
      Map<String, dynamic> data,
      ) {
    processId.value =
        data['process_id']?.toString() ?? '';

    currentStep.value =
        int.tryParse(
          data['current_process_step']?.toString() ?? '',
        ) ??
            1;

    processCompleted.value =
        data['process_finished'] == true;

    final rawCompleted =
    data['completed_process_steps'];

    if (rawCompleted is List) {
      final parsed = rawCompleted
          .map(
            (value) =>
            int.tryParse(value.toString()),
      )
          .whereType<int>()
          .toSet()
          .toList();

      parsed.sort();

      completedSteps.assignAll(parsed);
    } else {
      completedSteps.clear();
    }

    _rebuildSteps();
  }

  // ─────────────────────────────────────────────
  // REBUILD APPLICATION STEPS
  // ─────────────────────────────────────────────

  void _rebuildSteps() {
    final built =
    <ApplicationStepModel>[];

    /*
     * IMPORTANT:
     *
     * We DO NOT calculate completion from:
     *
     *     step.id < currentStep
     *
     * because Django gives us the authoritative
     * completed_process_steps list.
     */

    final completed =
    completedSteps.toSet();

    for (final def
    in ApplicationStepsCatalog.definitions) {
      final id = def['id'] as int;

      final done =
      completed.contains(id);

      StepStatus status;

      if (done) {
        status = StepStatus.done;
      } else if (
      !processCompleted.value &&
          id == currentStep.value) {
        status = StepStatus.active;
      } else {
        status = StepStatus.pending;
      }

      var subtitle =
      def['subtitle'] as String;

      if (id == 2 &&
          _step2LanguageTest.isNotEmpty) {
        subtitle =
        '$_step2LanguageTest selected';
      }

      built.add(
        ApplicationStepModel(
          id: id,
          title: def['title'] as String,
          subtitle: subtitle,
          icon: def['icon'],
          owner: def['owner'] as StepOwner,
          status: status,
        ),
      );
    }

    steps.assignAll(built);

    // Calculate progress from actual backend
    // completed steps.
    final total =
        ApplicationStepsCatalog.definitions.length;

    if (total == 0) {
      progressPercent.value = 0;
      return;
    }

    final doneCount =
    completed.length.clamp(0, total);

    progressPercent.value =
        ((doneCount / total) * 100).round();
  }

  // ─────────────────────────────────────────────
  // STEP 1
  // ─────────────────────────────────────────────

  Future<void> markStep1Done() async {
    await completeStudentStep(1);
  }

  // ─────────────────────────────────────────────
  // STEP 2
  // ─────────────────────────────────────────────

  Future<void> selectLanguageTest(String test) async {
    _step2LanguageTest = test;

    await completeStudentStep(2);
  }

  // ─────────────────────────────────────────────
  // STEP 3
  // ─────────────────────────────────────────────

  Future<void> markStep3Done() async {
    await completeStudentStep(3);
  }

  // ─────────────────────────────────────────────
// COMPLETE STUDENT PROCESS STEP
// ─────────────────────────────────────────────

  Future<bool> completeStudentStep(int step) async {
    if (processId.value.isEmpty) {
      await loadProcessFromBackend();
    }

    if (processId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Your application process could not be found.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return false;
    }

    // Make sure the student is completing the
    // step Django says is currently active.
    if (currentStep.value != step) {
      Get.snackbar(
        'Step unavailable',
        'Please complete Step ${currentStep.value} first.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return false;
    }

    try {
      isLoadingProcess.value = true;

      final response = await _processService.completeStage(
        processId: processId.value,
      );

      print('========== COMPLETE STEP RESPONSE ==========');
      print(response);
      print('=============================================');

      final finished = response['finished'] == true;

      if (finished) {
        processCompleted.value = true;
      }

      // Django is the source of truth.
      // Reload the process after completion.
      await loadProcessFromBackend();

      return true;
    } catch (e) {
      print('COMPLETE STEP ERROR: $e');

      Get.snackbar(
        'Error',
        'Could not complete Step $step.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      return false;
    } finally {
      isLoadingProcess.value = false;
    }
  }


  // ─────────────────────────────────────────────
  // PICK STEP PHOTO
  // ─────────────────────────────────────────────


  // ─────────────────────────────────────────────
  // REFRESH
  // ─────────────────────────────────────────────

  Future<void> refreshProcess() async {
    await loadProcessFromBackend();
  }

  // ─────────────────────────────────────────────
  // NAVIGATION
  // ─────────────────────────────────────────────

  void setNavIndex(int index) {
    selectedNavIndex.value = index;
  }
}