import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/api_services/api_constants.dart';
import '../../../common/api_services/api_service.dart';
import '../../../common/api_services/student_application_service.dart';

import '../../model/students_record.dart';

class StudentsController extends GetxController {
  final ApiService _api = const ApiService();

  final StudentApplicationService
  _applicationService =
  StudentApplicationService();

  bool _isFetching = false;

  final searchController =
  TextEditingController();

  final searchQuery =
      ''.obs;

  final selectedStatus =
  Rxn<StudentStatus>();

  final RxList<StudentRecord> students =
      <StudentRecord>[].obs;

  final isLoading =
      false.obs;

  final errorMessage =
      ''.obs;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      searchQuery.value =
          searchController.text.trim();
    });

    fetchStudents();
  }

  // ============================================================
  // FETCH STUDENTS
  // ============================================================

  Future<void> fetchStudents({
    bool force = false,
  }) async {
    if (_isFetching && !force) {
      debugPrint(
        'STUDENTS FETCH SKIPPED: already fetching',
      );
      return;
    }

    _isFetching = true;

    final stopwatch =
    Stopwatch()..start();

    debugPrint(
      '========== STUDENTS FETCH START ==========',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final apiStart =
          stopwatch.elapsedMilliseconds;

      final response =
      await _api.get(
        url:
        '${ApiConstants.baseUrl}/students/profiles/',
      );

      debugPrint(
        'STUDENTS API TIME: '
            '${stopwatch.elapsedMilliseconds - apiStart} ms',
      );

      List<dynamic> data;

      if (response is List) {
        data = response;
      } else if (
      response is Map<String, dynamic> &&
          response['results'] is List) {
        data =
        response['results'] as List;
      } else {
        throw Exception(
          'Expected student profiles list, '
              'but received: $response',
        );
      }

      final parseStart =
          stopwatch.elapsedMilliseconds;

      students.assignAll(
        data.map((json) {
          return StudentRecord.fromJson(
            Map<String, dynamic>.from(
              json,
            ),
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

      debugPrint(
        'STUDENTS LOADED: '
            '${students.length}',
      );
    } catch (e, stackTrace) {
      debugPrint(
        'STUDENTS ERROR: $e',
      );

      debugPrint(
        '$stackTrace',
      );

      errorMessage.value =
          e.toString();
    } finally {
      isLoading.value = false;
      _isFetching = false;

      debugPrint(
        '========== STUDENTS FETCH END ==========',
      );
    }
  }

  // ============================================================
  // FORCE REFRESH
  // ============================================================

  Future<void> refreshStudents({bool force = false}) async {
    await fetchStudents(force: force);
  }

  // ============================================================
  // FILTERED STUDENTS
  // ============================================================

  List<StudentRecord>
  get filteredStudents {
    final query =
    searchQuery.value
        .toLowerCase();

    return students.where(
          (student) {
        final matchesStatus =
            selectedStatus.value ==
                null ||
                student.status ==
                    selectedStatus.value;

        final matchesQuery =
            query.isEmpty ||
                student.name
                    .toLowerCase()
                    .contains(query) ||
                student.email
                    .toLowerCase()
                    .contains(query);

        return matchesStatus &&
            matchesQuery;
      },
    ).toList();
  }

  // ============================================================
  // STATUS FILTER
  // ============================================================

  void setStatusFilter(
      StudentStatus? status,
      ) {
    selectedStatus.value =
        status;
  }

  // ============================================================
  // FIND STUDENT
  // ============================================================

  StudentRecord? byId(
      String id,
      ) {
    final index =
    students.indexWhere(
          (student) =>
      student.id == id,
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
    final index =
    students.indexWhere(
          (student) =>
      student.id == id,
    );

    if (index == -1) {
      return;
    }

    students[index] =
        updater(
          students[index],
        );
  }

  // ============================================================
  // GET STUDENT APPLICATION ID
  // ============================================================

  Future<String?> getApplicationId(
      StudentRecord student,
      ) async {
    /*
     * If your StudentRecord already contains
     * applicationId, use that instead.
     *
     * Otherwise retrieve the application using
     * the student/application endpoint.
     */

    try {
      final response =
      await _api.get(
        url:
        '${ApiConstants.baseUrl}/students/applications/',
      );

      if (response is List) {
        for (final item in response) {
          if (item is! Map) {
            continue;
          }

          final data =
          Map<String, dynamic>.from(
            item,
          );

          final applicationStudent =
          data['student'];

          if (applicationStudent
              ?.toString() ==
              student.id) {
            return data['id']
                ?.toString();
          }

          if (applicationStudent
          is Map &&
              applicationStudent['id']
                  ?.toString() ==
                  student.id) {
            return data['id']
                ?.toString();
          }
        }
      }

      if (response
      is Map<String, dynamic>) {
        final results =
        response['results'];

        if (results is List) {
          for (final item
          in results) {
            if (item is! Map) {
              continue;
            }

            final data =
            Map<String, dynamic>.from(
              item,
            );

            final applicationStudent =
            data['student'];

            if (applicationStudent
                ?.toString() ==
                student.id) {
              return data['id']
                  ?.toString();
            }

            if (applicationStudent
            is Map &&
                applicationStudent['id']
                    ?.toString() ==
                    student.id) {
              return data['id']
                  ?.toString();
            }
          }
        }
      }
    } catch (e) {
      debugPrint(
        'GET APPLICATION ID ERROR: $e',
      );
    }

    return null;
  }

  // ============================================================
  // UPLOAD STUDENT DOCUMENT
  // ============================================================

  Future<bool> uploadStudentDocument({
    required StudentRecord student,
    required String fieldName,
    required File file,
    String? documentId,
  }) async {
    try {
      isLoading.value = true;

      debugPrint(
        '===========================================',
      );

      debugPrint(
        'ADMIN DOCUMENT UPLOAD',
      );

      debugPrint(
        'STUDENT: ${student.name}',
      );

      debugPrint(
        'STUDENT ID: ${student.id}',
      );

      debugPrint(
        'FIELD: $fieldName',
      );

      debugPrint(
        'FILE: ${file.path}',
      );

      // --------------------------------------------------------
      // FIND APPLICATION
      // --------------------------------------------------------

      final applicationId =
      await getApplicationId(
        student,
      );

      if (applicationId == null ||
          applicationId.isEmpty) {
        throw Exception(
          'Student application was not found.',
        );
      }

      debugPrint(
        'APPLICATION ID: '
            '$applicationId',
      );

      // --------------------------------------------------------
      // UPLOAD TO DJANGO
      // --------------------------------------------------------

      final response =
      await _applicationService
          .uploadStudentDocument(
        applicationId:
        applicationId,
        fieldName:
        fieldName,
        file: file,
      );

      debugPrint(
        'DOCUMENT UPLOAD RESPONSE: '
            '$response',
      );

      // --------------------------------------------------------
      // REFRESH STUDENT FROM BACKEND
      // --------------------------------------------------------

      await fetchStudents(
        force: true,
      );

      debugPrint(
        'DOCUMENT UPLOAD SUCCESS',
      );

      debugPrint(
        '===========================================',
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        'DOCUMENT UPLOAD ERROR: $e',
      );

      debugPrint(
        '$stackTrace',
      );

      errorMessage.value =
          e.toString();

      Get.snackbar(
        'Upload failed',
        e.toString(),
        snackPosition:
        SnackPosition.BOTTOM,
        backgroundColor:
        Colors.red,
        colorText:
        Colors.white,
        margin:
        const EdgeInsets.all(16),
      );

      return false;
    } finally {
      isLoading.value = false;
    }
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