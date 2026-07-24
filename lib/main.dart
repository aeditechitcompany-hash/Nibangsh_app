import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibangsh_consultancy/admin/approvals/views/approvals_screen.dart';
import 'package:nibangsh_consultancy/src/academic_details/views/academic_details_screen.dart';
import 'package:nibangsh_consultancy/admin/books/views/books_screen.dart';
import 'package:nibangsh_consultancy/admin/mcq/views/mcq_screen.dart';
import 'package:nibangsh_consultancy/admin/nav/admin_navigation.dart';
import 'package:nibangsh_consultancy/admin/notifications/views/notifications_screen.dart';
import 'package:nibangsh_consultancy/admin/settings/views/settings_screen.dart';
import 'package:nibangsh_consultancy/admin/student_profile/views/student_profile_screen.dart';
import 'package:nibangsh_consultancy/admin/students/views/students_screen.dart';
import 'package:nibangsh_consultancy/src/countries/views/countries_screen.dart';
import 'package:nibangsh_consultancy/src/docs/views/docs_screen.dart';
import 'package:nibangsh_consultancy/src/books/views/student_books_screen.dart';
import 'package:nibangsh_consultancy/src/mcq/views/mcq_quiz_screen.dart';
import 'package:nibangsh_consultancy/src/mcq/views/mcq_result_screen.dart';
import 'package:nibangsh_consultancy/src/notifications/views/notifications_screen.dart';
import 'common/util/app_colors.dart';
import 'common/util/app_route.dart';
import 'src/auth/views/login_screen.dart';
import 'src/auth/views/signup_screen.dart';
import 'src/auth/views/forgot_password_screen.dart';
import 'src/auth/views/change_password_screen.dart';
import 'src/profile/views/faq_help_screen.dart';
import 'src/main_navigation/views/main_navigation_screen.dart';
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
        GetPage(
          name: AppRoute.onboarding,
          page: () => const OnboardingScreen(),
        ),
        GetPage(name: AppRoute.login, page: () => const LoginScreen()),
        GetPage(name: AppRoute.signup, page: () => const SignupScreen()),
        GetPage(
          name: AppRoute.forgotPassword,
          page: () => const ForgotPasswordScreen(),
        ),
        GetPage(
          name: AppRoute.changePassword,
          page: () => const ChangePasswordScreen(),
        ),
        GetPage(name: AppRoute.faqHelp, page: () => const FaqHelpScreen()),
        GetPage(name: AppRoute.home, page: () => const MainNavigationScreen()),
        GetPage(name: AppRoute.profile, page: () => const ProfileScreen()),
        GetPage(name: AppRoute.docs, page: () => const DocsScreen()),
        GetPage(name: AppRoute.countries, page: () => const CountriesScreen()),
        GetPage(
          name: AppRoute.academicDetails,
          page: () => const AcademicDetailsScreen(),
        ),
        GetPage(
          name: AppRoute.adminDashboard,
          page: () => const AdminNavigation(),
        ),
        GetPage(
          name: AppRoute.studentProfile,
          page: () => const StudentProfileScreen(),
        ),
        GetPage(name: AppRoute.students, page: () => const StudentsScreen()),
        GetPage(name: AppRoute.approvals, page: () => const ApprovalsScreen()),
        GetPage(name: AppRoute.settings, page: () => const SettingsScreen()),
        GetPage(
          name: AppRoute.notifications,
          page: () => const NotificationsScreen(),
        ),
        GetPage(
          name: AppRoute.studentNotifications,
          page: () => const StudentNotificationsScreen(),
        ),
        GetPage(name: AppRoute.adminBooks, page: () => const BooksScreen()),
        GetPage(
          name: AppRoute.studentBooks,
          page: () => const StudentBooksScreen(),
        ),
        GetPage(name: AppRoute.mcqQuiz, page: () => const McqQuizScreen()),
        GetPage(name: AppRoute.mcqResult, page: () => const McqResultScreen()),
        GetPage(name: AppRoute.adminMcq, page: () => const AdminMcqScreen()),
      ],
    );
  }
}
