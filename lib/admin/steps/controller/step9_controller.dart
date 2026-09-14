import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/api_services/process_service.dart';
import '../../../common/api_services/student_application_service.dart';
import '../../../common/services/document_picker_service.dart';
import '../../model/students_record.dart';
import '../../students/controller/students_controller.dart';

class Step9Controller extends GetxController {
  final StudentRecord student;
  Step9Controller(this.student);

  static const String statusInProgress = 'In Progress — Submitted';
  static const String statusApproved = 'Visa Approved';
  static const String statusRejected = 'Visa Rejected';

  final TextEditingController refNoController = TextEditingController();
  final RxnString visaStatusUpdate = RxnString();
  final RxnString letterFileName = RxnString();
  final RxnString letterFilePath = RxnString();
  final ProcessService _processService = ProcessService();
  final StudentApplicationService _applicationService =
  StudentApplicationService();
  final isSubmitting = false.obs;
  final RxBool _formTick = false.obs;
  bool get formTick => _formTick.value;

  @override
  void onInit() {
    super.onInit();
    refNoController.addListener(() => _formTick.toggle());
  }

  bool get isComplete =>
      refNoController.text.trim().isNotEmpty &&
      visaStatusUpdate.value != null &&
      letterFileName.value != null;

  void setStatus(String status) => visaStatusUpdate.value = status;

  Future<void> browseForFile() async {
    final picked = await DocumentPickerService.pickDocument();
    if (picked != null)  {letterFileName.value = picked.name;
    letterFilePath.value = picked.path;
  }
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

      // Convert UI status to the value stored in the application.
      final String visaStatus =
      visaStatusUpdate.value == statusApproved
          ? 'Approved'
          : visaStatusUpdate.value == statusRejected
          ? 'Rejected'
          : 'Processing';

      // Save Step 9 application data first.
      await _applicationService.updateApplication(fields: {
        'visa_ref_no': refNoController.text.trim(),
        'visa_status_update': visaStatus,
      },
        files: {
          'visa_approval_letter_file': File(letterFileName.value!),
        },
      );

      // Then complete the process stage.
      final response = await _processService.completeStage(
        processId: processId,
      );

      final finished = response['finished'] == true;
      final currentStage = response['current_stage'];

      if (finished) {
        Get.find<StudentsController>().updateStudent(
          student.id,
              (current) => current.copyWith(
            visaRefNo: refNoController.text.trim(),
            visaStatusUpdate: visaStatusUpdate.value,
            visaApprovalLetterFileName: letterFileName.value,
            visaStatus: visaStatus,
            processCompleted: true,
            completedSteps: {
              ...current.completedSteps,
              9,
            }.toList()
              ..sort(),
          ),
        );

        Get.back();

        Get.snackbar(
          'Process Completed',
          '${student.name} completed all process stages.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF16A34A),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
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
          visaRefNo: refNoController.text.trim(),
          visaStatusUpdate: visaStatusUpdate.value,
          visaApprovalLetterFileName: letterFileName.value,
          visaStatus: visaStatus,
          completedSteps: {
            ...current.completedSteps,
            9,
          }.toList()
            ..sort(),
        ),
      );

      Get.back();

      Get.snackbar(
        'Step 9 Complete',
        '${student.name} moved to Step $nextStep.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Unable to Complete Step 9',
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
    refNoController.dispose();
    super.onClose();
  }
}
