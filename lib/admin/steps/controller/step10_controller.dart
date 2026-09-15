import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/api_services/process_service.dart';
import '../../../common/api_services/student_application_service.dart';
import '../../../common/services/document_picker_service.dart';
import '../../model/students_record.dart';
import '../../students/controller/students_controller.dart';

class Step10Controller extends GetxController {
  final StudentRecord student;
  Step10Controller(this.student);

  final TextEditingController flightNumberController = TextEditingController();
  final TextEditingController airlineController = TextEditingController();
  final TextEditingController departureAirportController =
      TextEditingController();
  final TextEditingController arrivalAirportController =
      TextEditingController();
  final ProcessService _processService = ProcessService();
  final StudentApplicationService _applicationService =
  StudentApplicationService();
  final isSubmitting = false.obs;
  final Rxn<DateTime> departureDateTime = Rxn<DateTime>();
  final RxnString ticketFileName = RxnString();
  final RxnString ticketFilePath = RxnString();

  final RxBool _formTick = false.obs;
  bool get formTick => _formTick.value;

  @override
  void onInit() {
    super.onInit();
    for (final c in [
      flightNumberController,
      airlineController,
      departureAirportController,
      arrivalAirportController,
    ]) {
      c.addListener(() => _formTick.toggle());
    }
  }

  bool get isComplete =>
      flightNumberController.text.trim().isNotEmpty &&
      airlineController.text.trim().isNotEmpty &&
      departureAirportController.text.trim().isNotEmpty &&
      arrivalAirportController.text.trim().isNotEmpty &&
      departureDateTime.value != null &&
      ticketFileName.value != null;

  Future<void> pickDateTime(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: departureDateTime.value ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (pickedDate == null) return;
    if (!context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: departureDateTime.value != null
          ? TimeOfDay.fromDateTime(departureDateTime.value!)
          : TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    departureDateTime.value = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  String get formattedDateTime {
    final d = departureDateTime.value;
    if (d == null) return '';
    final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final period = d.hour >= 12 ? 'PM' : 'AM';
    return '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year} '
        '${hour12.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> browseForFile() async {
    final picked = await DocumentPickerService.pickDocument();
    if (picked != null)  {
      ticketFileName.value = picked.name;
      ticketFilePath.value = picked.path;
    }
  }
  Future<void> submit() async {
    if (!isComplete || isSubmitting.value) return;

    final processId = student.processId;

    if (processId == null || processId.isEmpty) {
      Get.snackbar(
        'Process Error',
        'Student process was not found.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final ticketPath = ticketFilePath.value;

    if (ticketPath == null || ticketPath.isEmpty) {
      Get.snackbar(
        'Ticket Required',
        'Please select the flight ticket before submitting.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      // 1. Upload Step 10 application data + ticket file
      await _applicationService.updateApplication(
        fields: {
          'flight_number': flightNumberController.text.trim(),
          'airline': airlineController.text.trim(),
          'departure_airport':
          departureAirportController.text.trim(),
          'arrival_airport':
          arrivalAirportController.text.trim(),
          'departure_date_time':
          departureDateTime.value!.toIso8601String(),
        },
        files: {
          'ticket_file': File(ticketPath),
        },
      );

      // 2. Only complete the process after the upload succeeds
      final response = await _processService.completeStage(
        processId: processId,
      );



      final finished = response['finished'] == true;

      if (!finished) {
        throw Exception(
          'Step 10 was not marked as the final completed step by the server.',
        );
      }

      // 3. Update local admin/student UI state
      Get.find<StudentsController>().updateStudent(
        student.id,
            (current) => current.copyWith(
          flightNumber: flightNumberController.text.trim(),
          airline: airlineController.text.trim(),
          departureAirport:
          departureAirportController.text.trim(),
          arrivalAirport:
          arrivalAirportController.text.trim(),
          departureDateTime: departureDateTime.value,
          ticketFileName: ticketFileName.value,
          flightStatus: 'Booked',
          status: StudentStatus.approved,
          processCompleted: true,
          completedSteps: {
            ...current.completedSteps,
            10,
          }.toList()
            ..sort(),
        ),
      );

      Get.back();

      Get.snackbar(
        'All 10 Steps Complete 🎉',
        '${student.name}\'s journey is fully booked.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Unable to Complete Step 10',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    flightNumberController.dispose();
    airlineController.dispose();
    departureAirportController.dispose();
    arrivalAirportController.dispose();
    super.onClose();
  }
}
