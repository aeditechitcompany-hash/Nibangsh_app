import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/students_record.dart';

class StudentsController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  final selectedStatus = Rxn<StudentStatus>();

  final students = StudentsCatalog.seed;

  @override
  void onInit() {
    super.onInit();
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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}