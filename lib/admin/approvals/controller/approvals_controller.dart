import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/models/application_step_model.dart';
import '../../../common/api_services/process_service.dart';
import '../../model/students_record.dart';
import '../../students/controller/students_controller.dart';

enum ApprovalStatusFilter { pending, completed, all }

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
  static const int adminStepsCount = 7; // Steps 4 through 10

  // ---------------------------------------------------------
  // PROCESS API
  // ---------------------------------------------------------

  final ProcessService _processService = ProcessService();

  /// Tracks which student's process is currently being completed.
  ///
  /// Key   = student/user ID
  /// Value = true while API request is running
  final isCompletingStep = <String, bool>{}.obs;

  // ---------------------------------------------------------
  // ADMIN PROCESS STEPS
  // ---------------------------------------------------------

  static final List<AdminStepMeta> adminSteps = [
    AdminStepMeta(
      id: 4,
      title: ApplicationStepsCatalog.definitions[3]['title'] as String,
      icon: Icons.mic_none_rounded,
      color: const Color(0xFFF59E0B),
    ),
    AdminStepMeta(
      id: 5,
      title: ApplicationStepsCatalog.definitions[4]['title'] as String,
      icon: Icons.account_balance_outlined,
      color: const Color(0xFF16A34A),
    ),
    AdminStepMeta(
      id: 6,
      title: ApplicationStepsCatalog.definitions[5]['title'] as String,
      icon: Icons.mail_outline_rounded,
      color: const Color(0xFFDC2626),
    ),
    AdminStepMeta(
      id: 7,
      title: ApplicationStepsCatalog.definitions[6]['title'] as String,
      icon: Icons.verified_outlined,
      color: const Color(0xFF2563EB),
    ),
    AdminStepMeta(
      id: 8,
      title: ApplicationStepsCatalog.definitions[7]['title'] as String,
      icon: Icons.checklist_rtl_rounded,
      color: const Color(0xFF16A34A),
    ),
    AdminStepMeta(
      id: 9,
      title: ApplicationStepsCatalog.definitions[8]['title'] as String,
      icon: Icons.badge_outlined,
      color: const Color(0xFF9333EA),
    ),
    AdminStepMeta(
      id: 10,
      title: ApplicationStepsCatalog.definitions[9]['title'] as String,
      icon: Icons.flight_takeoff_rounded,
      color: const Color(0xFF0D9488),
    ),
  ];

  static AdminStepMeta metaFor(int stepId) {
    return adminSteps.firstWhere(
          (s) => s.id == stepId,
      orElse: () => adminSteps.first,
    );
  }

  // ---------------------------------------------------------
  // FILTERS
  // ---------------------------------------------------------

  /// null = "All Steps"
  final selectedStep = Rxn<int>();

  final selectedStatusFilter =
      ApprovalStatusFilter.all.obs;

  // ---------------------------------------------------------
  // STUDENTS CONTROLLER
  // ---------------------------------------------------------

  StudentsController get _studentsController {
    if (!Get.isRegistered<StudentsController>()) {
      Get.put(
        StudentsController(),
        permanent: true,
      );
    }

    return Get.find<StudentsController>();
  }

  // ---------------------------------------------------------
  // STUDENTS ELIGIBLE FOR ADMIN PROCESS
  // ---------------------------------------------------------

  List<StudentRecord> get adminEligibleStudents {
    return _studentsController.students
        .where(
          (student) =>
      student.currentStep >= adminStepsStart,
    )
        .toList();
  }

  // ---------------------------------------------------------
  // ADMIN STEPS COMPLETED
  // ---------------------------------------------------------

  static int adminStepsDone(StudentRecord student) {
    if (student.processCompleted) {
      return adminStepsCount;
    }

    return (student.currentStep - adminStepsStart)
        .clamp(0, adminStepsCount)
        .toInt();
  }

  // ---------------------------------------------------------
  // CHECK IF ALL ADMIN STEPS ARE COMPLETE
  // ---------------------------------------------------------

  static bool isFullyDone(StudentRecord student) =>
      student.processCompleted;

  // ---------------------------------------------------------
  // COUNTS
  // ---------------------------------------------------------

  int get awaitingCount {
    return adminEligibleStudents
        .where((student) => !isFullyDone(student))
        .length;
  }

  int get allDoneCount {
    return adminEligibleStudents
        .where((student) => isFullyDone(student))
        .length;
  }

  // ---------------------------------------------------------
  // FILTERED STUDENTS
  // ---------------------------------------------------------

  List<StudentRecord> get filteredStudents {
    var list = adminEligibleStudents;

    // Step filter
    if (selectedStep.value != null) {
      list = list
          .where(
            (student) =>
        student.currentStep ==
            selectedStep.value,
      )
          .toList();
    }

    // Status filter
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

  // ---------------------------------------------------------
  // FILTER ACTIONS
  // ---------------------------------------------------------

  void setStepFilter(int? step) {
    selectedStep.value = step;
  }

  void setStatusFilter(
      ApprovalStatusFilter filter,
      ) {
    selectedStatusFilter.value = filter;
  }

  // ---------------------------------------------------------
  // COMPLETE CURRENT PROCESS STEP
  // ---------------------------------------------------------

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

      if (processId == null || processId.isEmpty) {
        throw Exception(
          'Student process was not found for this student.',
        );
      }

      final response = await _processService.completeStage(
        processId: processId,
      );

      final finished = response['finished'] == true;

      final currentStage = response['current_stage'];

      if (currentStage is! Map) {
        throw Exception(
          'Server did not return the current process stage.',
        );
      }

      final currentOrder = int.tryParse(
        currentStage['order'].toString(),
      );

      if (currentOrder == null) {
        throw Exception(
          'Invalid process stage returned by server.',
        );
      }

      final currentStageName =
          currentStage['name']?.toString() ?? meta.title;

      _studentsController.updateStudent(
        studentId,
            (current) => current.copyWith(
          currentStep: currentOrder,
          processCompleted: finished,
        ),
      );

      if (finished) {
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
      } else {
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
      }
    } catch (e) {
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