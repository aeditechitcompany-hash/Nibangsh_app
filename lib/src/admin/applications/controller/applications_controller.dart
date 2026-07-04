import 'package:get/get.dart';
import '../../students/model/students_record.dart';

class ApplicationsController extends GetxController {
  final applications = <StudentRecord>[].obs;
  final selectedStatus = Rxn<StudentStatus>();

  @override
  void onInit() {
    super.onInit();
    applications.assignAll(StudentsCatalog.seed);
  }

  List<StudentRecord> get filteredApplications {
    final status = selectedStatus.value;
    if (status == null) return applications;
    return applications.where((a) => a.status == status).toList();
  }

  int get totalCount => applications.length;
  int countFor(StudentStatus status) =>
      applications.where((a) => a.status == status).length;

  void setStatusFilter(StudentStatus? status) => selectedStatus.value = status;

  void approve(String id) => _updateStatus(id, StudentStatus.approved);
  void reject(String id) => _updateStatus(id, StudentStatus.rejected);

  void _updateStatus(String id, StudentStatus status) {
    final index = applications.indexWhere((a) => a.id == id);
    if (index == -1) return;
    applications[index] = applications[index].copyWith(status: status);
  }
}