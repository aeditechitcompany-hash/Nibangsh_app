import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/api_services/notification_service.dart';
import '../../model/students_record.dart';
import '../../overview/controller/overview_controller.dart';
import '../../students/controller/students_controller.dart';

class NotificationsController extends GetxController {
  final NotificationService _notificationService =
  NotificationService();

  // Existing activity list
  final activities = <RecentActivity>[].obs;

  // Publishing state
  final isPublishing = false.obs;

  // Form
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  // Notification type
  final selectedType = 'info'.obs;

  // Recipient mode
  // true  = all students
  // false = selected students
  final sendToAllStudents = true.obs;

  // Selected student UUIDs
  final selectedStudentIds = <String>{}.obs;

  // Search field for students
  final studentSearchController = TextEditingController();
  final studentSearchQuery = ''.obs;

  // Existing StudentsController
  late final StudentsController studentsController;

  @override
  void onInit() {
    super.onInit();

    /*
     * Reuse the existing StudentsController.
     *
     * If it already exists because the Students screen was opened,
     * Get.find() returns the existing instance.
     *
     * Otherwise Get.put() creates it and fetches students.
     */
    if (Get.isRegistered<StudentsController>()) {
      studentsController = Get.find<StudentsController>();
    } else {
      studentsController = Get.put(StudentsController());
    }

    _setupSearchListener();

    // Existing dummy activity data for now.
    activities.assignAll(const [
      RecentActivity(
        name: 'Meera Patel',
        action: 'Visa approved',
        time: '1h ago',
        status: ActivityStatus.approved,
      ),
      RecentActivity(
        name: 'Rahul Gupta',
        action: 'Uploaded documents',
        time: '3h ago',
        status: ActivityStatus.inProgress,
      ),
      RecentActivity(
        name: 'Anjali Singh',
        action: 'Visa in progress',
        time: '5h ago',
        status: ActivityStatus.inProgress,
      ),
      RecentActivity(
        name: 'Karan Mehta',
        action: 'Application rejected',
        time: '1d ago',
        status: ActivityStatus.rejected,
      ),
    ]);
  }

  void _setupSearchListener() {
    studentSearchController.addListener(() {
      studentSearchQuery.value =
          studentSearchController.text.trim().toLowerCase();
    });
  }

  // ─────────────────────────────────────────────
  // Recipient mode
  // ─────────────────────────────────────────────

  void selectAllStudents() {
    sendToAllStudents.value = true;
    selectedStudentIds.clear();
    studentSearchController.clear();
  }

  void selectSpecificStudents() {
    sendToAllStudents.value = false;
  }

  // ─────────────────────────────────────────────
  // Student selection
  // ─────────────────────────────────────────────

  bool isStudentSelected(String studentId) {
    return selectedStudentIds.contains(studentId);
  }

  void toggleStudent(StudentRecord student) {
    final id = student.id;

    if (selectedStudentIds.contains(id)) {
      selectedStudentIds.remove(id);
    } else {
      selectedStudentIds.add(id);
    }

    // Important for RxSet
    selectedStudentIds.refresh();
  }

  void clearSelectedStudents() {
    selectedStudentIds.clear();
    selectedStudentIds.refresh();
  }

  void selectAllVisibleStudents() {
    final visibleStudents = filteredStudents;

    for (final student in visibleStudents) {
      selectedStudentIds.add(student.id);
    }

    selectedStudentIds.refresh();
  }

  void deselectAllVisibleStudents() {
    final visibleStudents = filteredStudents;

    for (final student in visibleStudents) {
      selectedStudentIds.remove(student.id);
    }

    selectedStudentIds.refresh();
  }

  bool get allVisibleStudentsSelected {
    final visibleStudents = filteredStudents;

    if (visibleStudents.isEmpty) {
      return false;
    }

    return visibleStudents.every(
          (student) => selectedStudentIds.contains(student.id),
    );
  }

  // ─────────────────────────────────────────────
  // Student search
  // ─────────────────────────────────────────────

  List<StudentRecord> get filteredStudents {
    final query = studentSearchQuery.value;

    if (query.isEmpty) {
      return studentsController.students.toList();
    }

    return studentsController.students.where((student) {
      return student.name.toLowerCase().contains(query) ||
          student.email.toLowerCase().contains(query) ||
          student.phone.toLowerCase().contains(query);
    }).toList();
  }

  // ─────────────────────────────────────────────
  // Selected students
  // ─────────────────────────────────────────────

  List<StudentRecord> get selectedStudents {
    return studentsController.students
        .where(
          (student) => selectedStudentIds.contains(student.id),
    )
        .toList();
  }

  int get selectedStudentCount {
    return selectedStudentIds.length;
  }

  // ─────────────────────────────────────────────
  // Notification type
  // ─────────────────────────────────────────────

  void setNotificationType(String type) {
    selectedType.value = type;
  }

  // ─────────────────────────────────────────────
  // Publish
  // ─────────────────────────────────────────────

  Future<void> publishNotification() async {
    final title = titleController.text.trim();
    final message = messageController.text.trim();

    // Validate title
    if (title.isEmpty) {
      Get.snackbar(
        'Missing title',
        'Please enter a notification title.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Validate message
    if (message.isEmpty) {
      Get.snackbar(
        'Missing message',
        'Please enter a notification message.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Validate recipient
    if (!sendToAllStudents.value &&
        selectedStudentIds.isEmpty) {
      Get.snackbar(
        'No students selected',
        'Please select at least one student.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isPublishing.value = true;

      final response =
      await _notificationService.publishNotification(
        title: title,
        message: message,
        notificationType: selectedType.value,

        /*
         * All students:
         *   userIds = []
         *   sendToAllStudents = true
         *
         * Specific students:
         *   userIds = selected UUIDs
         *   sendToAllStudents = false
         */
        userIds: sendToAllStudents.value
            ? <String>[]
            : selectedStudentIds.toList(),
        sendToAllStudents: sendToAllStudents.value,
      );

      final count =
          int.tryParse(
            response['recipient_count']?.toString() ?? '',
          ) ??
              0;

      // Clear form after successful publish
      titleController.clear();
      messageController.clear();

      // Reset recipient selection
      selectAllStudents();

      Get.snackbar(
        'Notification Published',
        'Notification sent to '
            '$count student${count == 1 ? '' : 's'}.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Publishing Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isPublishing.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // Existing unread count
  // ─────────────────────────────────────────────

  int get unreadCount => activities.length;

  // ─────────────────────────────────────────────
  // Cleanup
  // ─────────────────────────────────────────────

  @override
  void onClose() {
    titleController.dispose();
    messageController.dispose();
    studentSearchController.dispose();
    super.onClose();
  }
}