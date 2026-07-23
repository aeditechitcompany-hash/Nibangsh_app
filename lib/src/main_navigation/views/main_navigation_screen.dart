import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibangsh_consultancy/src/mcq/views/mcq_screen.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/widgets/app_bottom_nav.dart';
import '../../countries/views/countries_screen.dart';
import '../../home/views/home_screen.dart';
import '../../docs/views/docs_screen.dart';
import '../../books/views/student_books_screen.dart';
import '../../profile/views/profile_screen.dart';
import '../controller/main_navigation_controller.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MainNavigationController>()
        ? Get.find<MainNavigationController>()
        : Get.put(MainNavigationController());

    final tabs = const [
      HomeScreen(),
      CountriesScreen(),
      McqScreen(),
      StudentBooksScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(
        () =>
            IndexedStack(index: controller.currentIndex.value, children: tabs),
      ),
      bottomNavigationBar: Obx(
        () => AppBottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: controller.setIndex,
        ),
      ),
    );
  }
}
