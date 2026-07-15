import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/students_record.dart';
import '../../students/controller/students_controller.dart';

class Step4Controller extends GetxController {
  final StudentRecord student;
  Step4Controller(this.student);

  final Rxn<DateTime> interviewDate = Rxn<DateTime>();
  final RxnString interviewMode = RxnString();
  final RxnString interviewResult = RxnString();
  final TextEditingController notesController = TextEditingController();

  // Button only goes full-color once all three are picked.
  bool get isComplete =>
      interviewDate.value != null && interviewMode.value != null && interviewResult.value != null;

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: interviewDate.value ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) interviewDate.value = picked;
  }

  void setMode(String mode) => interviewMode.value = mode;
  void setResult(String result) => interviewResult.value = result;

  String get formattedDate {
    final d = interviewDate.value;
    if (d == null) return '';
    return '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';
  }

  void submit() {
    if (!isComplete) return;

    Get.find<StudentsController>().updateStudent(
      student.id,
          (current) => current.copyWith(
        currentStep: 5,
        interviewDate: interviewDate.value,
        interviewMode: interviewMode.value,
        interviewResult: interviewResult.value,
        interviewNotes: notesController.text,
      ),
    );

    Get.back();
    Get.snackbar(
      'Step 4 Complete',
      '${student.name} moved to Step 5.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFF59E0B),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}