import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../../../const/constants.dart';
import '../controller/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.3,
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

                  // ── Logo Image instead of Icon ──
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
                        'assets/images/logo.png',
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
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ── Personal Info Section ──
                        _sectionHeader('Personal Information', Icons.person_outline),
                        const SizedBox(height: 12),

                        // Full Name
                        _buildLabel('Full Name'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          ctrl: controller.fullNameController,
                          hint: 'Enter your full name',
                          icon: Icons.badge_outlined,
                          type: TextInputType.name,
                          validator: controller.validateFullName,
                        ),
                        const SizedBox(height: 14),

                        // Phone Number
                        _buildLabel('Phone Number'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          ctrl: controller.phoneController,
                          hint: 'Enter your 10-digit number',
                          icon: Icons.phone_outlined,
                          type: TextInputType.phone,
                          validator: controller.validatePhone,
                        ),
                        const SizedBox(height: 14),

                        // Email
                        _buildLabel('Email Address'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          ctrl: controller.emailController,
                          hint: 'Enter your email address',
                          icon: Icons.email_outlined,
                          type: TextInputType.emailAddress,
                          validator: controller.validateEmail,
                        ),
                        const SizedBox(height: 14),

                        // Password
                        _buildLabel('Password'),
                        const SizedBox(height: 8),
                        Obx(() => _buildTextField(
                          ctrl: controller.passwordController,
                          hint: 'Create a password',
                          icon: Icons.lock_outline,
                          obscure: !controller.isPasswordVisible.value,
                          validator: controller.validatePassword,
                          suffix: IconButton(
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
                        const SizedBox(height: 14),

                        // Confirm Password
                        _buildLabel('Confirm Password'),
                        const SizedBox(height: 8),
                        Obx(() => _buildTextField(
                          ctrl: controller.confirmPasswordController,
                          hint: 'Re-enter your password',
                          icon: Icons.lock_outline,
                          obscure: !controller.isConfirmPasswordVisible.value,
                          validator: controller.validateConfirmPassword,
                          suffix: IconButton(
                            icon: Icon(
                              controller.isConfirmPasswordVisible.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textGrey,
                              size: 20,
                            ),
                            onPressed: controller.toggleConfirmPasswordVisibility,
                          ),
                        )),

                        const SizedBox(height: 24),

                        // ── Location Section ──
                        _sectionHeader('Location Details', Icons.location_on_outlined),
                        const SizedBox(height: 12),

                        // Street Address
                        _buildLabel('Street Address'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          ctrl: controller.addressController,
                          hint: 'Enter your street address',
                          icon: Icons.home_outlined,
                          type: TextInputType.streetAddress,
                          validator: controller.validateAddress,
                        ),
                        const SizedBox(height: 14),

                        // District
                        _buildLabel('District'),
                        const SizedBox(height: 8),
                        Obx(() => _buildDropdown(
                          value: controller.selectedDistrict.value.isEmpty
                              ? null
                              : controller.selectedDistrict.value,
                          hint: 'Select your district',
                          icon: Icons.location_city_outlined,
                          items: AppConstants.districts,
                          onChanged: controller.setDistrict,
                          validator: (_) => controller.selectedDistrict.value.isEmpty
                              ? 'Please select a district'
                              : null,
                        )),
                        const SizedBox(height: 14),

                        // Province
                        _buildLabel('Province'),
                        const SizedBox(height: 8),
                        Obx(() => _buildDropdown(
                          value: controller.selectedProvince.value.isEmpty
                              ? null
                              : controller.selectedProvince.value,
                          hint: 'Select your province',
                          icon: Icons.map_outlined,
                          items: AppConstants.provinces,
                          onChanged: controller.setProvince,
                          validator: (_) => controller.selectedProvince.value.isEmpty
                              ? 'Please select a province'
                              : null,
                        )),

                        const SizedBox(height: 32),

                        // ── Sign Up button (pill gradient style) ──
                        Obx(() => SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value ? null : controller.signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              disabledBackgroundColor: AppColors.primaryRed.withOpacity(0.6),
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
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        )),

                        const SizedBox(height: 20),

                        // ── Sign in with ──
                        Row(
                          children: [
                            Expanded(
                              child: Divider(color: Colors.grey.shade300, thickness: 1),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'Or sign up with',
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: Colors.grey.shade300, thickness: 1),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Social icons row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _socialIconButton(
                              svgPath: null,
                              icon: Icons.facebook_rounded,
                              color: const Color(0xFF1877F2),
                            ),
                            const SizedBox(width: 20),
                            _socialIconButton(
                              svgPath: null,
                              icon: Icons.g_mobiledata_rounded,
                              color: const Color(0xFFDB4437),
                            ),
                            const SizedBox(width: 20),
                            _socialIconButton(
                              svgPath: null,
                              icon: Icons.apple_rounded,
                              color: Colors.black,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Already have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () => Get.offNamed(AppRoute.login),
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 45),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialIconButton({
    String? svgPath,
    IconData? icon,
    required Color color,
  }) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon ?? Icons.circle, color: color, size: 28),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withOpacity(0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryRed, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(height: 1, color: AppColors.borderGrey),
        ),
      ],
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
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    TextInputType type = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: AppColors.primaryBlue, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: AppColors.errorColor, width: 1.8),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      onChanged: onChanged,
      isExpanded: true,
      menuMaxHeight: 320,
      borderRadius: BorderRadius.circular(18),
      dropdownColor: Colors.white,
      elevation: 8,
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.primaryBlue,
          size: 25,
        ),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 13,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.primaryBlue,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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
          borderSide: const BorderSide(
            color: AppColors.errorColor,
          ),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}