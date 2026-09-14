import 'package:get/get.dart';

import '../controller/notifications_controller.dart';

class StudentNotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StudentNotificationsController>(
      StudentNotificationsController(),
      permanent: true,
    );
  }
}