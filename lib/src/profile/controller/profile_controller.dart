import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  // Same 4 fields as HomeController, read from the same in-memory
  // Get.arguments — no storage, no duplication of state.
  final country = ''.obs;
  final gpa = ''.obs;
  final passoutYear = ''.obs;
  final degree = ''.obs;

  // Profile photo picked via camera or gallery.
  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

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
        'Error',
        source == ImageSource.camera
            ? 'Could not open camera.'
            : 'Could not open gallery.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // TODO: replace with the real logged-in user's name/email once auth
  // exists. Nothing in the current flow (login just validates email +
  // password length) actually carries the user's name/email forward.
  final userName = 'Student'.obs;
  final userEmail = ''.obs;

  final notificationCount = 4.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      country.value = args['country']?.toString() ?? '';
      gpa.value = args['gpa']?.toString() ?? '';
      passoutYear.value = args['passoutYear']?.toString() ?? '';
      degree.value = args['degree']?.toString() ?? '';
    }
  }

  String get initials {
    final parts = userName.value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }
}