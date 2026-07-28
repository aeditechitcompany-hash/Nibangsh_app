import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibangsh_consultancy/admin/approvals/views/approvals_screen.dart';
import 'package:nibangsh_consultancy/admin/books/views/books_screen.dart';
import 'package:nibangsh_consultancy/admin/settings/views/settings_screen.dart';
import 'package:nibangsh_consultancy/admin/students/views/students_screen.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/responsive.dart';
import '../overview/views/overview_screen.dart';

class AdminNavigation extends StatelessWidget {
  const AdminNavigation({super.key});

  static const _railItems = [
    {'icon': Icons.bar_chart_rounded, 'label': 'Overview'},
    {'icon': Icons.groups_rounded, 'label': 'Students'},
    {'icon': Icons.assignment_rounded, 'label': 'Approvals'},
    {'icon': Icons.menu_book_rounded, 'label': 'Books'},
    {'icon': Icons.settings_rounded, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminNavigationController(), permanent: true);

    final tabs = const [
      AdminOverviewScreen(),
      StudentsScreen(),
      ApprovalsScreen(),
      BooksScreen(),
      SettingsScreen(),
    ];

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
              Icons.admin_panel_settings_rounded,
              color: AppColors.primaryBlue,
              size: 28,
            ),
          ),
          railDestinations: _railItems
              .map(
                (item) => NavigationRailDestination(
                  icon: Icon(item['icon'] as IconData),
                  selectedIcon: Icon(
                    item['icon'] as IconData,
                    color: AppColors.primaryBlue,
                  ),
                  label: Text(item['label'] as String),
                ),
              )
              .toList(),
          bottomNavBar: _AdminBottomNav(
            currentIndex: controller.currentIndex.value,
            onTap: controller.setIndex,
          ),
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: tabs,
          ),
        ),
      ),
    );
  }
}

class AdminNavigationController extends GetxController {
  final currentIndex = 0.obs;

  void setIndex(int index) => currentIndex.value = index;
}

class _AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AdminBottomNav({required this.currentIndex, required this.onTap});

  static const _items = [
    {'icon': Icons.bar_chart_rounded, 'label': 'Overview'},
    {'icon': Icons.groups_rounded, 'label': 'Students'},
    {'icon': Icons.assignment_rounded, 'label': 'Approvals'},
    {'icon': Icons.menu_book_rounded, 'label': 'Books'},
    {'icon': Icons.settings_rounded, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final selected = currentIndex == index;
              return GestureDetector(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _items[index]['icon'] as IconData,
                      color: selected
                          ? AppColors.primaryBlue
                          : AppColors.textGrey,
                      size: 24,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _items[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: selected
                            ? AppColors.primaryBlue
                            : AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
