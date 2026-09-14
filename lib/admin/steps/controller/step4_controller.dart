import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../common/api_services/process_service.dart';
import '../../../common/api_services/student_application_service.dart';

import '../../model/students_record.dart';
import '../../students/controller/students_controller.dart';

class Step4Controller extends GetxController {
  final StudentRecord student;

  Step4Controller(this.student);

  // ============================================================
  // STEP 4 FIELDS
  // ============================================================

  final Rxn<DateTime> interviewDate = Rxn<DateTime>();

  final RxnString interviewMode = RxnString();

  final RxnString interviewResult = RxnString();

  final TextEditingController notesController =
  TextEditingController();

  // ============================================================
  // SERVICES
  // ============================================================

  final ProcessService _processService =
  ProcessService();

  final StudentApplicationService _applicationService =
  StudentApplicationService();

  // ============================================================
  // SUBMITTING STATE
  // ============================================================

  final isSubmitting = false.obs;

  // ============================================================
  // VALIDATION
  // ============================================================

  bool get isComplete =>
      interviewDate.value != null &&
          interviewMode.value != null &&
          interviewResult.value != null;

  // ============================================================
  // PICK INTERVIEW DATE
  // ============================================================

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: interviewDate.value ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      interviewDate.value = picked;
    }
  }

  // ============================================================
  // SET INTERVIEW MODE
  // ============================================================

  void setMode(String mode) {
    interviewMode.value = mode;
  }

  // ============================================================
  // SET INTERVIEW RESULT
  // ============================================================

  void setResult(String result) {
    interviewResult.value = result;
  }

  // ============================================================
  // FORMATTED DATE
  // ============================================================

  String get formattedDate {
    final d = interviewDate.value;

    if (d == null) {
      return '';
    }

    return '${d.month.toString().padLeft(2, '0')}/'
        '${d.day.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  // ============================================================
  // SUBMIT STEP 4
  // ============================================================

  Future<void> submit() async {
    // Prevent duplicate submissions.
    if (!isComplete || isSubmitting.value) {
      return;
    }

    // ----------------------------------------------------------
    // CHECK PROCESS ID
    // ----------------------------------------------------------

    final processId = student.processId;

    if (processId == null || processId.isEmpty) {
      Get.snackbar(
        'Process Error',
        'Student process was not found.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return;
    }

    try {
      // --------------------------------------------------------
      // START SUBMISSION
      // --------------------------------------------------------

      isSubmitting.value = true;

      // --------------------------------------------------------
      // 1. SAVE STEP 4 DATA
      // --------------------------------------------------------

      await _applicationService.updateApplication(
         fields: {
        'interview_date': ?interviewDate.value
            ?.toIso8601String()
            .split('T')
            .first,

        'interview_mode': ?interviewMode.value,

        'interview_result': ?interviewResult.value,

        'interview_notes':
        notesController.text.trim(),
      },


      );

      // --------------------------------------------------------
      // 2. COMPLETE STEP 4 PROCESS STAGE
      // --------------------------------------------------------

      final response =
      await _processService.completeStage(
        processId: processId,
      );

      print(
        '========== STEP 4 COMPLETE RESPONSE ==========',
      );
      print(response);
      print(
        '==============================================',
      );

      // --------------------------------------------------------
      // 3. CHECK WHETHER ENTIRE PROCESS FINISHED
      // --------------------------------------------------------

      final finished =
          response['finished'] == true;

      // --------------------------------------------------------
      // 4. GET NEXT CURRENT STAGE
      // --------------------------------------------------------

      final currentStage =
      response['current_stage'];

      // --------------------------------------------------------
      // PROCESS FINISHED
      // --------------------------------------------------------

      if (finished) {
        Get.find<StudentsController>().updateStudent(
          student.id,
              (current) => current.copyWith(
            interviewDate: interviewDate.value,
            interviewMode: interviewMode.value,
            interviewResult: interviewResult.value,
            interviewNotes:
            notesController.text.trim(),
            processCompleted: true,

            // Step 4 has been completed.
            completedSteps: [
              ...current.completedSteps,
              if (!current.completedSteps.contains(4))
                4,
            ],
          ),
        );

        Get.back();

        Get.snackbar(
          'Process Completed',
          '${student.name} completed all process stages.',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      // --------------------------------------------------------
      // VALIDATE NEXT STAGE
      // --------------------------------------------------------

      if (currentStage is! Map) {
        throw Exception(
          'Server did not return the next process stage.',
        );
      }

      final nextStep = int.tryParse(
        currentStage['order'].toString(),
      );

      if (nextStep == null) {
        throw Exception(
          'Invalid next process stage returned by server.',
        );
      }

      // --------------------------------------------------------
      // 5. UPDATE LOCAL STUDENT STATE
      // --------------------------------------------------------

      Get.find<StudentsController>().updateStudent(
        student.id,
            (current) => current.copyWith(
          currentStep: nextStep,

          interviewDate:
          interviewDate.value,

          interviewMode:
          interviewMode.value,

          interviewResult:
          interviewResult.value,

          interviewNotes:
          notesController.text.trim(),

          // Step 4 is completed.
          completedSteps: [
            ...current.completedSteps,
            if (!current.completedSteps.contains(4))
              4,
          ],
        ),
      );

      // --------------------------------------------------------
      // 6. CLOSE STEP 4 SCREEN
      // --------------------------------------------------------

      Get.back();

      // --------------------------------------------------------
      // 7. SHOW SUCCESS MESSAGE
      // --------------------------------------------------------

      Get.snackbar(
        'Step 4 Complete',
        '${student.name} moved to Step $nextStep.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // --------------------------------------------------------
      // ERROR
      // --------------------------------------------------------

      print(
        '========== STEP 4 ERROR ==========',
      );
      print(e);
      print(
        '==================================',
      );

      Get.snackbar(
        'Unable to Complete Step 4',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // --------------------------------------------------------
      // STOP LOADING
      // --------------------------------------------------------

      isSubmitting.value = false;
    }
  }

  // ============================================================
  // CLEANUP
  // ============================================================

  @override
  void onClose() {
    notesController.dispose();

    super.onClose();
  }
}