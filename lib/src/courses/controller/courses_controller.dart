import 'package:get/get.dart';
import '../../../common/models/course_info.dart';

class CoursesController extends GetxController {
  late final String universityName;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    universityName = (args is Map ? args['university']?.toString() : null) ?? '';
  }

  List<CourseInfo> get courses => CourseCatalog.byUniversity[universityName] ?? [];
}