import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibangsh_consultancy/src/mcq/views/mcq_home_screen.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/responsive.dart';
import '../../../common/widgets/app_bottom_nav.dart';
import '../../countries/views/countries_screen.dart';
import '../../home/views/home_screen.dart';
import 'package:nibangsh_consultancy/src/books/views/student_books_screen.dart';
import '../../profile/views/profile_screen.dart';
import '../controller/main_navigation_controller.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  static const _railItems = [
    {
      'icon': Icons.home_rounded,
      'label': 'Home',
    },
    {
      'icon': Icons.public_rounded,
      'label': 'Countries',
    },
    {
      'icon': Icons.description_rounded,
      'label': 'MCQ',
    },
    {
      'icon': Icons.menu_book_rounded,
      'label': 'Books',
    },
    {
      'icon': Icons.person_rounded,
      'label': 'Profile',
    },
  ];


  @override
  Widget build(BuildContext context) {
    final controller =
    Get.isRegistered<MainNavigationController>()
        ? Get.find<MainNavigationController>()
        : Get.put(MainNavigationController());

    return Container(
      color: AppColors.background,
      child: Obx(
            () => AdaptiveNavShell(
          currentIndex: controller.currentIndex.value,
          onTap: controller.setIndex,

          railBackgroundColor: Colors.white,

          railLeading: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Icon(
              Icons.school_rounded,
              color: AppColors.darkBlue,
              size: 28,
            ),
          ),

          railDestinations: _railItems
              .map(
                (item) => NavigationRailDestination(
              icon: Icon(
                item['icon'] as IconData,
              ),
              selectedIcon: Icon(
                item['icon'] as IconData,
                color: AppColors.darkBlue,
              ),
              label: Text(
                item['label'] as String,
              ),
            ),
          )
              .toList(),

          bottomNavBar: AppBottomNav(
            currentIndex: controller.currentIndex.value,
            onTap: controller.setIndex,
          ),

          body: _buildCurrentScreen(
            controller.currentIndex.value,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();

      case 1:
        return const CountriesScreen();

      case 2:
        return const McqHomeScreen();

      case 3:
        return const StudentBooksScreen();

      case 4:
        return const ProfileScreen();

      default:
        return const HomeScreen();
    }
  }


}