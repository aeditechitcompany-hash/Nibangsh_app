import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/api_services/api_constants.dart';
import '../../../common/api_services/api_service.dart';
import '../../model/students_record.dart';

class StudentsController extends GetxController {
  final ApiService _api = const ApiService();

  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  final selectedStatus = Rxn<StudentStatus>();

  final RxList<StudentRecord> students =
      <StudentRecord>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    fetchStudents();

    searchController.addListener(() {
      searchQuery.value =
          searchController.text.trim();
    });
  }

  Future<void> fetchStudents() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Your Django endpoint is:
      // /api/accounts/users/
      //
      // We only want users whose role is "student".
      final response = await _api.get(
        url: '${ApiConstants.students}?role=student',
      );

      print('========== STUDENTS API ==========');
      print('Response: $response');
      print('===================================');

      if (response is! List) {
        throw Exception(
          'Expected a list of students, but received: $response',
        );
      }

      final List<dynamic> data = response;

      students.assignAll(
        data.map((json) {
          return StudentRecord.fromJson(
            json as Map<String, dynamic>,
          );
        }).toList(),
      );

      print(
        'Students loaded: ${students.length}',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      print('========== FETCH STUDENTS ERROR ==========');
      print(e);
      print('==========================================');
    } finally {
      isLoading.value = false;
    }
  }

  List<StudentRecord> get filteredStudents {
    return students.where((s) {
      final query =
          searchQuery.value.toLowerCase();

      final matchesStatus =
          selectedStatus.value == null ||
          s.status == selectedStatus.value;

      final matchesQuery =
          query.isEmpty ||
          s.name.toLowerCase().contains(query) ||
          s.email.toLowerCase().contains(query);

      return matchesStatus && matchesQuery;
    }).toList();
  }

  void setStatusFilter(StudentStatus? status) {
    selectedStatus.value = status;
  }

  StudentRecord? byId(String id) {
    final index =
        students.indexWhere((s) => s.id == id);

    return index == -1
        ? null
        : students[index];
  }

  void updateStudent(
    String id,
    StudentRecord Function(
      StudentRecord current,
    ) updater,
  ) {
    final index =
        students.indexWhere((s) => s.id == id);

    if (index == -1) return;

    students[index] = updater(
      students[index],
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}