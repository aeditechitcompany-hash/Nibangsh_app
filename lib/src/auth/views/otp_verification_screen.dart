import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/otp_verification_controller.dart';

class OtpVerificationScreen
    extends StatelessWidget {
  OtpVerificationScreen({super.key});

  final controller =
  Get.put(OtpVerificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify OTP',
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,

              children: [
                const SizedBox(height: 40),

                const Text(
                  'Enter Verification Code',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Enter the 6-digit OTP sent to your email.',
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller:
                  controller.otpController,

                  keyboardType:
                  TextInputType.number,

                  maxLength: 6,

                  textAlign:
                  TextAlign.center,

                  decoration:
                  const InputDecoration(
                    labelText: 'OTP',
                    border:
                    OutlineInputBorder(),
                  ),

                  validator:
                  controller.validateOtp,
                ),

                const SizedBox(height: 24),

                Obx(
                      () => ElevatedButton(
                    onPressed:
                    controller.isLoading.value
                        ? null
                        : controller.verifyOTP,

                    child:
                    controller.isLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child:
                      CircularProgressIndicator(),
                    )
                        : const Text(
                      'Verify OTP',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}