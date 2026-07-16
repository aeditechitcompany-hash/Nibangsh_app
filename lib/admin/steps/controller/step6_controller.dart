import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/students_record.dart';
import '../../students/controller/students_controller.dart';

class Step6Controller extends GetxController {
  final StudentRecord student;
  Step6Controller(this.student);

  final RxnString offerFileName = RxnString();
  final RxnString offerType = RxnString();
  final Rxn<DateTime> offerExpiryDate = Rxn<DateTime>();

  bool get isComplete =>
      offerFileName.value != null &&
          offerType.value != null &&
          offerExpiryDate.value != null;

  void browseForFile() {
    offerFileName.value = 'offer_letter.pdf';
  }

  void setOfferType(String type) => offerType.value = type;

  Future<void> pickExpiryDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: offerExpiryDate.value ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) offerExpiryDate.value = picked;
  }

  String get formattedExpiryDate {
    final d = offerExpiryDate.value;
    if (d == null) return '';
    return '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';
  }

  void submit() {
    if (!isComplete) return;

    Get.find<StudentsController>().updateStudent(
      student.id,
          (current) => current.copyWith(
        currentStep: 7,
        offerFileName: offerFileName.value,
        offerType: offerType.value,
        offerExpiryDate: offerExpiryDate.value,
      ),
    );

    Get.back();
    Get.snackbar(
      'Step 6 Complete',
      '${student.name} moved to Step 7.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFDC2626),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}