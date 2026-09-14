import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/api_services/process_service.dart';
import '../../../common/api_services/student_application_service.dart';
import '../../../common/services/document_picker_service.dart';
import '../../model/students_record.dart';
import '../../students/controller/students_controller.dart';

class Step5Controller extends GetxController {
  final StudentRecord student;
  Step5Controller(this.student);

  final TextEditingController refNoController = TextEditingController();

  final Rxn<DateTime> submissionDate = Rxn<DateTime>(DateTime.now());

  final RxnString confirmationFileName = RxnString();

  bool get isComplete =>
      refNoController.text.trim().isNotEmpty &&
      submissionDate.value != null &&
      confirmationFileName.value != null;

  final RxBool _formTick = false.obs;
  final ProcessService _processService = ProcessService();
  final StudentApplicationService _applicationService =
  StudentApplicationService();
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    refNoController.addListener(() => _formTick.toggle());
  }

  bool get formTick => _formTick.value;

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: submissionDate.value ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) submissionDate.value = picked;
  }

  Future<void> browseForFile() async {
    final picked = await DocumentPickerService.pickDocument();
    if (picked != null) confirmationFileName.value = picked.name;
  }

  String get formattedDate {
    final d = submissionDate.value;
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
          fields:{
        'application_ref_no': refNoController.text.trim(),
        'submission_date': ?submissionDate.value
            ?.toIso8601String()
            .split('T')
            .first,
      },
        files: {
          'confirmation_file': File(confirmationFileName.value!),
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
            applicationRefNo: refNoController.text.trim(),
            submissionDate: submissionDate.value,
            confirmationFileName: confirmationFileName.value,
            processCompleted: true,
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
          applicationRefNo: refNoController.text.trim(),
          submissionDate: submissionDate.value,
          confirmationFileName: confirmationFileName.value,
        ),
      );

      Get.back();

      Get.snackbar(
        'Step 5 Complete',
        '${student.name} moved to Step $nextStep.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Unable to Complete Step 5',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
