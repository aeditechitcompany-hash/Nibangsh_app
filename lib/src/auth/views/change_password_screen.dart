import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/util/app_colors.dart';
import '../controller/change_password_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20.5,
          ),
        ),
      ),
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.primaryBlue,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Update your password',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Enter your current password and choose a new one to '
                      'keep your account secure.',
                  style: TextStyle(fontSize: 16, color: AppColors.textGrey),
                ),
                const SizedBox(height: 28),

                // Current Password
                _buildLabel('Current Password'),
                const SizedBox(height: 8),
                Obx(
                      () => _buildPasswordField(
                    controller: controller.currentPasswordController,
                    hintText: 'Enter current password',
                    obscureText: !controller.isCurrentPasswordVisible.value,
                    validator: controller.validateCurrentPassword,
                    onToggleVisibility:
                    controller.toggleCurrentPasswordVisibility,
                    isVisible: controller.isCurrentPasswordVisible.value,
                  ),
                ),
                const SizedBox(height: 16),

                // New Password
                _buildLabel('New Password'),
                const SizedBox(height: 8),
                Obx(
                      () => _buildPasswordField(
                    controller: controller.newPasswordController,
                    hintText: 'Enter new password',
                    obscureText: !controller.isNewPasswordVisible.value,
                    validator: controller.validateNewPassword,
                    onToggleVisibility: controller.toggleNewPasswordVisibility,
                    isVisible: controller.isNewPasswordVisible.value,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Min. 8 characters with uppercase, lowercase, number '
                      '& special character.',
                  style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                ),
                const SizedBox(height: 16),

                // Confirm New Password
                _buildLabel('Confirm New Password'),
                const SizedBox(height: 8),
                Obx(
                      () => _buildPasswordField(
                    controller: controller.confirmPasswordController,
                    hintText: 'Re-enter new password',
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    validator: controller.validateConfirmPassword,
                    onToggleVisibility:
                    controller.toggleConfirmPasswordVisibility,
                    isVisible: controller.isConfirmPasswordVisible.value,
                  ),
                ),
                const SizedBox(height: 32),

                Obx(
                      () => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navyLight,
                        disabledBackgroundColor: AppColors.darkBlue.withOpacity(
                          0.6,
                        ),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : const Text(
                        'Update Password',
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(fontSize: 16, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 16),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppColors.primaryBlue,
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.textGrey,
            size: 20,
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 1.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1.8),
        ),
      ),
    );
  }
}