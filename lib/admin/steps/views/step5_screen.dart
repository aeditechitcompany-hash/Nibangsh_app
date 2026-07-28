import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/util/academic_constants.dart';
import '../../../../common/util/app_colors.dart';
import '../../model/students_record.dart';
import '../controller/step5_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class Step5Screen extends StatelessWidget {
  const Step5Screen({super.key});

  static const Color stepColor = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    final StudentRecord student = Get.arguments as StudentRecord;
    final controller = Get.put(Step5Controller(student), tag: student.id);

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
                    _buildInfoBanner(student),
                    const SizedBox(height: 20),
                    _sectionLabel('APPLICATION REFERENCE NO.'),
                    const SizedBox(height: 8),
                    _buildRefNoField(controller),
                    const SizedBox(height: 20),
                    _sectionLabel('SUBMISSION DATE'),
                    const SizedBox(height: 8),
                    _buildDateField(context, controller),
                    const SizedBox(height: 20),
                    _buildUploadRow(controller),
                    const SizedBox(height: 24),
                    _buildSubmitButton(controller),
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
          colors: [Color(0xFF065F46), Color(0xFF16A34A)],
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
                  'Step 5 of 10 · Admin Approval',
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
                child: const Icon(Icons.description_outlined, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Apply to University', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text('Submit University Application', style: TextStyle(color: Colors.white70, fontSize: 12)),
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

  // ── University application info banner ──
  Widget _buildInfoBanner(StudentRecord student) {
    final flag = AcademicConstants.countryFlags[student.countryName] ?? '🌍';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: stepColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: stepColor.withOpacity(0.3)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('University Application', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: stepColor)),
            const SizedBox(height: 4),
            Text(student.university, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
            const SizedBox(height: 2),
            Text('$flag ${student.countryName} • ${student.course}', style: const TextStyle(fontSize: 11.5, color: Color(0xFF065F46))),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.4),
  );

  // ── Reference number field ──
  Widget _buildRefNoField(Step5Controller controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: TextField(
        controller: controller.refNoController,
        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textDark),
        decoration: const InputDecoration(
          hintText: 'APP-2024-XXXXX',
          hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 13.5),
          prefixIcon: Icon(Icons.tag, size: 18, color: AppColors.textGrey),
          contentPadding: EdgeInsets.symmetric(vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ── Date field ──
  Widget _buildDateField(BuildContext context, Step5Controller controller) {
    return Obx(() {
      final hasDate = controller.submissionDate.value != null;
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

  // ── Upload row ──
  Widget _buildUploadRow(Step5Controller controller) {
    return Obx(() {
      final fileName = controller.confirmationFileName.value;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: stepColor.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: stepColor.withOpacity(0.35), style: BorderStyle.solid),
        ),
        child: Row(
          children: [
            Icon(Icons.upload_outlined, size: 18, color: stepColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                fileName ?? 'Upload Confirmation Email',
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
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Browse', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    });
  }

  // ── Submit button ──
  Widget _buildSubmitButton(Step5Controller controller) {
    return Obx(() {
      controller.formTick;
      final complete = controller.isComplete;
      return SizedBox(
        width: double.infinity,
        height: 66,
        child: ElevatedButton.icon(
          onPressed: complete ? controller.submit : null,
          icon: Icon(Icons.description_outlined, color: complete ? Colors.white : AppColors.textGrey, size: 18),
          label: Text(
            'Confirm Application Submission — Approve Step 5',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
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