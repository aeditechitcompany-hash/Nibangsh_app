import 'package:get/get.dart';
import '../../overview/controller/overview_controller.dart';

class NotificationsController extends GetxController {
  final activities = <RecentActivity>[].obs;

  @override
  void onInit() {
    super.onInit();
    activities.assignAll(const [
      RecentActivity(
        name: 'Meera Patel',
        action: 'Visa approved',
        time: '1h ago',
        status: ActivityStatus.approved,
      ),
      RecentActivity(
        name: 'Rahul Gupta',
        action: 'Uploaded documents',
        time: '3h ago',
        status: ActivityStatus.inProgress,
      ),
      RecentActivity(
        name: 'Anjali Singh',
        action: 'Visa in progress',
        time: '5h ago',
        status: ActivityStatus.inProgress,
      ),
      RecentActivity(
        name: 'Karan Mehta',
        action: 'Application rejected',
        time: '1d ago',
        status: ActivityStatus.rejected,
      ),
      RecentActivity(
        name: 'Priya Nair',
        action: 'Submitted language test score',
        time: '1d ago',
        status: ActivityStatus.inProgress,
      ),
      RecentActivity(
        name: 'Arjun Sharma',
        action: 'Application rejected',
        time: '2d ago',
        status: ActivityStatus.rejected,
      ),
      RecentActivity(
        name: 'Sanjay Rao',
        action: 'New student registered',
        time: '2d ago',
        status: ActivityStatus.inProgress,
      ),
      RecentActivity(
        name: 'Meera Patel',
        action: 'Offer letter received',
        time: '3d ago',
        status: ActivityStatus.approved,
      ),
    ]);
  }

  int get unreadCount => activities.length;
}