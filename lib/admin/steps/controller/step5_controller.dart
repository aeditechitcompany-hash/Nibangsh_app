import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  void submit() {
    if (!isComplete) return;

    Get.find<StudentsController>().updateStudent(
      student.id,
      (current) => current.copyWith(
        currentStep: 6,
        applicationRefNo: refNoController.text.trim(),
        submissionDate: submissionDate.value,
        confirmationFileName: confirmationFileName.value,
      ),
    );

    Get.back();
    Get.snackbar(
      'Step 5 Complete',
      '${student.name} moved to Step 6.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF16A34A),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    refNoController.dispose();
    super.onClose();
  }
}
