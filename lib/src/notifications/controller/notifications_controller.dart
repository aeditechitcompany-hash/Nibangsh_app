import 'package:get/get.dart';

enum StudentNotificationType { success, info, warning }

class StudentNotification {
  final String title;
  final String message;
  final String time;
  final StudentNotificationType type;

  const StudentNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
  });
}

class NotificationsController extends GetxController {
  final notifications = <StudentNotification>[].obs;

  @override
  void onInit() {
    super.onInit();
    notifications.assignAll(const [
      StudentNotification(
        title: 'Document Approved',
        message: 'Your passport copy has been verified by the admin team.',
        time: '2h ago',
        type: StudentNotificationType.success,
      ),
      StudentNotification(
        title: 'Visa Application Update',
        message: 'Your visa application has moved to processing.',
        time: '5h ago',
        type: StudentNotificationType.info,
      ),
      StudentNotification(
        title: 'Action Required',
        message: 'Please upload your latest bank statement to continue.',
        time: '1d ago',
        type: StudentNotificationType.warning,
      ),
      StudentNotification(
        title: 'Counselor Message',
        message: 'Priya Sharma sent you a new message about your application.',
        time: '1d ago',
        type: StudentNotificationType.info,
      ),
      StudentNotification(
        title: 'Offer Letter Received',
        message: 'Congratulations! Your offer letter has arrived.',
        time: '3d ago',
        type: StudentNotificationType.success,
      ),
      StudentNotification(
        title: 'IELTS Reminder',
        message: 'Your language test is scheduled in 5 days.',
        time: '4d ago',
        type: StudentNotificationType.warning,
      ),
    ]);
  }

  int get unreadCount => notifications.length;
}
