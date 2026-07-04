import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/util/academic_constants.dart';
import '../../../../common/util/app_colors.dart';
import '../../../../common/util/app_route.dart';
import '../../students/model/students_record.dart';
import '../controller/applications_controller.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApplicationsController(), permanent: true);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(controller, context),
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
                _buildFilterChips(controller),
                const SizedBox(height: 16),
                _buildApplicationsList(controller, context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(ApplicationsController controller, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                    () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Applications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.countFor(StudentStatus.pending)} awaiting review',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoute.notifications),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Obx(
                () => Row(
              children: [
                Expanded(
                  child: _topPill('${controller.totalCount}', 'Total'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _topPill(
                    '${controller.countFor(StudentStatus.pending)}',
                    'Pending',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _topPill(
                    '${controller.countFor(StudentStatus.approved)}',
                    'Approved',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _topPill(
                    '${controller.countFor(StudentStatus.rejected)}',
                    'Rejected',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topPill(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 10.5),
          ),
        ],
      ),
    );
  }

  // ── Status filter chips ──
  Widget _buildFilterChips(ApplicationsController controller) {
    final chips = <StudentStatus?>[null, ...StudentStatus.values];

    return SizedBox(
      height: 38,
      child: Obx(() {
        // Read the observable synchronously here (inside Obx's tracked
        // scope) rather than inside itemBuilder, which runs lazily
        // outside that scope and wouldn't register as a dependency.
        final currentStatus = controller.selectedStatus.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: chips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final status = chips[index];
            final label = status == null ? 'All' : status.label;
            final selected = currentStatus == status;
            return GestureDetector(
              onTap: () => controller.setStatusFilter(status),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryBlue : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? AppColors.primaryBlue : AppColors.borderGrey,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textGrey,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // ── Applications list ──
  Widget _buildApplicationsList(ApplicationsController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final results = controller.filteredApplications;
        if (results.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'No applications match this filter',
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
          );
        }
        return Column(
          children: results
              .map((application) => _applicationCard(controller, application, context))
              .toList(),
        );
      }),
    );
  }

  Widget _applicationCard(
      ApplicationsController controller,
      StudentRecord application,
      BuildContext context,
      ) {
    final flag = AcademicConstants.countryFlags[application.countryName] ?? '🌍';
    final fraction = application.currentStep / application.totalSteps;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
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
                  application.initials,
                  style: const TextStyle(
                    fontSize: 14,
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
                      application.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${application.degree} • $flag ${application.countryName}',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: application.status.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  application.status.label,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: application.status.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${application.currentStep} of ${application.totalSteps}',
                style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey),
              ),
              Text(
                '${(fraction * 100).round()}%',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  Container(height: 6, color: AppColors.borderGrey),
                  Container(
                    height: 6,
                    width: constraints.maxWidth * fraction,
                    color: AppColors.primaryBlue,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderGrey),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () =>
                      Get.toNamed(AppRoute.studentProfile, arguments: application),
                  icon: const Icon(Icons.visibility_outlined, size: 16, color: AppColors.primaryBlue),
                  label: const Text(
                    'View',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
              if (application.status == StudentStatus.pending) ...[
                Container(width: 1, height: 20, color: AppColors.borderGrey),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _confirmDecision(
                      context,
                      title: 'Reject Application',
                      message: "Reject ${application.name}'s application?",
                      confirmLabel: 'Reject',
                      confirmColor: AppColors.errorColor,
                      onConfirm: () => controller.reject(application.id),
                    ),
                    icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.errorColor),
                    label: const Text(
                      'Reject',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.errorColor,
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 20, color: AppColors.borderGrey),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _confirmDecision(
                      context,
                      title: 'Approve Application',
                      message: "Approve ${application.name}'s application?",
                      confirmLabel: 'Approve',
                      confirmColor: const Color(0xFF16A34A),
                      onConfirm: () => controller.approve(application.id),
                    ),
                    icon: const Icon(Icons.check_rounded, size: 16, color: Color(0xFF16A34A)),
                    label: const Text(
                      'Approve',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDecision(
      BuildContext context, {
        required String title,
        required String message,
        required String confirmLabel,
        required Color confirmColor,
        required VoidCallback onConfirm,
      }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }
}