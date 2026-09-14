import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/api_services/process_service.dart';
import '../../../common/api_services/student_application_service.dart';
import '../../model/students_record.dart';
import '../../students/controller/students_controller.dart';

class Step8Controller extends GetxController {
  final StudentRecord student;
  Step8Controller(this.student);

  static const List<String> scholarshipOptions = [
    'None',
    'Partial',
    'Full Merit',
  ];

  final Rxn<DateTime> commencementDate = Rxn<DateTime>();
  final RxnString scholarshipStatus = RxnString();
  final TextEditingController notesController = TextEditingController();

  bool get isComplete =>
      commencementDate.value != null && scholarshipStatus.value != null;
  final ProcessService _processService = ProcessService();
  final StudentApplicationService _applicationService =
  StudentApplicationService();
  final isSubmitting = false.obs;
  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: commencementDate.value ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) commencementDate.value = picked;
  }

  void setScholarshipStatus(String status) => scholarshipStatus.value = status;

  String get formattedDate {
    final d = commencementDate.value;
    if (d == null) return '';
    return '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';
  }

  Future<void> submit() async {
    if (!isComplete || isSubmitting.value) return;

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
      isSubmitting.value = true;

      await _applicationService.updateApplication(
          fields: {
        'course_commencement_date': ?commencementDate.value
            ?.toIso8601String()
            .split('T')
            .first,
        'scholarship_status': ?scholarshipStatus.value,
        'final_selection_notes': notesController.text.trim(),
        'final_selection_confirmed': "true",
      },

      );

      final response = await _processService.completeStage(
        processId: processId,
      );

      final finished = response['finished'] == true;
      final currentStage = response['current_stage'];

      if (finished) {
        Get.find<StudentsController>().updateStudent(
          student.id,
              (current) => current.copyWith(
            courseCommencementDate: commencementDate.value,
            scholarshipStatus: scholarshipStatus.value,
            finalSelectionNotes: notesController.text.trim(),
            finalSelectionConfirmed: true,
            processCompleted: true,
          ),
        );

        Get.back();

        Get.snackbar(
          'Process Completed',
          '${student.name} completed all process stages.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF16A34A),
          colorText: Colors.white,
        );

        return;
      }

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

      Get.find<StudentsController>().updateStudent(
        student.id,
            (current) => current.copyWith(
          currentStep: nextStep,
          courseCommencementDate: commencementDate.value,
          scholarshipStatus: scholarshipStatus.value,
          finalSelectionNotes: notesController.text.trim(),
          finalSelectionConfirmed: true,
        ),
      );

      Get.back();

      Get.snackbar(
        'Step 8 Complete',
        '${student.name} moved to Step $nextStep.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF16A34A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Unable to Complete Step 8',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
