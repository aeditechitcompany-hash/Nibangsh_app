import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../controller/login_controller.dart';

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
              height: size.height * 0.32,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.darkRed, AppColors.primaryRed, AppColors.primaryBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipOval(child: Image.asset("assets/images/logo.png", width: 42, height: 42)),
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
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sign in to your account',
                      style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 28),

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
                    Obx(() => _buildTextField(
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
                    )),
                    const SizedBox(height: 12),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Sign In button
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          disabledBackgroundColor: AppColors.primaryRed.withOpacity(0.6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 3,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                            : const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                    )),

                    const SizedBox(height: 24),

                    // OR divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Social buttons
                    Row(
                      children: [
                        // Google
                        Expanded(
                          child: _buildSocialButton(
                            label: 'Google',
                            bgColor: Colors.white,
                            borderColor: Colors.grey.shade300,
                            textColor: AppColors.textDark,
                            icon: _googleIcon(),
                            onTap: controller.signInWithGoogle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Facebook
                        Expanded(
                          child: _buildSocialButton(
                            label: 'Facebook',
                            bgColor: const Color(0xFF1877F2),
                            borderColor: const Color(0xFF1877F2),
                            textColor: Colors.white,
                            icon: const Icon(Icons.facebook_rounded, color: Colors.white, size: 20),
                            onTap: controller.signInWithFacebook,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Email
                        Expanded(
                          child: _buildSocialButton(
                            label: 'Email',
                            bgColor: const Color(0xFFEA4335),
                            borderColor: const Color(0xFFEA4335),
                            textColor: Colors.white,
                            icon: const Icon(Icons.mail_rounded, color: Colors.white, size: 20),
                            onTap: controller.signInWithEmail,
                          ),
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
                          style: TextStyle(color: AppColors.textGrey, fontSize: 14),
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

                    const SizedBox(height: 32),
                  ],
                ),
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
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.8),
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

  Widget _buildSocialButton({
    required String label,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hand-drawn Google "G" using a styled text widget
  Widget _googleIcon() {
    return const Text(
      'G',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4285F4),
        fontFamily: 'serif',
      ),
    );
  }
}