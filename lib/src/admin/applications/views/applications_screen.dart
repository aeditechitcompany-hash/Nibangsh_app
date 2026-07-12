import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/util/academic_constants.dart';
import '../../../../common/util/app_colors.dart';
import '../../../../common/util/app_route.dart';
import '../../model/students_record.dart';
import '../controller/applications_controller.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApplicationsController());

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildApplicationList(controller),
                  const SizedBox(height: 100),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkBlue, AppColors.darkBlue, AppColors.primaryRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Applications',
            style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Track all student application statuses',
            style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12.5),
          ),
        ],
      ),
    );
  }

  // ── Application list ──
  Widget _buildApplicationList(ApplicationsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: controller.applications.map((student) => _applicationCard(student)).toList(),
      ),
    );
  }

  Widget _applicationCard(StudentRecord student) {
    final flag = AcademicConstants.countryFlags[student.countryName] ?? '🌍';

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoute.studentProfile, arguments: student),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderGrey),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    student.initials,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$flag ${student.countryName} • ${student.university}',
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: student.status.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    student.status.label,
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: student.status.color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _segmentedProgressBar(student),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step ${student.currentStep}/${StudentRecord.totalSteps} — ${student.currentStepTitle}',
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 10),
                Text(
                  'Docs: ${student.documentsUploaded}/${student.documentsTotal}',
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _segmentedProgressBar(StudentRecord student) {
    final total = StudentRecord.totalSteps;
    return Row(
      children: List.generate(total, (index) {
        final stepNumber = index + 1;
        Color color;
        if (stepNumber <= student.currentStep) {
          color = AppColors.primaryBlue;
        } else if (stepNumber == student.currentStep+1) {
          color = Colors.amber.shade600;
        } else {
          color = AppColors.borderGrey;
        }
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: stepNumber == total ? 0 : 3),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          ),
        );
      }),
    );
  }
}