import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/util/app_colors.dart';
import '../../../common/util/responsive.dart';
import '../controller/notifications_controller.dart';
import '../model/student_notification.dart';

class StudentNotificationsScreen extends StatelessWidget {
  const StudentNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      StudentNotificationsController(),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: controller.refreshNotifications,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(controller),

              ResponsiveWrapper(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    100,
                  ),
                  child: Obx(() {
                    // Loading
                    if (controller.isLoading.value &&
                        controller.notifications.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 60,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    // Error
                    if (controller.errorMessage.value.isNotEmpty &&
                        controller.notifications.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 60,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                size: 42,
                                color: AppColors.textGrey,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Unable to load notifications',
                                style: const TextStyle(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                controller.errorMessage.value,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed:
                                controller.fetchNotifications,
                                child: const Text('Try Again'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Empty
                    if (controller.notifications.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 60,
                        ),
                        child: Center(
                          child: Text(
                            'No notifications yet',
                            style: TextStyle(
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                      );
                    }

                    // Notifications
                    return Column(
                      children: controller.notifications
                          .map(
                            (notification) =>
                            _notificationTile(
                              controller,
                              notification,
                            ),
                      )
                          .toList(),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // HEADER
  // --------------------------------------------------

  Widget _buildHeader(
      StudentNotificationsController controller,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        26,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.navyDark,
            AppColors.navyLight,
          ],
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
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Obx(
                          () => Text(
                        '${controller.unreadCount} unread',
                        style: TextStyle(
                          color:
                          Colors.white.withOpacity(0.75),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Mark all as read
              Obx(() {
                if (controller.unreadCount == 0) {
                  return const SizedBox.shrink();
                }

                return TextButton(
                  onPressed:
                  controller.markAllAsRead,
                  child: const Text(
                    'Read all',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // NOTIFICATION TILE
  // --------------------------------------------------

  Widget _notificationTile(
      StudentNotificationsController controller,
      StudentNotification notification,
      ) {
    late IconData icon;
    late Color color;

    switch (notification.type) {
      case StudentNotificationType.success:
        icon = Icons.check_circle_outline_rounded;
        color = const Color(0xFF16A34A);
        break;

      case StudentNotificationType.info:
        icon = Icons.info_outline_rounded;
        color = AppColors.primaryBlue;
        break;

      case StudentNotificationType.warning:
        icon = Icons.warning_amber_rounded;
        color = const Color(0xFFF59E0B);
        break;

      case StudentNotificationType.alert:
        icon = Icons.error_outline_rounded;
        color = Colors.red;
        break;
    }

    return GestureDetector(
      onTap: () {
        controller.markAsRead(notification);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white
              : AppColors.primaryBlue.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead
                ? AppColors.borderGrey
                : AppColors.primaryBlue.withOpacity(0.25),
          ),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 19,
              ),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight:
                            notification.isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                            color:
                            AppColors.textDark,
                          ),
                        ),
                      ),

                      // Unread indicator
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                            AppColors.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    notification.timeAgo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}