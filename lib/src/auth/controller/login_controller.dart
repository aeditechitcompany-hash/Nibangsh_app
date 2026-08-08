import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../common/api_services/auth_service.dart';
import '../../../common/services/storage.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
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

  // Academic details are stored locally, keyed to whichever account was
  // last logged in on this device. If a different email is now logging in,
  // the previous account's academic details no longer apply — clear them
  // so the new user goes through the form themselves instead of seeing
  // stale data from whoever used the device before.
  Future<void> _resetAcademicDetailsIfNewUser(String newEmail) async {
    final previousEmail = await StorageService.getUserEmail();
    if (previousEmail != null &&
        previousEmail.isNotEmpty &&
        previousEmail.toLowerCase() != newEmail.toLowerCase()) {
      await StorageService.clearAcademicDetails();
    }
  }

  // After a successful login, send first-time users to fill in their
  // academic details; everyone else goes straight to Home.
  Future<void> _navigateAfterLogin(String email) async {
    final hasAcademicDetails = await StorageService.hasAcademicDetails();
    if (hasAcademicDetails) {
      Get.offAllNamed(AppRoute.home);
    } else {
      Get.offAllNamed(AppRoute.academicDetails, arguments: {'email': email});
    }
  }

  // Email & password login
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      // Login through Django API for ALL accounts,
      // including admin accounts.
      final auth = await _authService.login(
        email: email,
        password: password,
      );

      print("========== LOGGED IN USER ==========");
      print("Email: ${auth.user.email}");
      print("Role: ${auth.user.role}");
      print("====================================");

      // Save user information locally
      await StorageService.saveUserInfo(
        email: auth.user.email,
        name: auth.user.fullName,
        phone: auth.user.phoneNumber,
        role: auth.user.role,
      );

      await StorageService.saveUserPassword(password);

      // Admin → Admin Dashboard
      if (auth.user.role.toLowerCase() == 'admin') {
        Get.offAllNamed(AppRoute.adminDashboard);
        return;
      }

      // Counselor → Counselor area
      if (auth.user.role.toLowerCase() == 'counselor') {
        // Change this route if your project has a counselor route.
        Get.offAllNamed(AppRoute.home);
        return;
      }

      // Student → normal student flow
      await _resetAcademicDetailsIfNewUser(
        auth.user.email,
      );

      await _navigateAfterLogin(
        auth.user.email,
      );
    } catch (e) {
      print("LOGIN ERROR:");
      print(e);

      Get.snackbar(
        "Login Failed",
        e.toString().replaceAll("Exception: ", ""),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
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
      if (account != null) {
        await _resetAcademicDetailsIfNewUser(account.email);
        await StorageService.saveUserInfo(
          email: account.email,
          name: account.displayName?.trim().isNotEmpty == true
              ? account.displayName!.trim()
              : account.email.split('@').first,
        );
        await _navigateAfterLogin(account.email);
      }
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
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        final email = userData['email']?.toString() ?? '';
        await _resetAcademicDetailsIfNewUser(email);
        await StorageService.saveUserInfo(
          email: email,
          name: userData['name']?.toString() ?? 'Student',
        );
        await _navigateAfterLogin(email);
      }
    } catch (e) {
      _showError('Facebook Sign-In Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Email button
  void signInWithEmail() {
    _showInfo(
      'Email Sign-In',
      'Enter your email and password above to sign in.',
    );
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