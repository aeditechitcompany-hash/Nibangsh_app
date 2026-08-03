import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/services/storage.dart';

class ProfileController extends GetxController {
  final country = ''.obs;
  final gpa = ''.obs;
  final passoutYear = ''.obs;
  final degree = ''.obs;

  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;
  final userRole = ''.obs;

  final notificationCount = 4.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    userName.value = await StorageService.getUserName() ?? "Student";
    userEmail.value = await StorageService.getUserEmail() ?? "";
    userPhone.value = await StorageService.getUserPhone() ?? "";
    userRole.value = await StorageService.getUserRole() ?? "";

    final args = Get.arguments;

    if (args is Map) {
      country.value = args["country"]?.toString() ?? "";
      gpa.value = args["gpa"]?.toString() ?? "";
      passoutYear.value = args["passoutYear"]?.toString() ?? "";
      degree.value = args["degree"]?.toString() ?? "";
    }
  }

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