import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../common/api_services/notification_service.dart';
import '../../../common/services/firebase_notification_service.dart';
import '../model/student_notification.dart';

class StudentNotificationsController extends GetxController {
  final NotificationService _notificationService =
  NotificationService();

  final notifications = <StudentNotification>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  StreamSubscription<RemoteMessage>? _notificationSubscription;

  @override
  void onInit() {
    super.onInit();

    // Load existing notifications.
    fetchNotifications();

    // Listen for new FCM notifications.
    _notificationSubscription =
        FirebaseNotificationService.instance
            .onNotificationReceived
            .listen((message) {
          debugPrint(
            'NEW FCM NOTIFICATION RECEIVED',
          );

          debugPrint(
            'Title: ${message.notification?.title}',
          );

          debugPrint(
            'Body: ${message.notification?.body}',
          );

          // Reload notifications from Django.
          fetchNotifications();
        });
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result =
      await _notificationService.getMyNotifications();

      debugPrint(
        'NOTIFICATIONS LOADED: ${result.length}',
      );

      notifications.assignAll(result);

      debugPrint(
        'UNREAD COUNT: $unreadCount',
      );
    } catch (e) {
      debugPrint(
        'NOTIFICATION ERROR: $e',
      );

      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(
      StudentNotification notification,
      ) async {
    if (notification.isRead) {
      return;
    }

    try {
      await _notificationService.markAsRead(
        notification.id,
      );

      final index = notifications.indexWhere(
            (item) => item.id == notification.id,
      );

      if (index != -1) {
        notifications[index] =
            notification.copyWith(
              isRead: true,
            );
      }

      debugPrint(
        'Notification marked as read: ${notification.id}',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      debugPrint(
        'MARK AS READ ERROR: $e',
      );
    }
  }

  Future<void> markAllAsRead() async {
    final unread = notifications
        .where(
          (notification) => !notification.isRead,
    )
        .toList();

    for (final notification in unread) {
      await markAsRead(notification);
    }
  }

  int get unreadCount {
    return notifications
        .where(
          (notification) => !notification.isRead,
    )
        .length;
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  @override
  void onClose() {
    _notificationSubscription?.cancel();
    super.onClose();
  }
}