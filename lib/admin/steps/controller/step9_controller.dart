import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    if (picked != null) letterFileName.value = picked.name;
  }

  void submit() {
    if (!isComplete) return;

    Get.find<StudentsController>().updateStudent(
      student.id,
      (current) => current.copyWith(
        currentStep: 10,
        visaRefNo: refNoController.text.trim(),
        visaStatusUpdate: visaStatusUpdate.value,
        visaApprovalLetterFileName: letterFileName.value,
        visaStatus: visaStatusUpdate.value == statusApproved
            ? 'Approved'
            : visaStatusUpdate.value == statusRejected
            ? 'Rejected'
            : 'Processing',
      ),
    );

    Get.back();
    Get.snackbar(
      'Step 9 Complete',
      '${student.name} moved to Step 10.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFDC2626),
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
