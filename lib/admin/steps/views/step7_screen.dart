import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/util/academic_constants.dart';
import '../../../../common/util/app_colors.dart';
import '../../model/students_record.dart';
import '../controller/step7_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class Step7Screen extends StatelessWidget {
  const Step7Screen({super.key});

  static const Color stepColor = Color(0xFF4F46E5);

  @override
  Widget build(BuildContext context) {
    final StudentRecord student = Get.arguments as StudentRecord;
    final controller = Get.put(Step7Controller(student), tag: student.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            ResponsiveDashboardWrapper(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStudentCard(student),
                    const SizedBox(height: 16),
                    _buildInfoBanner(controller, student),
                    _buildChecklist(),
                    const SizedBox(height: 14),
                    _buildUploadRow(controller),
                    const SizedBox(height: 16),
                    _buildVerifiedBanner(controller),
                    const SizedBox(height: 8),
                    _buildActionButton(controller),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
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
          colors: [Color(0xFF312E81), Color(0xFF4F46E5)],
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
                  'Step 7 of 10 · Admin Approval',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
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
                child: const Icon(Icons.verified_outlined, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LOC Verify', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text('Verify LOC Document', style: TextStyle(color: Colors.white70, fontSize: 14)),
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
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 3),
                Text('$flag ${student.countryName} • ${student.university}',
                    style: const TextStyle(fontSize: 12.5, color: AppColors.textGrey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('In Review', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
          ),
        ],
      ),
    );
  }

  // ── Checklist description banner — only shown before verification ──
  Widget _buildInfoBanner(Step7Controller controller, StudentRecord student) {
    return Obx(() {
      if (controller.isVerified.value) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: stepColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('LOC Verification Checklist',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: stepColor)),
              const SizedBox(height: 4),
              Text(
                'Verify the Letter of Confirmation from ${student.university}. Ensure all details are correct before approving.',
                style: TextStyle(fontSize: 14, color: stepColor.withOpacity(0.9), height: 1.4),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Static checklist (always shown, informational) ──
  Widget _buildChecklist() {
    return Column(
      children: Step7Controller.checklistItems.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 13, color: Color(0xFF16A34A)),
              ),
              const SizedBox(width: 12),
              Text(item, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Upload row ──
  Widget _buildUploadRow(Step7Controller controller) {
    return Obx(() {
      final fileName = controller.locFileName.value;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: stepColor.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: stepColor.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            Icon(Icons.upload_outlined, size: 18, color: stepColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                fileName ?? 'Upload LOC Document',
                style: TextStyle(
                  fontSize: 14.5,
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
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Browse', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    });
  }

  // ── Green "ready to approve" banner — only after verifying ──
  Widget _buildVerifiedBanner(Step7Controller controller) {
    return Obx(() {
      if (!controller.isVerified.value) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF16A34A).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF16A34A).withOpacity(0.3)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF16A34A)),
              SizedBox(width: 8),
              Text(
                'LOC Verified ✓ — Ready to Approve',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Bottom button — swaps between "Mark as Verified" and "Approve" ──
  Widget _buildActionButton(Step7Controller controller) {
    return Obx(() {
      if (!controller.isVerified.value) {
        final canMark = controller.canMarkVerified;
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: canMark ? controller.markVerified : null,
            icon: Icon(Icons.verified_outlined, size: 18, color: canMark ? AppColors.textDark : AppColors.textGrey),
            label: Text(
              'Mark LOC as Verified',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: canMark ? AppColors.textDark : AppColors.textGrey,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: canMark ? AppColors.borderGrey : AppColors.borderGrey.withOpacity(0.5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        );
      }

      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: controller.submit,
          icon: const Icon(Icons.verified_outlined, color: Colors.white, size: 18),
          label: const Text(
            'Approve LOC — Complete Step 7',
            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: stepColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
        ),
      );
    });
  }
}