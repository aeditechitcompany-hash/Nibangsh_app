import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/api_services/auth_service.dart';
import '../../../common/util/app_route.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = AuthService();

  final emailController = TextEditingController();

  final RxBool isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!GetUtils.isEmail(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  Future<void> sendResetOTP() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text.trim();

    isLoading.value = true;

    try {
      await _authService.forgotPassword(
        email: email,
      );

      Get.toNamed(
        AppRoute.otpVerification,
        arguments: {
          'email': email,
        },
      );
    } catch (e) {
      Get.snackbar(
        'Request Failed',
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}