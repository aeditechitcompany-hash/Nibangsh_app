import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/students_record.dart';

class StudentsController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  final selectedStatus = Rxn<StudentStatus>();

  final RxList<StudentRecord> students = <StudentRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    students.assignAll(StudentsCatalog.seed);
    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });
  }

  List<StudentRecord> get filteredStudents {
    return students.where((s) {
      final matchesStatus = selectedStatus.value == null || s.status == selectedStatus.value;
      final matchesQuery = searchQuery.value.isEmpty ||
          s.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          s.email.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesStatus && matchesQuery;
    }).toList();
  }

  void setStatusFilter(StudentStatus? status) => selectedStatus.value = status;

  StudentRecord? byId(String id) {
    final index = students.indexWhere((s) => s.id == id);
    return index == -1 ? null : students[index];
  }

  void updateStudent(String id, StudentRecord Function(StudentRecord current) updater) {
    final index = students.indexWhere((s) => s.id == id);
    if (index == -1) return;
    students[index] = updater(students[index]);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}