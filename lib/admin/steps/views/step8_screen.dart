import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/util/academic_constants.dart';
import '../../../../common/util/app_colors.dart';
import '../../model/students_record.dart';
import '../controller/step8_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class Step8Screen extends StatelessWidget {
  const Step8Screen({super.key});

  static const Color stepColor = Color(
    0xFF16A34A,
  );

  @override
  Widget build(BuildContext context) {
    final StudentRecord student = Get.arguments as StudentRecord;
    final controller = Get.put(Step8Controller(student), tag: student.id);

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
                    _buildSummaryCard(student),
                    const SizedBox(height: 20),
                    _sectionLabel('COURSE COMMENCEMENT DATE'),
                    const SizedBox(height: 8),
                    _buildDateField(context, controller),
                    const SizedBox(height: 20),
                    _sectionLabel('SCHOLARSHIP STATUS'),
                    const SizedBox(height: 8),
                    _buildScholarshipRow(controller),
                    const SizedBox(height: 20),
                    _sectionLabel('ADMIN NOTES'),
                    const SizedBox(height: 8),
                    _buildNotesField(controller),
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
          colors: [Color(0xFF14532D), Color(0xFF16A34A)],
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
                  'Step 8 of 10 · Admin Approval',
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
                  Icons.card_membership_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Final Selection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Confirm Final Selection',
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
              color: AppColors.primaryBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'In Review',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Final Selection Summary card ──
  Widget _buildSummaryCard(StudentRecord student) {
    final flag = AcademicConstants.countryFlags[student.countryName] ?? '🌍';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF15803D), Color(0xFF16A34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Final Selection Summary',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            student.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            student.course,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${student.university} • $flag ${student.countryName}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _summaryChip('GPA ${student.gpa}'),
              const SizedBox(width: 8),
              _summaryChip(
                '${student.languageTestName} ${student.languageTestScore}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryChip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11.5,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.bold,
      color: AppColors.textGrey,
      letterSpacing: 0.4,
    ),
  );

  // ── Date field ──
  Widget _buildDateField(BuildContext context, Step8Controller controller) {
    return Obx(() {
      final hasDate = controller.commencementDate.value != null;
      return GestureDetector(
        onTap: () => controller.pickDate(context),
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
                hasDate ? controller.formattedDate : 'mm/dd/yyyy',
                style: TextStyle(
                  fontSize: 13.5,
                  color: hasDate ? AppColors.textDark : AppColors.textGrey,
                  fontWeight: hasDate ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Scholarship status toggle ──
  Widget _buildScholarshipRow(Step8Controller controller) {
    return Obx(
          () => Row(
        children: Step8Controller.scholarshipOptions.map((option) {
          final selected = controller.scholarshipStatus.value == option;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: option == Step8Controller.scholarshipOptions.last
                    ? 0
                    : 8,
              ),
              child: GestureDetector(
                onTap: () => controller.setScholarshipStatus(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? stepColor.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? stepColor : AppColors.borderGrey,
                      width: selected ? 1.4 : 1,
                    ),
                  ),
                  child: Text(
                    option,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: selected ? stepColor : AppColors.textGrey,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Notes field ──
  Widget _buildNotesField(Step8Controller controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: TextField(
        controller: controller.notesController,
        maxLines: 3,
        style: const TextStyle(fontSize: 13, color: AppColors.textDark),
        decoration: const InputDecoration(
          hintText: 'Final remarks for the student record...',
          hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 13),
          contentPadding: EdgeInsets.all(14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ── Submit button ──
  Widget _buildSubmitButton(Step8Controller controller) {
    return Obx(() {
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
            '🎓 Confirm Final Selection & Approve Student',
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
