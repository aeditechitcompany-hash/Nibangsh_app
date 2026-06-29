import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(value)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // Email & password login
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(AppRoute.home);
    } catch (e) {
      _showError('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) Get.offAllNamed(AppRoute.home);
      await Future.delayed(const Duration(milliseconds: 800));
      _showInfo('Google Sign-In', 'Add google_sign_in package to enable.');
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
      await Future.delayed(const Duration(milliseconds: 800));
      _showInfo('Facebook Sign-In', 'Add flutter_facebook_auth package to enable.');
    } catch (e) {
      _showError('Facebook Sign-In Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Email button — focuses the email field
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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}