import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../common/api_services/auth_service.dart';
import '../../../common/api_services/academic_details_service.dart';
import '../../../common/services/storage.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  final RxString selectedRole = 'student'.obs;

  final formKey = GlobalKey<FormState>();

  void selectRole(String role) {
    selectedRole.value = role.trim().toLowerCase();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value =
    !isPasswordVisible.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!GetUtils.isEmail(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must contain at least one uppercase letter (A-Z)';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must contain at least one lowercase letter (a-z)';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must contain at least one number (0-9)';
    }

    if (!RegExp(
      r'[!@#\$&*~%^()_\-+=\[\]{};:,.<>?/\\|`]',
    ).hasMatch(value)) {
      return 'Must contain at least one special character (!@#\$&*~)';
    }

    return null;
  }

  final AcademicDetailsService _academicDetailsService =
  AcademicDetailsService();

  Future<void> _navigateAfterLogin(String email) async {
    final hasAcademicDetails =
    await _academicDetailsService.hasAcademicDetails();

    if (hasAcademicDetails) {
      Get.offAllNamed(AppRoute.home);
    } else {
      Get.offAllNamed(
        AppRoute.academicDetails,
        arguments: {
          'email': email,
        },
      );
    }
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      final auth = await _authService.login(
        email: email,
        password: password,
      );

      print("========== LOGGED IN USER ==========");
      print("Email: ${auth.user.email}");
      print("Role: ${auth.user.role}");
      print("====================================");

      final role = auth.user.role.trim().toLowerCase();

      await StorageService.saveUserInfo(
        id: auth.user.id,
        email: auth.user.email,
        name: auth.user.fullName,
        phone: auth.user.phoneNumber,
        role: auth.user.role,
      );

      if (role == 'admin') {
        Get.offAllNamed(AppRoute.adminDashboard);
        return;
      }

      if (role == 'counselor') {
        Get.offAllNamed(AppRoute.home);
        return;
      }

      if (role != selectedRole.value) {
        Get.snackbar(
          "Wrong Account Type",
          "This account is registered as ${role.toUpperCase()}.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (role == 'ubt') {
        Get.offAllNamed(AppRoute.ubtHome);
        return;
      }

      if (role == 'student') {
        await _navigateAfterLogin(auth.user.email);
        return;
      }

      throw Exception(
        'Unknown account role: ${auth.user.role}',
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

  Future<void> signInWithGoogle() async {
    isLoading.value = true;

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? account =
      await googleSignIn.signIn();

      if (account != null) {
        await StorageService.saveUserInfo(
          email: account.email,
          name: account.displayName?.trim().isNotEmpty == true
              ? account.displayName!.trim()
              : account.email.split('@').first,
        );

        await _navigateAfterLogin(account.email);
      }
    } catch (e) {
      _showError(
        'Google Sign-In Failed',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithFacebook() async {
    isLoading.value = true;

    try {
      final LoginResult result =
      await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final userData =
        await FacebookAuth.instance.getUserData();

        final email =
            userData['email']?.toString() ?? '';

        await StorageService.saveUserInfo(
          email: email,
          name: userData['name']?.toString() ?? 'Student',
        );

        await _navigateAfterLogin(email);
      }
    } catch (e) {
      _showError(
        'Facebook Sign-In Failed',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithEmail() {
    _showInfo(
      'Email Sign-In',
      'Enter your email and password above to sign in.',
    );
  }

  void _showError(
      String title,
      String message,
      ) {
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

  void _showInfo(
      String title,
      String message,
      ) {
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