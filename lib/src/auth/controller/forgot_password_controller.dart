import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isEmailSent = false.obs;
  final formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(value)) return 'Enter a valid email address';
    return null;
  }

  // Sends a password reset link to the entered email
  Future<void> sendResetLink() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      // TODO: replace with real backend call (e.g. Firebase Auth
      // sendPasswordResetEmail) once available.
      await Future.delayed(const Duration(seconds: 2));
      isEmailSent.value = true;
    } catch (e) {
      _showError('Request Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendLink() async {
    isEmailSent.value = false;
    await sendResetLink();
  }

  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}