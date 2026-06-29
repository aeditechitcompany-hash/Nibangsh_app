import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'common/util/app_colors.dart';
import 'common/util/app_route.dart';
import 'src/auth/views/login_screen.dart';
import 'src/auth/views/signup_screen.dart';
import 'src/home/views/home_screen.dart';
import 'src/onboarding/views/onboarding_screen.dart';
import 'src/profile/views/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nibangsh Consultancy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryRed,
          primary: AppColors.primaryRed,
          secondary: AppColors.primaryBlue,
        ),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      initialRoute: AppRoute.onboarding,
      getPages: [
        GetPage(name: AppRoute.onboarding, page: () => const OnboardingScreen()),
        GetPage(name: AppRoute.login, page: () => const LoginScreen()),
        GetPage(name: AppRoute.signup, page: () => const SignupScreen()),
        GetPage(name: AppRoute.home, page: () => const HomeScreen()),
        GetPage(name: AppRoute.profile, page: () => const ProfileScreen()),
      ],
    );
  }
}