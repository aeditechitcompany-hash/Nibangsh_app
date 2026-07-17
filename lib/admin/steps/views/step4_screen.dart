import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/util/academic_constants.dart';
import '../../../../common/util/app_colors.dart';
import '../../model/students_record.dart';
import '../controller/step4_controller.dart';

class Step4Screen extends StatelessWidget {
  const Step4Screen({super.key});

  static const Color stepColor = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    final StudentRecord student = Get.arguments as StudentRecord;
    final controller = Get.put(Step4Controller(student), tag: student.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStudentCard(student),
                  const SizedBox(height: 16),
                  _buildInfoBanner(),
                  const SizedBox(height: 20),
                  _sectionLabel('INTERVIEW DATE'),
                  const SizedBox(height: 8),
                  _buildDateField(context, controller),
                  const SizedBox(height: 20),
                  _sectionLabel('INTERVIEW MODE'),
                  const SizedBox(height: 8),
                  _buildModeRow(controller),
                  const SizedBox(height: 20),
                  _sectionLabel('INTERVIEW RESULT'),
                  const SizedBox(height: 8),
                  _buildResultRow(controller),
                  const SizedBox(height: 20),
                  _sectionLabel('ADMIN NOTES'),
                  const SizedBox(height: 8),
                  _buildNotesField(controller),
                  const SizedBox(height: 24),
                  _buildSubmitButton(controller),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB45309), Color(0xFFF59E0B)],
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
          SizedBox(height: 30),
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
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Step 4 of 10 · Admin Approval',
                  style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600),
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
                child: const Icon(Icons.mic_none_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Interview', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text('Schedule & Record Interview', style: TextStyle(color: Colors.white70, fontSize: 12)),
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
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 3),
                Text('$flag ${student.countryName} • ${student.university}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('In Review', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: stepColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Interview Details', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
          SizedBox(height: 4),
          Text(
            'Schedule and conduct the consultation interview with the student. Record the result below.',
            style: TextStyle(fontSize: 12, color: Color(0xFFB45309), height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.4),
  );

  // ── Date field ──
  Widget _buildDateField(BuildContext context, Step4Controller controller) {
    return Obx(() {
      final hasDate = controller.interviewDate.value != null;
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
              const Icon(Icons.calendar_today_outlined, size: 17, color: AppColors.textGrey),
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

  // ── Mode row ──
  Widget _buildModeRow(Step4Controller controller) {
    const modes = ['In-Person', 'Video Call', 'Phone'];
    return Obx(() => Row(
      children: modes.map((mode) {
        final selected = controller.interviewMode.value == mode;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: mode == modes.last ? 0 : 8),
            child: _toggleChip(
              label: mode,
              selected: selected,
              color: AppColors.primaryBlue,
              onTap: () => controller.setMode(mode),
            ),
          ),
        );
      }).toList(),
    ));
  }

  // ── Result row ──
  Widget _buildResultRow(Step4Controller controller) {
    const results = [
      ('Passed', Color(0xFF16A34A)),
      ('Failed', Color(0xFFDC2626)),
      ('Rescheduled', Color(0xFF2563EB)),
    ];
    return Obx(() => Row(
      children: results.map((r) {
        final selected = controller.interviewResult.value == r.$1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: r.$1 == results.last.$1 ? 0 : 8),
            child: _toggleChip(
              label: r.$1,
              selected: selected,
              color: r.$2,
              onTap: () => controller.setResult(r.$1),
            ),
          ),
        );
      }).toList(),
    ));
  }

  Widget _toggleChip({required String label, required bool selected, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? color : AppColors.borderGrey, width: selected ? 1.4 : 1),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: selected ? color : AppColors.textGrey,
          ),
        ),
      ),
    );
  }

  // ── Notes ──
  Widget _buildNotesField(Step4Controller controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: TextField(
        controller: controller.notesController,
        maxLines: 4,
        style: const TextStyle(fontSize: 13),
        decoration: const InputDecoration(
          hintText: 'Interview feedback and observations...',
          hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 13),
          contentPadding: EdgeInsets.all(14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ── Submit button ──
  Widget _buildSubmitButton(Step4Controller controller) {
    return Obx(() {
      final complete = controller.isComplete;
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: complete ? controller.submit : null,
          icon: Icon(Icons.mic_none_rounded, color: complete ? Colors.white : AppColors.textGrey, size: 18),
          label: Text(
            'Record Interview & Approve Step 4',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: complete ? Colors.white : AppColors.textGrey,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: complete ? stepColor : AppColors.borderGrey.withOpacity(0.5),
            disabledBackgroundColor: AppColors.borderGrey.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
        ),
      );
    });
  }
}