import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/util/academic_constants.dart';
import '../../../../common/util/app_colors.dart';
import '../../model/students_record.dart';
import '../controller/step10_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class Step10Screen extends StatelessWidget {
  const Step10Screen({super.key});

  static const Color stepColor = Color(
    0xFF0D9488,
  );

  @override
  Widget build(BuildContext context) {
    final StudentRecord student = Get.arguments as StudentRecord;
    final controller = Get.put(Step10Controller(student), tag: student.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveDashboardWrapper(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStudentCard(student),
                    const SizedBox(height: 16),
                    _buildFinalStepBanner(student),
                    const SizedBox(height: 20),
                    _sectionLabel('FLIGHT NUMBER'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller.flightNumberController,
                      Icons.confirmation_number_outlined,
                      'e.g. QF 025',
                    ),
                    const SizedBox(height: 20),
                    _sectionLabel('AIRLINE'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller.airlineController,
                      Icons.airlines_outlined,
                      'e.g. Qantas Airways',
                    ),
                    const SizedBox(height: 20),
                    _sectionLabel('DEPARTURE AIRPORT'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller.departureAirportController,
                      Icons.flight_takeoff,
                      'e.g. DEL — Indira Gandhi',
                    ),
                    const SizedBox(height: 20),
                    _sectionLabel('ARRIVAL AIRPORT'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller.arrivalAirportController,
                      Icons.flight_land,
                      'e.g. MEL — Melbourne',
                    ),
                    const SizedBox(height: 20),
                    _sectionLabel('DEPARTURE DATE & TIME'),
                    const SizedBox(height: 8),
                    _buildDateTimeField(context, controller),
                    const SizedBox(height: 20),
                    _buildUploadBox(controller),
                    const SizedBox(height: 24),
                    _buildSubmitButton(controller),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF115E59), Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Step 10 of 10 · Admin Approval',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.flight_takeoff_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flight Ticket',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Record Flight Booking',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Student card ──
  Widget _buildStudentCard(StudentRecord student) {
    final flag = AcademicConstants.countryFlags[student.countryName] ?? '🌍';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              student.initials,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$flag ${student.countryName} • ${student.university}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: student.status.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              student.status.label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: student.status.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Final step banner ──
  Widget _buildFinalStepBanner(StudentRecord student) {
    final firstName = student.name.trim().split(RegExp(r'\s+')).first;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.flight_takeoff_rounded,
            color: Colors.white,
            size: 22,
          ),
          const SizedBox(height: 8),
          const Text(
            'Final Step — Flight Booking',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Record the flight details to complete $firstName\'s journey.',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.bold,
      color: AppColors.textGrey,
      letterSpacing: 0.4,
    ),
  );

  // ── Generic text field ──
  Widget _buildTextField(
      TextEditingController textController,
      IconData icon,
      String hint,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: TextField(
        controller: textController,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 13.5,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: Icon(icon, size: 18, color: AppColors.textGrey),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ── Departure date & time field ──
  Widget _buildDateTimeField(
      BuildContext context,
      Step10Controller controller,
      ) {
    return Obx(() {
      final hasDateTime = controller.departureDateTime.value != null;
      return GestureDetector(
        onTap: () => controller.pickDateTime(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 17,
                color: AppColors.textGrey,
              ),
              const SizedBox(width: 10),
              Text(
                hasDateTime
                    ? controller.formattedDateTime
                    : 'mm/dd/yyyy --:-- --',
                style: TextStyle(
                  fontSize: 13.5,
                  color: hasDateTime ? AppColors.textDark : AppColors.textGrey,
                  fontWeight: hasDateTime ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Upload row (dashed) ──
  Widget _buildUploadBox(Step10Controller controller) {
    return Obx(() {
      final fileName = controller.ticketFileName.value;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: stepColor.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: stepColor.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 18,
              color: stepColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                fileName ?? 'Upload Ticket / Itinerary',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: fileName != null ? AppColors.textDark : stepColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: controller.browseForFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: stepColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Browse',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── Submit button ──
  Widget _buildSubmitButton(Step10Controller controller) {
    return Obx(() {
      controller.formTick;
      final complete = controller.isComplete;
      return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: complete ? controller.submit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: complete
                ? stepColor
                : AppColors.borderGrey.withOpacity(0.5),
            disabledBackgroundColor: AppColors.borderGrey.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: Text(
            '✈️  Confirm Booking — Complete All 10 Steps!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: complete ? Colors.white : AppColors.textGrey,
            ),
          ),
        ),
      );
    });
  }
}
