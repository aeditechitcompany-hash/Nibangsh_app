import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/api_services/api_service.dart';
import '../../../common/api_services/token_storage_service.dart';
import '../../../common/services/storage.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ApiService _api = const ApiService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final refreshToken =
      await TokenStorageService.getRefreshToken();

      // No saved session.
      if (refreshToken == null || refreshToken.isEmpty) {
        Get.offAllNamed(AppRoute.onboarding);
        return;
      }

      // Get saved backend role.
      final role = await StorageService.getUserRole();

      if (role == null || role.isEmpty) {
        await TokenStorageService.clearStorage();
        Get.offAllNamed(AppRoute.login);
        return;
      }

      final normalizedRole = role.trim().toLowerCase();

      print("========== SPLASH ROLE ==========");
      print(normalizedRole);
      print("=================================");

      // ============================================================
      // ADMIN
      // ============================================================

      if (normalizedRole == 'admin') {
        Get.offAllNamed(AppRoute.adminDashboard);
        return;
      }

      // ============================================================
      // COUNSELOR
      // ============================================================

      if (normalizedRole == 'counselor') {
        Get.offAllNamed(AppRoute.home);
        return;
      }

      // ============================================================
      // UBT
      // ============================================================

      if (normalizedRole == 'ubt') {
        Get.offAllNamed(AppRoute.ubtHome);
        return;
      }

      // ============================================================
      // STUDENT
      // ============================================================

      if (normalizedRole == 'student') {
        Get.offAllNamed(AppRoute.home);
        return;
      }

      // ============================================================
      // UNKNOWN ROLE
      // ============================================================

      await TokenStorageService.clearStorage();
      Get.offAllNamed(AppRoute.login);
    } catch (e) {
      print("SPLASH SESSION ERROR: $e");

      await TokenStorageService.clearStorage();
      Get.offAllNamed(AppRoute.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryRed,
        ),
      ),
    );
  }
}