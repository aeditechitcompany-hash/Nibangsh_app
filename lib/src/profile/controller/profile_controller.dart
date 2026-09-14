import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/services/storage.dart';
import '../../../common/api_services/academic_details_service.dart';

class ProfileController extends GetxController {
  final country = ''.obs;
  final gpa = ''.obs;
  final gpaScale = ''.obs;
  final grade = ''.obs;
  final passoutYear = ''.obs;
  final degree = ''.obs;

  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;
  final userRole = ''.obs;

  final notificationCount = 4.obs;

  final AcademicDetailsService _academicDetailsService =
  AcademicDetailsService();

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    // --------------------------------------------------
    // USER INFORMATION
    // --------------------------------------------------

    userName.value = await StorageService.getUserName() ?? "Student";
    userEmail.value = await StorageService.getUserEmail() ?? "";
    userPhone.value = await StorageService.getUserPhone() ?? "";
    userRole.value = await StorageService.getUserRole() ?? "";

    // --------------------------------------------------
    // ACADEMIC DETAILS FROM DATABASE
    // --------------------------------------------------

    try {
      final academic =
      await _academicDetailsService.getMyAcademicDetails();

      if (academic != null) {
        // GPA
        country.value = academic['country_name']?.toString() ?? '';

        // If backend returns country as an ID instead of country_name,
        // this will remain empty. We handle that below.
        gpa.value =
            academic['gpa']?.toString() ?? '';

        gpaScale.value =
            academic['gpa_scale']?.toString() ?? '';

        grade.value =
            academic['grade']?.toString() ?? '';

        passoutYear.value =
            academic['passout_year']?.toString() ?? '';
        // Django stores:
        // bachelor
        // master
        // phd
        //
        // Flutter displays:
        // Bachelors
        // Masters
        // PHD
        degree.value = _formatDegree(
          academic['degree_level']?.toString() ?? '',
        );
      }
    } catch (e) {
      debugPrint(
        'PROFILE ACADEMIC DETAILS ERROR: $e',
      );
    }
  }

  // --------------------------------------------------
  // Convert Django degree values to Flutter labels
  // --------------------------------------------------

  String _formatDegree(String value) {
    switch (value.toLowerCase()) {
      case 'bachelor':
        return 'Bachelors';

      case 'master':
        return 'Masters';

      case 'phd':
        return 'PHD';

      case 'high_school':
        return 'High School';

      case 'diploma':
        return 'Diploma';

      default:
        return value;
    }
  }

  // --------------------------------------------------
  // PROFILE IMAGE
  // --------------------------------------------------

  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (picked != null) {
        profileImage.value = File(picked.path);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        source == ImageSource.camera
            ? "Could not open camera."
            : "Could not open gallery.",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // --------------------------------------------------
  // INITIALS
  // --------------------------------------------------

  String get initials {
    final name = userName.value.trim();

    if (name.isEmpty) return "?";

    final parts = name
        .split(RegExp(r'[\s._-]+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (parts.first.substring(0, 1) +
        parts.last.substring(0, 1))
        .toUpperCase();
  }
}