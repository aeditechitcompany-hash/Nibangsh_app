import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../../../const/constants.dart';

class SignupController extends GetxController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final addressController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  final RxString selectedDistrict = ''.obs;
  final RxString selectedProvince = ''.obs;

  final formKey = GlobalKey<FormState>();

  final List<String> provinces = AppConstants.provinces;
  final List<String> districts = AppConstants.districts;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void setDistrict(String? value) {
    if (value != null) selectedDistrict.value = value;
  }

  void setProvince(String? value) {
    if (value != null) selectedProvince.value = value;
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) return 'Full name is required';
    if (value.trim().length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(value)) return 'Enter a valid email address';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must contain at least one uppercase letter (A-Z)';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must contain at least one lowercase letter (a-z)';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must contain at least one number (0-9)';
    }
    if (!RegExp(r'[!@#\$&*~%^()_\-+=\[\]{};:,.<>?/\\|`]').hasMatch(value)) {
      return 'Must contain at least one special character (!@#\$&*~)';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must contain at least one uppercase letter (A-Z)';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must contain at least one lowercase letter (a-z)';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must contain at least one number (0-9)';
    }
    if (!RegExp(r'[!@#\$&*~%^()_\-+=\[\]{};:,.<>?/\\|`]').hasMatch(value)) {
      return 'Must contain at least one special character (!@#\$&*~)';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) return 'Address is required';
    return null;
  }

  String? validateDistrict(String? value) {
    if (selectedDistrict.value.isEmpty) return 'Please select a district';
    return null;
  }

  String? validateProvince(String? value) {
    if (selectedProvince.value.isEmpty) return 'Please select a province';
    return null;
  }

  Future<void> signup() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedDistrict.value.isEmpty) {
      Get.snackbar('Error', 'Please select a district',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white);
      return;
    }
    if (selectedProvince.value.isEmpty) {
      Get.snackbar('Error', 'Please select a province',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success!',
        'Account created successfully. Please log in.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
      );

      Get.offNamed(AppRoute.login);
    } catch (e) {
      Get.snackbar(
        'Signup Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) Get.offAllNamed(AppRoute.home);
    } catch (e) {
      _showError('Google Sign-In Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Facebook Sign-In
  Future<void> signInWithFacebook() async {
    isLoading.value = true;
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) Get.offAllNamed(AppRoute.home);
    } catch (e) {
      _showError('Facebook Sign-In Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Email button
  void signInWithEmail() {
    _showInfo('Email Sign-In', 'Enter your email and password above to sign in.');
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

  void _showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryBlue,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }


  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    super.onClose();
  }
}