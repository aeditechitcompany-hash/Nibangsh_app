import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  final Rxn<DateTime> departureDateTime = Rxn<DateTime>();
  final RxnString ticketFileName = RxnString();

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
    if (picked != null) ticketFileName.value = picked.name;
  }

  void submit() {
    if (!isComplete) return;

    Get.find<StudentsController>().updateStudent(
      student.id,
      (current) => current.copyWith(
        currentStep: 11,
        flightNumber: flightNumberController.text.trim(),
        airline: airlineController.text.trim(),
        departureAirport: departureAirportController.text.trim(),
        arrivalAirport: arrivalAirportController.text.trim(),
        departureDateTime: departureDateTime.value,
        ticketFileName: ticketFileName.value,
        flightStatus: 'Booked',
        status: StudentStatus.approved,
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
