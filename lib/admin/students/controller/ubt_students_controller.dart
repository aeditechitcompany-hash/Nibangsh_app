import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/api_services/api_constants.dart';
import '../../../common/api_services/api_service.dart';
import '../../model/students_record.dart';

class UbtStudentsController extends GetxController {
  final ApiService _api = const ApiService();

  final searchController = TextEditingController();

  final searchQuery = ''.obs;

  final RxList<UbtStudent> students =
      <UbtStudent>[].obs;

  final isLoading = false.obs;

  final isUpdating = false.obs;

  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      searchQuery.value =
          searchController.text.trim();
    });

    fetchStudents();
  }

  // ==========================================================
  // FETCH STUDENTS
  // ==========================================================

  Future<void> fetchStudents() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _api.get(
        url:
        '${ApiConstants.baseUrl}/students/profiles/ubt-students/',
      );

      List<dynamic> data;

      if (response is List) {
        data = response;
      } else if (response is Map &&
          response['results'] is List) {
        data = response['results'] as List;
      } else {
        throw Exception(
          'Expected students list, but received: $response',
        );
      }

      final parsedStudents = <UbtStudent>[];

      for (final item in data) {
        if (item is Map) {
          parsedStudents.add(
            UbtStudent.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }

      students.assignAll(parsedStudents);
    } catch (e) {
      errorMessage.value =
          _cleanErrorMessage(e);

      debugPrint(
        'UBT STUDENTS ERROR: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================================
  // SEARCH
  // ==========================================================

  List<UbtStudent> get filteredStudents {
    final query =
    searchQuery.value.toLowerCase().trim();

    if (query.isEmpty) {
      return students.toList();
    }

    return students.where((student) {
      return student.fullName
          .toLowerCase()
          .contains(query) ||
          student.email
              .toLowerCase()
              .contains(query) ||
          student.phone
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  // ==========================================================
  // FIND STUDENT
  // ==========================================================

  UbtStudent? byId(String id) {
    final index = students.indexWhere(
          (student) => student.id == id,
    );

    if (index == -1) {
      return null;
    }

    return students[index];
  }

  // ==========================================================
  // UPDATE LOCAL STUDENT
  // ==========================================================

  void updateStudent(
      UbtStudent updatedStudent,
      ) {
    final index = students.indexWhere(
          (student) =>
      student.id == updatedStudent.id,
    );

    if (index == -1) {
      return;
    }

    students[index] = updatedStudent;

    students.refresh();
  }

  // ==========================================================
  // UPDATE BASIC INFORMATION
  //
  // PATCH:
  // /students/profiles/{id}/basic-info/
  // ==========================================================

  Future<bool> updateBasicInfo({
    required String studentId,
    required String fullName,
    required String phoneNumber,
    required String email,
  }) async {
    try {
      isUpdating.value = true;

      final response = await _api.patch(
        url:
        '${ApiConstants.baseUrl}/students/profiles/$studentId/basic-info/',
        body: {
          'full_name': fullName.trim(),
          'phone_number': phoneNumber.trim(),
          'email': email.trim(),
        },
      );

      if (response is! Map) {
        throw Exception(
          'Invalid response from server.',
        );
      }

      final responseMap =
      Map<String, dynamic>.from(response);

      final updated =
      UbtStudent.fromJson(responseMap);

      updateStudent(updated);

      // Fetch again from backend so the UI
      // definitely contains the saved data.
      await fetchStudents();

      return true;
    } catch (e) {
      debugPrint(
        'UPDATE UBT STUDENT ERROR: $e',
      );

      Get.snackbar(
        'Update failed',
        _cleanErrorMessage(e),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );

      return false;
    } finally {
      isUpdating.value = false;
    }
  }
  String _cleanErrorMessage(Object error) {
    final message =
    error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring(
        'Exception: '.length,
      );
    }

    return message;
  }

  Future<void> refreshStudents() async {
    await fetchStudents();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}