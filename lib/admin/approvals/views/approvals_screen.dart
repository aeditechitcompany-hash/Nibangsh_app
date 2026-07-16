import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/util/academic_constants.dart';
import '../../../../common/util/app_colors.dart';
import '../../../../common/util/app_route.dart';
import '../../model/students_record.dart';
import '../../steps/views/step4_screen.dart';
import '../../steps/views/step5_screen.dart';
import '../../steps/views/step6_screen.dart';
import '../../steps/views/step7_screen.dart';
import '../controller/approvals_controller.dart';

class ApprovalsScreen extends StatelessWidget {
  const ApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApprovalsController());

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(controller),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.only(top: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepFilterChips(controller),
                  const SizedBox(height: 10),
                  _buildStatusFilterTabs(controller),
                  const SizedBox(height: 16),
                  _buildApprovalList(controller, context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(ApprovalsController controller) {
    final navyDark = Color.lerp(AppColors.primaryBlue, Colors.black, 0.62)!;
    final navyLight = Color.lerp(AppColors.primaryBlue, Colors.black, 0.35)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [navyDark, navyLight],
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
            'Approvals',
            style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Admin steps 4-10 • Manage student progress',
            style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _topPill('${controller.awaitingCount}', 'Awaiting', Colors.white)),
              const SizedBox(width: 10),
              Expanded(
                child: _topPill(
                  '${ApprovalsController.adminStepsCount}',
                  'Steps (4-10)',
                  Colors.amber,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _topPill('${controller.allDoneCount}', 'All Done', const Color(0xFF4ADE80)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topPill(String value, String label, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: valueColor, fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 10.5)),
        ],
      ),
    );
  }

  // ── Step filter chips: All Steps, Step 4 ... Step 10 ──
  Widget _buildStepFilterChips(ApprovalsController controller) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: ApprovalsController.adminSteps.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final step = isAll ? null : ApprovalsController.adminSteps[index - 1];

          return Obx(() {
            final selected = controller.selectedStep.value == (isAll ? null : step!.id);
            return GestureDetector(
              onTap: () => controller.setStepFilter(isAll ? null : step!.id),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryBlue : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: selected ? AppColors.primaryBlue : AppColors.borderGrey),
                ),
                alignment: Alignment.center,
                child: Text(
                  isAll ? 'All Steps' : 'Step ${step!.id}',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textGrey,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // ── Status filter tabs: Pending, Completed, All ──
  Widget _buildStatusFilterTabs(ApprovalsController controller) {
    final tabs = [
      (ApprovalStatusFilter.pending, 'Pending'),
      (ApprovalStatusFilter.completed, 'Completed'),
      (ApprovalStatusFilter.all, 'All'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() => Row(
        children: tabs.map((tab) {
          final selected = controller.selectedStatusFilter.value == tab.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () => controller.setStatusFilter(tab.$1),
              child: Text(
                tab.$2,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: selected ? AppColors.textDark : AppColors.textGrey,
                ),
              ),
            ),
          );
        }).toList(),
      )),
    );
  }

  // ── Approval cards list ──
  Widget _buildApprovalList(ApprovalsController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final results = controller.filteredStudents;
        if (results.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text('No students match this filter', style: TextStyle(color: AppColors.textGrey)),
            ),
          );
        }
        return Column(children: results.map((s) => _approvalCard(controller, s, context)).toList());
      }),
    );
  }

  Widget _approvalCard(ApprovalsController controller, StudentRecord student, BuildContext context) {
    final flag = AcademicConstants.countryFlags[student.countryName] ?? '🌍';
    final done = ApprovalsController.adminStepsDone(student);
    final total = ApprovalsController.adminStepsCount;
    final currentMeta = ApprovalsController.metaFor(student.currentStep);

    final isReview = student.status == StudentStatus.active || student.status == StudentStatus.pending;
    final badgeLabel = isReview ? 'In Review' : student.status.label;
    final badgeColor = isReview ? AppColors.primaryBlue : student.status.color;

    return Container(
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: badgeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  badgeLabel,
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: badgeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Admin steps done', style: TextStyle(fontSize: 11.5, color: AppColors.textGrey)),
              Text(
                '$done/$total',
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _segmentedProgressBar(student),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: currentMeta.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: currentMeta.color.withOpacity(0.18), shape: BoxShape.circle),
                  child: Icon(currentMeta.icon, size: 16, color: currentMeta.color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step ${student.currentStep} · Awaiting Action',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: currentMeta.color),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        currentMeta.title,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textDark),
                      ),
                    ],
                  ),
                ),
                Container(width: 8, height: 8, decoration: BoxDecoration(color: currentMeta.color, shape: BoxShape.circle)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (student.currentStep == 4) {
                        Get.to(() => const Step4Screen(), arguments: student);
                      } else if (student.currentStep == 5) {
                        Get.to(() => const Step5Screen(), arguments: student);
                      } else if (student.currentStep == 6) {
                        Get.to(() => const Step6Screen(), arguments: student);
                      } else if (student.currentStep == 7) {
                        Get.to(() => const Step7Screen(), arguments: student);
                      } else {
                        _confirmProcessStep(context, student, currentMeta);
                      }
                    },
                    icon: const Icon(Icons.task_alt_rounded, size: 16),
                    label: Text('Process Step ${student.currentStep}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentMeta.color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => Get.toNamed(AppRoute.studentProfile, arguments: student),
                icon: const Icon(Icons.person_outline, size: 16, color: AppColors.textGrey),
                label: const Text('Profile', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textGrey)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _segmentedProgressBar(StudentRecord student) {
    final baseColor = ApprovalsController.metaFor(student.currentStep).color;
    final activeColor = Color.lerp(baseColor, Colors.black, 0.28) ?? baseColor;

    return Row(
      children: List.generate(ApprovalsController.adminStepsCount, (index) {
        final stepId = ApprovalsController.adminStepsStart + index;
        Color color;
        if (stepId < student.currentStep) {
          color = baseColor;
        } else if (stepId == student.currentStep) {
          color = activeColor;
        } else {
          color = AppColors.borderGrey;
        }
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: index == ApprovalsController.adminStepsCount - 1 ? 0 : 3),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          ),
        );
      }),
    );
  }

  void _confirmProcessStep(BuildContext context, StudentRecord student, AdminStepMeta meta) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Process Step ${student.currentStep}'),
        content: Text('Mark "${meta.title}" as complete for ${student.name}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel', style: TextStyle(color: AppColors.textGrey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: meta.color, foregroundColor: Colors.white),
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Step Processed',
                '${student.name}\'s "${meta.title}" step marked complete (not persisted yet).',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: meta.color,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}