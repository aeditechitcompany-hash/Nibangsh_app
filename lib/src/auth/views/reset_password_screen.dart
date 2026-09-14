import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/reset_password_controller.dart';

class ResetPasswordScreen
    extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final controller =
  Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text('Reset Password'),
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
                  'Create New Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                Obx(
                      () => TextFormField(
                    controller:
                    controller.newPasswordController,

                    obscureText:
                    !controller
                        .isNewPasswordVisible
                        .value,

                    decoration:
                    InputDecoration(
                      labelText:
                      'New Password',

                      border:
                      const OutlineInputBorder(),

                      suffixIcon:
                      IconButton(
                        icon: Icon(
                          controller
                              .isNewPasswordVisible
                              .value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),

                        onPressed: () {
                          controller
                              .isNewPasswordVisible
                              .value =
                          !controller
                              .isNewPasswordVisible
                              .value;
                        },
                      ),
                    ),

                    validator:
                    controller.validatePassword,
                  ),
                ),

                const SizedBox(height: 20),

                Obx(
                      () => TextFormField(
                    controller:
                    controller.confirmPasswordController,

                    obscureText:
                    !controller
                        .isConfirmPasswordVisible
                        .value,

                    decoration:
                    InputDecoration(
                      labelText:
                      'Confirm Password',

                      border:
                      const OutlineInputBorder(),

                      suffixIcon:
                      IconButton(
                        icon: Icon(
                          controller
                              .isConfirmPasswordVisible
                              .value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),

                        onPressed: () {
                          controller
                              .isConfirmPasswordVisible
                              .value =
                          !controller
                              .isConfirmPasswordVisible
                              .value;
                        },
                      ),
                    ),

                    validator:
                    controller
                        .validateConfirmPassword,
                  ),
                ),

                const SizedBox(height: 30),

                Obx(
                      () => ElevatedButton(
                    onPressed:
                    controller.isLoading.value
                        ? null
                        : controller.resetPassword,

                    child:
                    controller.isLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child:
                      CircularProgressIndicator(),
                    )
                        : const Text(
                      'Reset Password',
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