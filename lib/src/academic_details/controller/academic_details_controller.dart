import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/util/app_route.dart';

class AcademicDetailsController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final gpaController = TextEditingController();

  final selectedCountry = ''.obs;
  final selectedPassoutYear = ''.obs;
  final selectedDegree = ''.obs;

  final isLoading = false.obs;
  final showErrors = false.obs;

  bool isEditMode = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['isEdit'] == true) {
      isEditMode = true;
      selectedCountry.value = args['country']?.toString() ?? '';
      selectedPassoutYear.value = args['passoutYear']?.toString() ?? '';
      selectedDegree.value = args['degree']?.toString() ?? '';
      gpaController.text = args['gpa']?.toString() ?? '';
    }
  }

  void setCountry(String? value) => selectedCountry.value = value ?? '';
  void setPassoutYear(String? value) => selectedPassoutYear.value = value ?? '';
  void setDegree(String? value) => selectedDegree.value = value ?? '';

  String? validateGpa(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your GPA';
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return 'Enter a valid number';
    if (parsed < 0 || parsed > 10) return 'GPA should be between 0 and 10';
    return null;
  }

  Future<void> submit() async {
    final formValid = formKey.currentState?.validate() ?? false;
    final countryValid = selectedCountry.value.isNotEmpty;
    final yearValid = selectedPassoutYear.value.isNotEmpty;
    final degreeValid = selectedDegree.value.isNotEmpty;

    if (!formValid || !countryValid || !yearValid || !degreeValid) {
      showErrors.value = true;
      return;
    }

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 600));

      Get.offAllNamed(
        AppRoute.home,
        arguments: {
          'country': selectedCountry.value,
          'gpa': gpaController.text.trim(),
          'passoutYear': selectedPassoutYear.value,
          'degree': selectedDegree.value,
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    gpaController.dispose();
    super.onClose();
  }
}