import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibangsh_consultancy/admin/applications/views/applications_screen.dart';
import 'package:nibangsh_consultancy/admin/settings/views/settings_screen.dart';
import 'package:nibangsh_consultancy/admin/students/views/students_screen.dart';
import '../../../common/util/app_colors.dart';
import '../overview/views/overview_screen.dart';

class AdminNavigation extends StatelessWidget {
  const AdminNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminNavigationController(), permanent: true);

    final tabs = const [
      AdminOverviewScreen(),
      StudentsScreen(),
      ApplicationsScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: tabs,
      )),
      bottomNavigationBar: Obx(() => _AdminBottomNav(
        currentIndex: controller.currentIndex.value,
        onTap: controller.setIndex,
      )),
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
    {'icon': Icons.assignment_rounded, 'label': 'Applications'},
    {'icon': Icons.settings_rounded, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -3)),
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
                      color: selected ? AppColors.primaryBlue : AppColors.textGrey,
                      size: 24,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _items[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        color: selected ? AppColors.primaryBlue : AppColors.textGrey,
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