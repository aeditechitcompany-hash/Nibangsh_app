import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  void submit() {
    if (!isComplete) return;

    Get.find<StudentsController>().updateStudent(
      student.id,
      (current) => current.copyWith(
        currentStep: 9,
        courseCommencementDate: commencementDate.value,
        scholarshipStatus: scholarshipStatus.value,
        finalSelectionNotes: notesController.text,
        finalSelectionConfirmed: true,
      ),
    );

    Get.back();
    Get.snackbar(
      'Step 8 Complete',
      '${student.name} moved to Step 9.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF16A34A),
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
