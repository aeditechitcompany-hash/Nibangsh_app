import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/api_services/process_service.dart';
import '../../../common/api_services/student_application_service.dart';
import '../../../common/services/document_picker_service.dart';
import '../../model/students_record.dart';
import '../../students/controller/students_controller.dart';

class Step6Controller extends GetxController {
  final StudentRecord student;
  Step6Controller(this.student);

  final ProcessService _processService = ProcessService();
  final StudentApplicationService _applicationService =
  StudentApplicationService();
  final RxnString offerFileName = RxnString();
  final RxnString offerType = RxnString();
  final Rxn<DateTime> offerExpiryDate = Rxn<DateTime>();

  final isSubmitting = false.obs;

  bool get isComplete =>
      offerFileName.value != null &&
          offerType.value != null &&
          offerExpiryDate.value != null;

  Future<void> browseForFile() async {
    final picked = await DocumentPickerService.pickDocument();

    if (picked != null) {
      offerFileName.value = picked.name;
    }
  }

  void setOfferType(String type) {
    offerType.value = type;
  }

  Future<void> pickExpiryDate(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: offerExpiryDate.value ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );

    if (picked != null) {
      offerExpiryDate.value = picked;
    }
  }

  String get formattedExpiryDate {
    final d = offerExpiryDate.value;

    if (d == null) return '';

    return '${d.month.toString().padLeft(2, '0')}/'
        '${d.day.toString().padLeft(2, '0')}/'
        '${d.year}';
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
        'offer_type': ?offerType.value,
        'offer_expiry_date': ?offerExpiryDate.value
            ?.toIso8601String()
            .split('T')
            .first,
      },
        files: {
          'offer_file': File(offerFileName.value!),
        },

      );

      final response = await _processService.completeStage(
        processId: processId,
      );

      final finished = response['finished'] == true;
      final currentStage = response['current_stage'];

      // Final process completion
      if (finished) {
        Get.find<StudentsController>().updateStudent(
          student.id,
              (current) => current.copyWith(
            offerFileName: offerFileName.value,
            offerType: offerType.value,
            offerExpiryDate: offerExpiryDate.value,
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

      // Update Flutter only AFTER backend successfully completed
      // the current process stage.
      Get.find<StudentsController>().updateStudent(
        student.id,
            (current) => current.copyWith(
          currentStep: nextStep,
          offerFileName: offerFileName.value,
          offerType: offerType.value,
          offerExpiryDate: offerExpiryDate.value,
        ),
      );

      Get.back();

      Get.snackbar(
        'Step 6 Complete',
        '${student.name} moved to Step $nextStep.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Unable to Complete Step 6',
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