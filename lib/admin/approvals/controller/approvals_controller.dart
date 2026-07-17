import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/models/application_step_model.dart';
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
  static const int adminStepsCount = 7; // steps 4 through 10 inclusive

  static final List<AdminStepMeta> adminSteps = [
    AdminStepMeta(
      id: 4,
      title: ApplicationStepsCatalog.definitions[3]['title'] as String,
      icon: Icons.mic_none_rounded,
      color: const Color(0xFFF59E0B), // amber
    ),
    AdminStepMeta(
      id: 5,
      title: ApplicationStepsCatalog.definitions[4]['title'] as String,
      icon: Icons.account_balance_outlined,
      color: const Color(0xFF16A34A), // green
    ),
    AdminStepMeta(
      id: 6,
      title: ApplicationStepsCatalog.definitions[5]['title'] as String,
      icon: Icons.mail_outline_rounded,
      color: const Color(0xFFDC2626), // red
    ),
    AdminStepMeta(
      id: 7,
      title: ApplicationStepsCatalog.definitions[6]['title'] as String,
      icon: Icons.verified_outlined,
      color: const Color(0xFF2563EB), // blue
    ),
    AdminStepMeta(
      id: 8,
      title: ApplicationStepsCatalog.definitions[7]['title'] as String,
      icon: Icons.checklist_rtl_rounded,
      color: const Color(0xFF16A34A), // green
    ),
    AdminStepMeta(
      id: 9,
      title: ApplicationStepsCatalog.definitions[8]['title'] as String,
      icon: Icons.badge_outlined,
      color: const Color(0xFF9333EA), // purple
    ),
    AdminStepMeta(
      id: 10,
      title: ApplicationStepsCatalog.definitions[9]['title'] as String,
      icon: Icons.flight_takeoff_rounded,
      color: const Color(0xFF0D9488), // teal
    ),
  ];

  static AdminStepMeta metaFor(int stepId) => adminSteps.firstWhere(
    (s) => s.id == stepId,
    orElse: () => adminSteps.first,
  );

  // null = "All Steps" chip selected
  final selectedStep = Rxn<int>();
  final selectedStatusFilter = ApprovalStatusFilter.all.obs;

  // Shared source of truth — same reactive list every step controller updates.
  StudentsController get _studentsController {
    if (!Get.isRegistered<StudentsController>()) {
      Get.put(StudentsController(), permanent: true);
    }
    return Get.find<StudentsController>();
  }

  // Students who have reached the admin-controlled stage (step >= 4).
  List<StudentRecord> get adminEligibleStudents => _studentsController.students
      .where((s) => s.currentStep >= adminStepsStart)
      .toList();

  static int adminStepsDone(StudentRecord student) =>
      (student.currentStep - adminStepsStart).clamp(0, adminStepsCount);

  static bool isFullyDone(StudentRecord student) =>
      adminStepsDone(student) >= adminStepsCount &&
      student.currentStep > StudentRecord.totalSteps;

  int get awaitingCount =>
      adminEligibleStudents.where((s) => !isFullyDone(s)).length;
  int get allDoneCount =>
      adminEligibleStudents.where((s) => isFullyDone(s)).length;

  List<StudentRecord> get filteredStudents {
    var list = adminEligibleStudents;

    if (selectedStep.value != null) {
      list = list.where((s) => s.currentStep == selectedStep.value).toList();
    }

    switch (selectedStatusFilter.value) {
      case ApprovalStatusFilter.pending:
        list = list.where((s) => !isFullyDone(s)).toList();
        break;
      case ApprovalStatusFilter.completed:
        list = list.where((s) => isFullyDone(s)).toList();
        break;
      case ApprovalStatusFilter.all:
        break;
    }

    return list;
  }

  void setStepFilter(int? step) => selectedStep.value = step;
  void setStatusFilter(ApprovalStatusFilter filter) =>
      selectedStatusFilter.value = filter;
}
