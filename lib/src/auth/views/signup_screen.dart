import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibangsh_consultancy/const/resources.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../../../const/constants.dart';
import '../controller/signup_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.navyDark,
                    AppColors.navyLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.responsive(
                    mobile: 32.0,
                    tablet: 40.0,
                    laptop: 48.0,
                  ),
                ),
                child: Column(
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

            const SizedBox(height: 24),

            ResponsiveWrapper(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        'Account Type',
                        Icons.manage_accounts_outlined,
                      ),
                      const SizedBox(height: 12),

                      Obx(
                            () => Row(
                          children: [
                            Expanded(
                              child: _buildRoleCard(
                                title: 'Student',
                                subtitle: 'For students',
                                icon: Icons.school_outlined,
                                selected:
                                controller.selectedRole.value ==
                                    'student',
                                onTap: () {
                                  controller.selectRole('student');
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildRoleCard(
                                title: 'UBT',
                                subtitle: 'For UBT',
                                icon: Icons.business_center_outlined,
                                selected:
                                controller.selectedRole.value ==
                                    'ubt',
                                onTap: () {
                                  controller.selectRole('ubt');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      _sectionHeader(
                        'Personal Information',
                        Icons.person_outline,
                      ),
                      const SizedBox(height: 12),

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


                      Obx(
                            () => DropdownButtonFormField<String>(
                          value: controller.referralType.value.isEmpty
                              ? null
                              : controller.referralType.value,
                          decoration: const InputDecoration(
                            labelText: 'Referral Type',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'individual',
                              child: Text('Individual'),
                            ),
                            DropdownMenuItem(
                              value: 'institute',
                              child: Text('Institute'),
                            ),
                          ],
                          onChanged: (value) {
                            controller.referralType.value = value ?? '';

                            if (value == 'individual') {
                              controller.referralInstituteController.clear();
                            } else if (value == 'institute') {
                              controller.referralNameController.clear();
                            }
                          },
                        ),
                      ),

                      Obx(() {
                        if (controller.referralType.value == 'individual') {
                          return TextFormField(
                            controller: controller.referralNameController,
                            decoration: const InputDecoration(
                              labelText: 'Referral Name',
                            ),
                          );
                        }

                        if (controller.referralType.value == 'institute') {
                          return TextFormField(
                            controller: controller.referralInstituteController,
                            decoration: const InputDecoration(
                              labelText: 'Institute Name',
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      }),

                      const SizedBox(height: 14),

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

                      _buildLabel('Password'),
                      const SizedBox(height: 8),
                      Obx(
                            () => _buildTextField(
                          ctrl: controller.passwordController,
                          hint: 'Create a password',
                          icon: Icons.lock_outline,
                          obscure:
                          !controller.isPasswordVisible.value,
                          validator: controller.validatePassword,
                          suffix: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textGrey,
                              size: 20,
                            ),
                            onPressed:
                            controller.togglePasswordVisibility,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      _buildLabel('Confirm Password'),
                      const SizedBox(height: 8),
                      Obx(
                            () => _buildTextField(
                          ctrl:
                          controller.confirmPasswordController,
                          hint: 'Re-enter your password',
                          icon: Icons.lock_outline,
                          obscure: !controller
                              .isConfirmPasswordVisible.value,
                          validator:
                          controller.validateConfirmPassword,
                          suffix: IconButton(
                            icon: Icon(
                              controller
                                  .isConfirmPasswordVisible
                                  .value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textGrey,
                              size: 20,
                            ),
                            onPressed: controller
                                .toggleConfirmPasswordVisibility,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Obx(
                            () {
                          if (!controller.isStudent) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              _sectionHeader(
                                'Location Details',
                                Icons.location_on_outlined,
                              ),
                              const SizedBox(height: 12),

                              _buildLabel('Street Address'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                ctrl: controller.addressController,
                                hint: 'Enter your street address',
                                icon: Icons.home_outlined,
                                type:
                                TextInputType.streetAddress,
                                validator:
                                controller.validateAddress,
                              ),

                              const SizedBox(height: 14),

                              _buildLabel('District'),
                              const SizedBox(height: 8),
                              _buildDropdown(
                                value: controller
                                    .selectedDistrict
                                    .value
                                    .isEmpty
                                    ? null
                                    : controller
                                    .selectedDistrict.value,
                                hint: 'Select your district',
                                icon:
                                Icons.location_city_outlined,
                                items: AppConstants.districts,
                                onChanged:
                                controller.setDistrict,
                                validator: (_) {
                                  if (controller
                                      .selectedDistrict
                                      .value
                                      .isEmpty) {
                                    return 'Please select a district';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 14),

                              _buildLabel('Province'),
                              const SizedBox(height: 8),
                              _buildDropdown(
                                value: controller
                                    .selectedProvince
                                    .value
                                    .isEmpty
                                    ? null
                                    : controller
                                    .selectedProvince.value,
                                hint: 'Select your province',
                                icon: Icons.map_outlined,
                                items: AppConstants.provinces,
                                onChanged:
                                controller.setProvince,
                                validator: (_) {
                                  if (controller
                                      .selectedProvince
                                      .value
                                      .isEmpty) {
                                    return 'Please select a province';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      Obx(
                            () => SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              AppColors.navyLight,
                              disabledBackgroundColor:
                              AppColors.navyLight
                                  .withOpacity(0.6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(14),
                              ),
                              elevation: 3,
                            ),
                            child: controller.isLoading.value
                                ? const SizedBox(
                              height: 22,
                              width: 22,
                              child:
                              CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Text(
                              'or continue with',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          _buildSocialCircle(
                            onTap:
                            controller.signInWithGoogle,
                            child: Image.asset(
                              AppResources.googleIcon,
                              width: 22,
                              height: 22,
                            ),
                            shadow:
                            Colors.grey.withOpacity(0.2),
                          ),
                          const SizedBox(width: 20),
                          _buildSocialCircle(
                            onTap:
                            controller.signInWithFacebook,
                            child: Image.asset(
                              AppResources.fbIcon,
                              width: 22,
                              height: 22,
                            ),
                            shadow: AppColors.darkBlue
                                .withOpacity(0.2),
                          ),
                          const SizedBox(width: 20),
                          _buildSocialCircle(
                            onTap:
                            controller.signInWithEmail,
                            child: Image.asset(
                              AppResources.emailIcon,
                              width: 22,
                              height: 22,
                            ),
                            shadow: AppColors.primaryBlue
                                .withOpacity(0.2),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.offNamed(
                              AppRoute.login,
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color:
                                AppColors.primaryBlue,
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

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryBlue.withOpacity(0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.primaryBlue
                : AppColors.borderGrey,
            width: selected ? 1.8 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primaryBlue.withOpacity(0.12)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: selected
                    ? AppColors.primaryBlue
                    : AppColors.textGrey,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: selected
                          ? AppColors.primaryBlue
                          : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryBlue,
                size: 21,
              ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(
      String title,
      IconData icon,
      ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color:
            AppColors.primaryRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryRed,
            size: 18,
          ),
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
          child: Container(
            height: 1,
            color: AppColors.borderGrey,
          ),
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
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textDark,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.primaryBlue,
          size: 20,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderGrey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderGrey,
          ),
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
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.errorColor,
            width: 1.8,
          ),
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
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.primaryBlue,
        size: 25,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 14,
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
          borderSide: const BorderSide(
            color: AppColors.borderGrey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderGrey,
          ),
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
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        );
      }).toList(),
    );
  }

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
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
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