import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/util/app_colors.dart';

import '../../leaderboard_screen/leaderboard_screen.dart';
import '../../mcq/views/mcq_home_screen.dart';
import '../../books/views/student_books_screen.dart';
import '../../profile/views/profile_screen.dart';

import '../controller/ubt_navigation_controller.dart';

class UbtNavigationScreen extends StatelessWidget {
  const UbtNavigationScreen({super.key});

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.emoji_events_outlined),
      selectedIcon: Icon(Icons.emoji_events),
      label: 'Leaderboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.quiz_outlined),
      selectedIcon: Icon(Icons.quiz),
      label: 'MCQ',
    ),
    NavigationDestination(
      icon: Icon(Icons.menu_book_outlined),
      selectedIcon: Icon(Icons.menu_book),
      label: 'Books',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller =
    Get.isRegistered<UbtNavigationController>()
        ? Get.find<UbtNavigationController>()
        : Get.put(UbtNavigationController());

    const tabs = [
      LeaderboardScreen(),
      McqHomeScreen(),
      StudentBooksScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      body: Obx(
            () => IndexedStack(
          index: controller.currentIndex.value,
          children: tabs,
        ),
      ),

      bottomNavigationBar: Obx(
            () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.setIndex,
          destinations: _destinations,
          backgroundColor: Colors.white,
          indicatorColor:
          AppColors.primaryBlue.withOpacity(0.12),
          elevation: 3,
        ),
      ),
    );
  }
}