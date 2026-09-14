import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibangsh_consultancy/const/resources.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../controller/login_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.navyDark, AppColors.navyLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.responsive(
                    mobile: 40.0,
                    tablet: 48.0,
                    laptop: 56.0,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          AppResources.logoPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      'Nibangsh Consultancy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your Gateway to Global Education',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Form
            ResponsiveWrapper(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 4),



// Account Type
                      const Text(
                        'Sign in to your account',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textGrey,
                        ),
                      ),

                      const SizedBox(height: 24),
                      // Account Type
                      _buildLabel('Account Type'),

                      const SizedBox(height: 8),

                      Obx(
                            () => Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.borderGrey,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildRoleButton(
                                  controller: controller,
                                  role: 'student',
                                  label: 'Student',
                                  icon: Icons.school_outlined,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: _buildRoleButton(
                                  controller: controller,
                                  role: 'ubt',
                                  label: 'UBT',
                                  icon: Icons.business_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

// Email


// Email
                      _buildLabel('Email Address'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: controller.emailController,
                        hintText: 'Enter your email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.validateEmail,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      _buildLabel('Password'),
                      const SizedBox(height: 8),
                      Obx(
                            () => _buildTextField(
                          controller: controller.passwordController,
                          hintText: 'Enter your password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: !controller.isPasswordVisible.value,
                          validator: controller.validatePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textGrey,
                              size: 20,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Get.toNamed(AppRoute.forgotPassword),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Sign In button
                      Obx(
                            () => SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.navyLight,
                              disabledBackgroundColor: AppColors.darkBlue
                                  .withOpacity(0.6),
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
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // OR divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or continue with',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ── Circular Social Buttons ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google
                          _buildSocialCircle(
                            onTap: controller.signInWithGoogle,
                            child: Image.asset(
                              AppResources.googleIcon,
                              width: 22,
                              height: 22,
                            ),
                            shadow: Colors.grey.withOpacity(0.2),
                          ),
                          const SizedBox(width: 20),

                          // Facebook
                          _buildSocialCircle(
                            onTap: controller.signInWithFacebook,
                            child: Image.asset(
                              AppResources.fbIcon,
                              width: 22,
                              height: 22,
                            ),
                            shadow: AppColors.darkBlue.withOpacity(0.2),
                          ),
                          const SizedBox(width: 20),

                          // Gmail
                          _buildSocialCircle(
                            onTap: controller.signInWithEmail,
                            child: Image.asset(
                              AppResources.emailIcon,
                              width: 22,
                              height: 22,
                            ),
                            shadow: AppColors.primaryBlue.withOpacity(0.2),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Sign Up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoute.signup),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required LoginController controller,
    required String role,
    required String label,
    required IconData icon,
  }) {
    final isSelected =
        controller.selectedRole.value == role;

    return GestureDetector(
      onTap: () {
        controller.selectRole(role);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.navyLight
              : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: isSelected
                  ? Colors.white
                  : AppColors.textGrey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: AppColors.primaryBlue, size: 20),
        suffixIcon: suffixIcon,
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

  // ── Helper for circular social design ──
  Widget _buildSocialCircle({
    required VoidCallback onTap,
    required Widget child,
    required Color shadow,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}