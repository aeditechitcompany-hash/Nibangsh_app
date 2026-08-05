import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/services/storage.dart';
import '../../../common/util/app_route.dart';
import '../../home/controller/home_controller.dart';
import '../../profile/controller/profile_controller.dart';

class AcademicDetailsController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final gpaController = TextEditingController();

  final selectedCountry = ''.obs;
  final selectedPassoutYear = ''.obs;
  final selectedDegree = ''.obs;

  final isLoading = false.obs;
  final showErrors = false.obs;

  bool isEditMode = false;
  String _email = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      _email = args['email']?.toString() ?? '';
      if (args['isEdit'] == true) {
        isEditMode = true;
        selectedCountry.value = args['country']?.toString() ?? '';
        selectedPassoutYear.value = args['passoutYear']?.toString() ?? '';
        selectedDegree.value = args['degree']?.toString() ?? '';
        gpaController.text = args['gpa']?.toString() ?? '';
      }
    }
  }

  void setCountry(String? value) => selectedCountry.value = value ?? '';
  void setPassoutYear(String? value) => selectedPassoutYear.value = value ?? '';
  void setDegree(String? value) => selectedDegree.value = value ?? '';

  String? validateGpa(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your GPA';
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return 'Enter a valid number';
    if (parsed < 0.0 || parsed > 4.0)
      return 'GPA should be between 0.0 and 4.0';
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
    late final String gpa;
    try {
      await Future.delayed(const Duration(milliseconds: 600));

      gpa = gpaController.text.trim();

      // Persist so Home (and Profile) can read these back later,
      // regardless of how the user navigates there.
      await StorageService.saveAcademicDetails(
        country: selectedCountry.value,
        gpa: gpa,
        passoutYear: selectedPassoutYear.value,
        degree: selectedDegree.value,
      );

      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.country.value = selectedCountry.value;
        homeController.gpa.value = gpa;
        homeController.passoutYear.value = selectedPassoutYear.value;
        homeController.degree.value = selectedDegree.value;
      }

      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        profileController.country.value = selectedCountry.value;
        profileController.gpa.value = gpa;
        profileController.passoutYear.value = selectedPassoutYear.value;
        profileController.degree.value = selectedDegree.value;
      }
    } finally {
      isLoading.value = false;
    }

    if (isEditMode) {
      Get.back();
    } else {
      Get.offAllNamed(
        AppRoute.home,
        arguments: {
          'email': _email,
          'country': selectedCountry.value,
          'gpa': gpa,
          'passoutYear': selectedPassoutYear.value,
          'degree': selectedDegree.value,
        },
      );
    }
  }

  @override
  void onClose() {
    gpaController.dispose();
    super.onClose();
  }
}
