import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/api_services/auth_service.dart';
import '../../../common/util/app_route.dart';

class OtpVerificationController extends GetxController {
  final AuthService _authService =
  AuthService();

  final otpController =
  TextEditingController();

  final RxBool isLoading = false.obs;

  late final String email;

  final formKey =
  GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map &&
        args['email'] != null &&
        args['email'].toString().trim().isNotEmpty) {
      email = args['email'].toString().trim();
    } else {
      email = '';
    }
  }

  String? validateOtp(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'OTP is required';
    }

    if (!RegExp(r'^\d{6}$')
        .hasMatch(value.trim())) {
      return 'Enter the 6-digit OTP';
    }

    return null;
  }

  Future<void> verifyOTP() async {
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Email information is missing. Please start the password reset again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final resetToken =
      await _authService.verifyPasswordResetOTP(
        email: email,
        code: otpController.text.trim(),
      );

      Get.toNamed(
        AppRoute.resetPassword,
        arguments: {
          'reset_token': resetToken,
        },
      );
    } catch (e) {
      Get.snackbar(
        'Verification Failed',
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}