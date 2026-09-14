import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/api_services/auth_service.dart';
import '../../../common/util/app_route.dart';

class ResetPasswordController
    extends GetxController {
  final AuthService _authService =
  AuthService();

  final newPasswordController =
  TextEditingController();

  final confirmPasswordController =
  TextEditingController();

  final RxBool isLoading = false.obs;

  final RxBool isNewPasswordVisible =
      false.obs;

  final RxBool isConfirmPasswordVisible =
      false.obs;

  final formKey =
  GlobalKey<FormState>();

  late final String resetToken;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map) {
      resetToken =
          args['reset_token']?.toString() ?? '';
    } else {
      resetToken = '';
    }
  }

  String? validatePassword(
      String? value) {
    if (value == null ||
        value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]')
        .hasMatch(value)) {
      return 'Password must contain an uppercase letter';
    }

    if (!RegExp(r'[a-z]')
        .hasMatch(value)) {
      return 'Password must contain a lowercase letter';
    }

    if (!RegExp(r'[0-9]')
        .hasMatch(value)) {
      return 'Password must contain a number';
    }

    if (!RegExp(
      r'[!@#$&*~%^()_\-+=\[\]{};:,.<>?/\\|`]',
    ).hasMatch(value)) {
      return 'Password must contain a special character';
    }

    return null;
  }

  String? validateConfirmPassword(
      String? value) {
    if (value == null ||
        value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value !=
        newPasswordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (resetToken.isEmpty) {
      Get.snackbar(
        'Error',
        'Invalid or expired reset session.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      await _authService.resetPassword(
        resetToken: resetToken,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      // Stop loading BEFORE leaving this screen.
      isLoading.value = false;

      // Now navigate away. This can dispose this controller.
      Get.offAllNamed(AppRoute.login);

      Get.snackbar(
        'Success',
        'Your password has been reset. Please login.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading.value = false;

      Get.snackbar(
        'Reset Failed',
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}