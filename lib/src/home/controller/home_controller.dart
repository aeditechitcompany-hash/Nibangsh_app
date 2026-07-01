import 'package:get/get.dart';

class HomeController extends GetxController {
  final selectedNavIndex = 0.obs;

  String savedCountry = '';
  String savedDegree = '';
  String savedGpa = '';
  String savedPassoutYear = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      savedCountry = args['country']?.toString() ?? '';
      savedDegree = args['degree']?.toString() ?? '';
      savedGpa = args['gpa']?.toString() ?? '';
      savedPassoutYear = args['passoutYear']?.toString() ?? '';
    }
  }

  final List<Map<String, String>> services = const [
    {'title': 'Universities', 'icon': 'school'},
    {'title': 'Visa Guide', 'icon': 'flight_takeoff'},
    {'title': 'Test Prep', 'icon': 'menu_book'},
    {'title': 'Scholarships', 'icon': 'card_giftcard'},
  ];

  final List<Map<String, String>> destinations = const [
    {'name': 'United States', 'unis': '1200+ Universities'},
    {'name': 'United Kingdom', 'unis': '400+ Universities'},
    {'name': 'Canada', 'unis': '350+ Universities'},
    {'name': 'Australia', 'unis': '280+ Universities'},
    {'name': 'Germany', 'unis': '320+ Universities'},
  ];

  final List<Map<String, String>> recommendedUniversities = const [
    {
      'name': 'University of Toronto',
      'location': 'Toronto, Canada',
      'rating': '4.8',
      'course': 'MSc Computer Science',
    },
    {
      'name': 'University of Melbourne',
      'location': 'Melbourne, Australia',
      'rating': '4.7',
      'course': 'MBA',
    },
    {
      'name': 'Technical University of Munich',
      'location': 'Munich, Germany',
      'rating': '4.6',
      'course': 'MSc Data Engineering',
    },
  ];

  void setNavIndex(int index) => selectedNavIndex.value = index;
}