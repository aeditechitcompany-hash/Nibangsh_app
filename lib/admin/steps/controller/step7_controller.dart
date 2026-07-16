import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  final RxnString locFileName = RxnString();
  final RxBool isVerified = false.obs;

  bool get canMarkVerified => locFileName.value != null;

  /// Simulates picking a file. Swap for file_picker / image_picker
  /// package logic when a real file chooser is wired up.
  void browseForFile() {
    locFileName.value = 'loc_document.pdf';
  }

  void markVerified() {
    if (!canMarkVerified) return;
    isVerified.value = true;
  }

  void submit() {
    if (!isVerified.value) return;

    Get.find<StudentsController>().updateStudent(
      student.id,
          (current) => current.copyWith(
        currentStep: 8,
        locFileName: locFileName.value,
        locVerified: true,
      ),
    );

    Get.back();
    Get.snackbar(
      'Step 7 Complete',
      '${student.name} moved to Step 8.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4F46E5),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}