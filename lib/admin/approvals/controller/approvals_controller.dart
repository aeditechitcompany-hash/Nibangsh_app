import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/models/application_step_model.dart';
import '../../../common/api_services/process_service.dart';
import '../../model/students_record.dart';
import '../../students/controller/students_controller.dart';

enum ApprovalStatusFilter {
  pending,
  completed,
  all,
}

class AdminStepMeta {
  final int id;
  final String title;
  final IconData icon;
  final Color color;

  const AdminStepMeta({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

class ApprovalsController extends GetxController {
  static const int adminStepsStart = 4;
  static const int adminStepsCount = 7;

  final ProcessService _processService = ProcessService();

  // ============================================================
  // STATE
  // ============================================================

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// Student ID -> true while completing a process step.
  final isCompletingStep = <String, bool>{}.obs;

  // ============================================================
  // ADMIN STEPS
  // ============================================================

  static final List<AdminStepMeta> adminSteps = [
    AdminStepMeta(
      id: 4,
      title:
      ApplicationStepsCatalog.definitions[3]['title'] as String,
      icon: Icons.mic_none_rounded,
      color: const Color(0xFFF59E0B),
    ),
    AdminStepMeta(
      id: 5,
      title:
      ApplicationStepsCatalog.definitions[4]['title'] as String,
      icon: Icons.account_balance_outlined,
      color: const Color(0xFF16A34A),
    ),
    AdminStepMeta(
      id: 6,
      title:
      ApplicationStepsCatalog.definitions[5]['title'] as String,
      icon: Icons.mail_outline_rounded,
      color: const Color(0xFFDC2626),
    ),
    AdminStepMeta(
      id: 7,
      title:
      ApplicationStepsCatalog.definitions[6]['title'] as String,
      icon: Icons.verified_outlined,
      color: const Color(0xFF2563EB),
    ),
    AdminStepMeta(
      id: 8,
      title:
      ApplicationStepsCatalog.definitions[7]['title'] as String,
      icon: Icons.checklist_rtl_rounded,
      color: const Color(0xFF16A34A),
    ),
    AdminStepMeta(
      id: 9,
      title:
      ApplicationStepsCatalog.definitions[8]['title'] as String,
      icon: Icons.badge_outlined,
      color: const Color(0xFF9333EA),
    ),
    AdminStepMeta(
      id: 10,
      title:
      ApplicationStepsCatalog.definitions[9]['title'] as String,
      icon: Icons.flight_takeoff_rounded,
      color: const Color(0xFF0D9488),
    ),
  ];

  static AdminStepMeta metaFor(int stepId) {
    return adminSteps.firstWhere(
          (step) => step.id == stepId,
      orElse: () => adminSteps.first,
    );
  }

  // ============================================================
  // FILTERS
  // ============================================================

  /// null = all steps
  final selectedStep = Rxn<int>();

  final selectedStatusFilter =
      ApprovalStatusFilter.all.obs;

  // ============================================================
  // STUDENTS CONTROLLER
  // ============================================================

  StudentsController get studentsController {
    if (!Get.isRegistered<StudentsController>()) {
      Get.put(
        StudentsController(),
        permanent: true,
      );
    }

    return Get.find<StudentsController>();
  }

  // ============================================================
  // INITIALIZE
  // ============================================================

  @override
  void onInit() {
    super.onInit();
    _loadStudents();

  }

  Future<void> _loadStudents() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // IMPORTANT:
      // Always refresh from Django when Approvals opens.
      await studentsController.refreshStudents(force: true);
      if (studentsController.errorMessage.value.isNotEmpty) {
        errorMessage.value =
            studentsController.errorMessage.value;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // PUBLIC REFRESH
  // ============================================================

  Future<void> refresh() async {
    await _loadStudents();
  }

  // ============================================================
  // ADMIN-ELIGIBLE STUDENTS
  // ============================================================
  List<StudentRecord> get adminEligibleStudents {
    return studentsController.students
        .where(
          (student) =>
      student.currentStep >= adminStepsStart ||
          student.processCompleted,
    )
        .toList();
  }

  // ============================================================
  // ADMIN STEPS COMPLETED
  // ============================================================

  static int adminStepsDone(StudentRecord student) {
    if (student.processCompleted) {
      return adminStepsCount;
    }

    return student.completedSteps
        .where(
          (step) =>
      step >= adminStepsStart &&
          step <= 10,
    )
        .length;
  }

  // ============================================================
  // PROCESS COMPLETED
  // ============================================================

  static bool isFullyDone(StudentRecord student) {
    return student.processCompleted;
  }

  // ============================================================
  // COUNTS
  // ============================================================

  int get awaitingCount {
    return adminEligibleStudents
        .where(
          (student) => !isFullyDone(student),
    )
        .length;
  }

  int get allDoneCount {
    return adminEligibleStudents
        .where(
          (student) => isFullyDone(student),
    )
        .length;
  }

  // ============================================================
  // FILTERED STUDENTS
  // ============================================================

  List<StudentRecord> get filteredStudents {
    var list = adminEligibleStudents;

    // ----------------------------------------------------------
    // STEP FILTER
    // ----------------------------------------------------------

    if (selectedStep.value != null) {
      list = list
          .where(
            (student) =>
        student.currentStep ==
            selectedStep.value,
      )
          .toList();
    }

    // ----------------------------------------------------------
    // STATUS FILTER
    // ----------------------------------------------------------

    switch (selectedStatusFilter.value) {
      case ApprovalStatusFilter.pending:
        list = list
            .where(
              (student) => !isFullyDone(student),
        )
            .toList();
        break;

      case ApprovalStatusFilter.completed:
        list = list
            .where(
              (student) => isFullyDone(student),
        )
            .toList();
        break;

      case ApprovalStatusFilter.all:
        break;
    }

    return list;
  }

  // ============================================================
  // FILTER ACTIONS
  // ============================================================

  void setStepFilter(int? step) {
    selectedStep.value = step;
  }

  void setStatusFilter(
      ApprovalStatusFilter filter,
      ) {
    selectedStatusFilter.value = filter;
  }

  // ============================================================
  // COMPLETE PROCESS STEP
  // ============================================================

  Future<void> completeProcessStep(
      StudentRecord student,
      AdminStepMeta meta,
      ) async {
    final studentId = student.id;

    if (isCompletingStep[studentId] == true) {
      return;
    }

    try {
      isCompletingStep[studentId] = true;

      final processId = student.processId;

      if (processId == null || processId.trim().isEmpty) {
        throw Exception(
          'Student process was not found for this student.',
        );
      }

      debugPrint('========================================');
      debugPrint('COMPLETING PROCESS STEP');
      debugPrint('Student: ${student.name}');
      debugPrint('Student ID: $studentId');
      debugPrint('Process ID: $processId');
      debugPrint('OLD CURRENT STEP: ${student.currentStep}');
      debugPrint('========================================');

      // ==========================================================
      // COMPLETE CURRENT STAGE
      // ==========================================================

      final response = await _processService.completeStage(
        processId: processId,
      );

      debugPrint('========================================');
      debugPrint('COMPLETE STAGE API RESPONSE');
      debugPrint(response.toString());
      debugPrint('========================================');

      final finished = response['finished'] == true;

      // ==========================================================
      // FINAL STAGE
      // ==========================================================

      if (finished) {
        debugPrint(
          'PROCESS FINISHED FOR ${student.name}',
        );

        studentsController.updateStudent(
          studentId,
              (current) => current.copyWith(
            currentStep: 10,
            processCompleted: true,
          ),
        );

        // Fetch the actual backend state.
        await studentsController.refreshStudents(
          force: true,
        );

        final refreshedStudent =
        studentsController.byId(studentId);

        debugPrint('========================================');
        debugPrint('AFTER FINAL REFRESH');
        debugPrint(
          'Student: ${refreshedStudent?.name}',
        );
        debugPrint(
          'Current Step: ${refreshedStudent?.currentStep}',
        );
        debugPrint(
          'Process Completed: '
              '${refreshedStudent?.processCompleted}',
        );
        debugPrint('========================================');

        Get.snackbar(
          'Process Completed',
          '${student.name} has completed all process steps.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: meta.color,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );

        return;
      }

      // ==========================================================
      // NEXT STAGE
      // ==========================================================

      final currentStage = response['current_stage'];

      if (currentStage is! Map) {
        throw Exception(
          'Server did not return the next process stage.',
        );
      }

      final currentOrder = int.tryParse(
        currentStage['order']?.toString() ?? '',
      );

      if (currentOrder == null) {
        throw Exception(
          'Invalid process stage returned by server.',
        );
      }

      final currentStageName =
          currentStage['name']?.toString() ??
              meta.title;

      debugPrint('========================================');
      debugPrint('NEXT STAGE FROM BACKEND');
      debugPrint('Order: $currentOrder');
      debugPrint('Name: $currentStageName');
      debugPrint('========================================');

      // ==========================================================
      // UPDATE LOCAL STATE IMMEDIATELY
      // ==========================================================

      studentsController.updateStudent(
        studentId,
            (current) => current.copyWith(
          currentStep: currentOrder,
          processCompleted: false,
        ),
      );

      // ==========================================================
      // VERIFY LOCAL STATE
      // ==========================================================

      final locallyUpdatedStudent =
      studentsController.byId(studentId);

      debugPrint('========================================');
      debugPrint('LOCAL STUDENT AFTER UPDATE');
      debugPrint(
        'Current Step: '
            '${locallyUpdatedStudent?.currentStep}',
      );
      debugPrint(
        'Process Completed: '
            '${locallyUpdatedStudent?.processCompleted}',
      );
      debugPrint('========================================');

      // ==========================================================
      // REFRESH FROM DJANGO
      // ==========================================================

      await studentsController.refreshStudents(
        force: true,
      );

      // ==========================================================
      // VERIFY SERVER STATE
      // ==========================================================

      final refreshedStudent =
      studentsController.byId(studentId);

      debugPrint('========================================');
      debugPrint('SERVER STATE AFTER REFRESH');
      debugPrint(
        'Student: ${refreshedStudent?.name}',
      );
      debugPrint(
        'Current Step: ${refreshedStudent?.currentStep}',
      );
      debugPrint(
        'Process Completed: '
            '${refreshedStudent?.processCompleted}',
      );
      debugPrint('========================================');

      if (refreshedStudent == null) {
        throw Exception(
          'Student disappeared after refreshing the student list.',
        );
      }

      // ==========================================================
      // SUCCESS MESSAGE
      // ==========================================================

      Get.snackbar(
        'Step Completed',
        '${student.name} moved to '
            'Step $currentOrder: $currentStageName.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: meta.color,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      debugPrint('========================================');
      debugPrint('COMPLETE PROCESS STEP ERROR');
      debugPrint('$e');
      debugPrint('$stackTrace');
      debugPrint('========================================');

      Get.snackbar(
        'Unable to Complete Step',
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isCompletingStep[studentId] = false;
    }
  }
  }
