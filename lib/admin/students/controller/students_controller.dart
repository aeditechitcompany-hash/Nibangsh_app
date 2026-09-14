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

      final response = await _api.get(
        url: '${ApiConstants.baseUrl}/students/profiles/',
      );

      List<dynamic> data;

      if (response is List) {
        data = response;
      } else if (response is Map<String, dynamic> &&
          response['results'] is List) {
        data = response['results'] as List;
      } else {
        throw Exception(
          'Expected student profiles list, but received: $response',
        );
      }

      students.assignAll(
        data.map((json) {
          return StudentRecord.fromJson(
            Map<String, dynamic>.from(json),
          );
        }).toList(),
      );
    } catch (e) {
      errorMessage.value = e.toString();
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