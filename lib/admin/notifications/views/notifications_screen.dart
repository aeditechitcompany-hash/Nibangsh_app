import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/util/app_colors.dart';
import '../../overview/controller/overview_controller.dart';
import '../controller/notifications_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveDashboardWrapper(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(controller),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: Obx(() {
                  if (controller.activities.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: Text(
                          'No recent activity',
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: controller.activities
                        .map((activity) => _activityTile(activity))
                        .toList(),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(NotificationsController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDark, AppColors.navyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Obx(
                          () => Text(
                        '${controller.unreadCount} recent activities',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activityTile(RecentActivity activity) {
    late IconData icon;
    late Color color;
    switch (activity.status) {
      case ActivityStatus.approved:
        icon = Icons.check_rounded;
        color = const Color(0xFF16A34A);
        break;
      case ActivityStatus.inProgress:
        icon = Icons.show_chart_rounded;
        color = AppColors.primaryBlue;
        break;
      case ActivityStatus.rejected:
        icon = Icons.close_rounded;
        color = AppColors.errorColor;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.action,
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          Text(
            activity.time,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}