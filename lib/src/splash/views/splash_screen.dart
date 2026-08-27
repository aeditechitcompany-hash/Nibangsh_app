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

      // Try to use the saved access token.
      // If it has expired, ApiService will refresh it
      // when the first authenticated request is made.
      final role = await StorageService.getUserRole();

      if (role == null || role.isEmpty) {
        await TokenStorageService.clearStorage();
        Get.offAllNamed(AppRoute.login);
        return;
      }

      if (role.toLowerCase() == 'admin') {
        Get.offAllNamed(AppRoute.adminDashboard);
        return;
      }

      if (role.toLowerCase() == 'counselor') {
        Get.offAllNamed(AppRoute.home);
        return;
      }

      // Student
      Get.offAllNamed(AppRoute.home);
    } catch (e) {
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