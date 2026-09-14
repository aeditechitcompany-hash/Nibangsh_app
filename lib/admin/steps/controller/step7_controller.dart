import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/api_services/process_service.dart';
import '../../../common/api_services/student_application_service.dart';
import '../../../common/services/document_picker_service.dart';
import '../../model/students_record.dart';
import '../../students/controller/students_controller.dart';

class Step7Controller extends GetxController {
  final StudentRecord student;
  Step7Controller(this.student);

  static const List<String> checklistItems = [
    'Student name matches passport',
    'Course name is correct',
    'Intake date is correct',
    'Institution seal is present',
    'No conditional clauses',
  ];
  final ProcessService _processService = ProcessService();
  final StudentApplicationService _applicationService =
  StudentApplicationService();

  final isSubmitting = false.obs;
  final RxnString locFileName = RxnString();
  late final RxBool isVerified = false.obs;

  bool get canMarkVerified => locFileName.value != null;

  Future<void> browseForFile() async {
    final picked = await DocumentPickerService.pickDocument();
    if (picked != null) locFileName.value = picked.name;
  }

  void markVerified() {
    if (!canMarkVerified) return;
    isVerified.value = true;
  }

  Future<void> submit() async {
    if (!isVerified.value || isSubmitting.value) return;

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
        'loc_verified': isVerified.toString(),
      },
        files: {
          'loc_file': File(locFileName.value!),
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
            locFileName: locFileName.value,
            locVerified: true,
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
          locFileName: locFileName.value,
          locVerified: true,
        ),
      );

      Get.back();

      Get.snackbar(
        'Step 7 Complete',
        '${student.name} moved to Step $nextStep.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4F46E5),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Unable to Complete Step 7',
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
}