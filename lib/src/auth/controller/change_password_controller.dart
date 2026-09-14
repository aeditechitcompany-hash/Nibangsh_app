import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/api_services/auth_service.dart';

class ChangePasswordController extends GetxController {
  final AuthService _authService = AuthService();

  final currentPasswordController =
  TextEditingController();

  final newPasswordController =
  TextEditingController();

  final confirmPasswordController =
  TextEditingController();

  final RxBool isLoading = false.obs;

  final RxBool isCurrentPasswordVisible =
      false.obs;

  final RxBool isNewPasswordVisible =
      false.obs;

  final RxBool isConfirmPasswordVisible =
      false.obs;

  final formKey =
  GlobalKey<FormState>();

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value =
    !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value =
    !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value =
    !isConfirmPasswordVisible.value;
  }

  String? validateCurrentPassword(
      String? value) {
    if (value == null ||
        value.isEmpty) {
      return 'Current password is required';
    }

    return null;
  }

  String? validateNewPassword(
      String? value) {
    if (value == null ||
        value.isEmpty) {
      return 'New password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must contain at least one uppercase letter (A-Z)';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must contain at least one lowercase letter (a-z)';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must contain at least one number (0-9)';
    }

    if (!RegExp(
      r'[!@#\$&*~%^()_\-+=\[\]{};:,.<>?/\\|`]',
    ).hasMatch(value)) {
      return 'Must contain at least one special character (!@#\$&*~)';
    }

    if (value ==
        currentPasswordController.text) {
      return 'New password must be different from current password';
    }

    return null;
  }

  String? validateConfirmPassword(
      String? value) {
    if (value == null ||
        value.isEmpty) {
      return 'Please confirm your new password';
    }

    if (value !=
        newPasswordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      await _authService.changePassword(
        currentPassword:
        currentPasswordController.text,

        newPassword:
        newPasswordController.text,

        confirmPassword:
        confirmPasswordController.text,
      );

      Get.back();

      Get.snackbar(
        'Success!',
        'Your password has been changed successfully.',
        snackPosition:
        SnackPosition.BOTTOM,
        backgroundColor:
        Colors.green.shade700,
        colorText: Colors.white,
        margin:
        const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      _showError(
        'Change Password Failed',
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(
      String title,
      String message,
      ) {
    Get.snackbar(
      title,
      message,
      snackPosition:
      SnackPosition.BOTTOM,
      backgroundColor:
      Colors.red.shade700,
      colorText: Colors.white,
      margin:
      const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}