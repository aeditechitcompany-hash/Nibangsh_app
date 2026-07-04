import 'package:get/get.dart';

class SettingsController extends GetxController {
  final pushNotifications = true.obs;
  final emailAlerts = true.obs;

  void togglePushNotifications(bool value) => pushNotifications.value = value;
  void toggleEmailAlerts(bool value) => emailAlerts.value = value;
}