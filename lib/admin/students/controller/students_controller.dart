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

  final RxList<StudentRecord> students = <StudentRecord>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });

    fetchStudents();
  }

  // ============================================================
  // FETCH STUDENTS
  // ============================================================

  Future<void> fetchStudents() async {
    final stopwatch = Stopwatch()..start();

    debugPrint('========== STUDENTS FETCH START ==========');

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final apiStart = stopwatch.elapsedMilliseconds;

      final response = await _api.get(
        url: '${ApiConstants.baseUrl}/students/profiles/',
      );

      debugPrint(
        'STUDENTS API TIME: '
            '${stopwatch.elapsedMilliseconds - apiStart} ms',
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

      final parseStart = stopwatch.elapsedMilliseconds;

      students.assignAll(
        data.map((json) {
          return StudentRecord.fromJson(
            Map<String, dynamic>.from(json),
          );
        }).toList(),
      );

      debugPrint(
        'STUDENTS PARSE TIME: '
            '${stopwatch.elapsedMilliseconds - parseStart} ms',
      );

      debugPrint(
        'TOTAL STUDENTS FETCH TIME: '
            '${stopwatch.elapsedMilliseconds} ms',
      );

    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('STUDENTS ERROR: $e');
    } finally {
      isLoading.value = false;

      debugPrint(
          '========== STUDENTS FETCH END =========='
      );
    }
  }

  // ============================================================
  // FORCE REFRESH
  // ============================================================

  Future<void> refreshStudents() async {
    await fetchStudents();
  }

  // ============================================================
  // FILTERED STUDENTS
  // ============================================================

  List<StudentRecord> get filteredStudents {
    final query = searchQuery.value.toLowerCase();

    return students.where((student) {
      final matchesStatus =
          selectedStatus.value == null ||
              student.status == selectedStatus.value;

      final matchesQuery =
          query.isEmpty ||
              student.name.toLowerCase().contains(query) ||
              student.email.toLowerCase().contains(query);

      return matchesStatus && matchesQuery;
    }).toList();
  }

  // ============================================================
  // STATUS FILTER
  // ============================================================

  void setStatusFilter(StudentStatus? status) {
    selectedStatus.value = status;
  }

  // ============================================================
  // FIND STUDENT
  // ============================================================

  StudentRecord? byId(String id) {
    final index = students.indexWhere(
          (student) => student.id == id,
    );

    if (index == -1) {
      return null;
    }

    return students[index];
  }

  // ============================================================
  // UPDATE LOCAL STUDENT
  // ============================================================

  void updateStudent(
      String id,
      StudentRecord Function(
          StudentRecord current,
          ) updater,
      ) {
    final index = students.indexWhere(
          (student) => student.id == id,
    );

    if (index == -1) {
      return;
    }

    students[index] = updater(
      students[index],
    );
  }

  // ============================================================
  // CLEANUP
  // ============================================================

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}