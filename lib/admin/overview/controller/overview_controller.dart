import 'package:get/get.dart';

enum ActivityStatus { approved, inProgress, rejected }

class RecentActivity {
  final String name;
  final String action;
  final String time;
  final ActivityStatus status;

  const RecentActivity({
    required this.name,
    required this.action,
    required this.time,
    required this.status,
  });
}

class DestinationStat {
  final String code;
  final String name;
  final int studentCount;

  const DestinationStat({required this.code, required this.name, required this.studentCount});
}

class AdminOverviewController extends GetxController {
  final totalStudents = 6.obs;
  final pending = 1.obs;
  final approved = 1.obs;
  final activeApplications = 3.obs;
  final visaApprovedOutOf = 6.obs;

  final destinations = const [
    DestinationStat(code: 'KR', name: 'South Korea', studentCount: 1),
    DestinationStat(code: 'AU', name: 'Australia', studentCount: 1),
    DestinationStat(code: 'GB', name: 'United Kingdom', studentCount: 1),
    DestinationStat(code: 'US', name: 'United States', studentCount: 1),
    DestinationStat(code: 'CA', name: 'Canada', studentCount: 1),
    DestinationStat(code: 'JP', name: 'Japan', studentCount: 1),
  ];

  int totalStudentsCount = 6;

  // int get maxDestinationCount =>
  //     destinations.map((d) => d.studentCount).fold(1, (a, b) => a > b ? a : b);

  final recentActivity = const [
    RecentActivity(name: 'Meera Patel',
        action: 'Visa approved',
        time: '1h ago',
        status: ActivityStatus.approved),
    RecentActivity(name: 'Rahul Gupta',
        action: 'Uploaded documents',
        time: '3h ago',
        status: ActivityStatus.inProgress),
    RecentActivity(name: 'Anjali Singh',
        action: 'Visa in progress',
        time: '5h ago',
        status: ActivityStatus.inProgress),
    RecentActivity(name: 'Karan Mehta',
        action: 'Application rejected',
        time: '1d ago',
        status: ActivityStatus.rejected),
  ];

}