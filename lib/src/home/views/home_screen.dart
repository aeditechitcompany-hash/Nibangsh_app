import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/models/application_step_model.dart';
import '../../../common/util/academic_constants.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../../main_navigation/controller/main_navigation_controller.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
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
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildProfileCard(controller),
                    const SizedBox(height: 26),
                    _buildStepsSection(controller, context),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Header
  Widget _buildHeader(HomeController controller) {
    final darkBlue = Color.lerp(AppColors.primaryBlue, Colors.black, 0.45)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkBlue, AppColors.primaryBlue, AppColors.primaryRed],
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
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  controller.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${controller.greeting},',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12.5,
                      ),
                    ),
                    Obx(
                          () => Text(
                        '${controller.userName.value} 👋',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoute.studentNotifications),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          shape: BoxShape.circle,
                          border: Border.all(color: darkBlue, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Obx(() {
              final country = controller.country.value;
              final flag = AcademicConstants.countryFlags[country] ?? '🌍';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Application Progress',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12.5,
                        ),
                      ),
                      Text(
                        '${controller.progressPercent.value}% Complete',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final fillWidth =
                            constraints.maxWidth *
                                (controller.progressPercent.value / 100);
                        return Stack(
                          children: [
                            Container(
                              height: 8,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              height: 8,
                              width: fillWidth,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.amber.shade400,
                                    AppColors.primaryRed,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        country.isEmpty
                            ? 'Destination not set'
                            : '$flag $country',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'GPA: ${controller.gpa.value.isEmpty ? '--' : controller.gpa.value}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // Quick actions row
  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Countries',
        'icon': Icons.public_outlined,
        'color': AppColors.primaryBlue,
        'targetIndex': 1,
      },
      {
        'title': 'Apply',
        'icon': Icons.description_outlined,
        'color': AppColors.primaryRed,
        'targetIndex': 2,
      },
      {
        'title': 'Visa',
        'icon': Icons.shield_outlined,
        'color': const Color(0xFF16A34A),
      },
      {
        'title': 'Flight',
        'icon': Icons.flight_takeoff_outlined,
        'color': const Color(0xFFF59E0B),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: actions.map((action) {
              final color = action['color'] as Color;
              final targetIndex = action['targetIndex'] as int?;
              return GestureDetector(
                onTap: targetIndex == null
                    ? null
                    : () {
                  if (Get.isRegistered<MainNavigationController>()) {
                    Get.find<MainNavigationController>().setIndex(targetIndex);
                  }
                },
                child: Column(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        action['icon'] as IconData,
                        color: color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action['title'] as String,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // My Profile card
  Widget _buildProfileCard(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(
                    AppRoute.academicDetails,
                    arguments: {
                      'isEdit': true,
                      'country': controller.country.value,
                      'gpa': controller.gpa.value,
                      'passoutYear': controller.passoutYear.value,
                      'degree': controller.degree.value,
                    },
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: AppColors.primaryBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Obx(
                  () => Row(
                children: [
                  Expanded(
                    child: _profileField(
                      'GPA',
                      controller.gpa.value.isEmpty
                          ? '--'
                          : controller.gpa.value,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _profileField(
                      'Pass-out Year',
                      controller.passoutYear.value.isEmpty
                          ? '--'
                          : controller.passoutYear.value,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Obx(
                  () => Row(
                children: [
                  Expanded(
                    child: _profileField(
                      'Interested Course',
                      controller.degree.value.isEmpty
                          ? '--'
                          : controller.degree.value,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _profileField(
                      'Destination',
                      controller.country.value.isEmpty
                          ? '--'
                          : controller.country.value,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileField(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Application Steps section
  Widget _buildStepsSection(HomeController controller, BuildContext context) {
    final userSteps = controller.userSteps;
    final adminSteps = controller.adminSteps;
    final userDone = controller.userStepsDoneCount;
    final adminDone = controller.adminStepsDoneCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  value: '$userDone/${userSteps.length}',
                  label: 'Your Tasks Done',
                  color: const Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  value: '$adminDone/${adminSteps.length}',
                  label: 'Admin Steps Done',
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _sectionHeader(
            icon: Icons.person_outline_rounded,
            iconColor: const Color(0xFF16A34A),
            title: 'Your Steps (1–3)',
            doneLabel: '$userDone/${userSteps.length} done',
            doneColor: const Color(0xFF16A34A),
          ),
          const SizedBox(height: 12),
          ...userSteps.map((step) => _stepTile(controller, step, context)),
          const SizedBox(height: 10),
          _sectionHeader(
            icon: Icons.shield_outlined,
            iconColor: AppColors.primaryBlue,
            title: 'Admin Approval Steps (4–10)',
            doneLabel: '$adminDone/${adminSteps.length}',
            doneColor: AppColors.primaryBlue,
          ),
          const SizedBox(height: 12),
          ...adminSteps.map((step) => _stepTile(controller, step, context)),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String doneLabel,
    required Color doneColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        Text(
          doneLabel,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: doneColor,
          ),
        ),
      ],
    );
  }

  Widget _stepTile(
      HomeController controller,
      ApplicationStepModel step,
      BuildContext context,
      ) {
    Color color;
    String pillLabel;
    IconData pillIcon;

    if (step.status == StepStatus.done) {
      color = const Color(0xFF16A34A);
      pillLabel = 'Done';
      pillIcon = Icons.check;
    } else if (step.owner == StepOwner.admin) {
      color = AppColors.primaryBlue;
      pillLabel = 'Admin';
      pillIcon = Icons.schedule_rounded;
    } else if (step.status == StepStatus.active) {
      color = AppColors.primaryBlue;
      pillLabel = 'Active';
      pillIcon = Icons.arrow_forward_rounded;
    } else {
      color = AppColors.textGrey;
      pillLabel = 'Pending';
      pillIcon = Icons.hourglass_empty_rounded;
    }

    final isTappable =
        step.owner == StepOwner.user && step.status == StepStatus.active;

    return GestureDetector(
      onTap: isTappable
          ? () => _handleStepTap(controller, step, context)
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: step.status == StepStatus.done
                  ? Icon(Icons.check_rounded, color: color, size: 20)
                  : Icon(step.icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step ${step.id}',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (step.status == StepStatus.done) ...[
                    Icon(pillIcon, size: 11, color: color),
                    const SizedBox(width: 3),
                  ],
                  Text(
                    pillLabel,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStepTap(
      HomeController controller,
      ApplicationStepModel step,
      BuildContext context,
      ) {
    if (step.id == 2) {
      _showLanguageTestSheet(controller, context);
      return;
    }

    final actionLabel = step.id == 1
        ? 'marksheet / transcript'
        : 'all required documents';
    _showStepUploadOptions(controller, step.id, actionLabel, context);
  }

  void _showStepUploadOptions(
      HomeController controller,
      int stepId,
      String actionLabel,
      BuildContext context,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: AppColors.borderGrey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Text(
                  'Upload $actionLabel',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _stepUploadOptionTile(
                  icon: Icons.camera_alt_rounded,
                  label: 'Take a Photo',
                  onTap: () {
                    Get.back();
                    controller.pickStepPhoto(stepId, ImageSource.camera);
                  },
                ),
                const SizedBox(height: 10),
                _stepUploadOptionTile(
                  icon: Icons.photo_library_rounded,
                  label: 'Choose from Gallery',
                  onTap: () {
                    Get.back();
                    controller.pickStepPhoto(stepId, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _stepUploadOptionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryBlue, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageTestSheet(HomeController controller, BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Language Test',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 14),
                ...AcademicConstants.languageTests.map(
                      (test) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.menu_book_outlined,
                      color: AppColors.primaryBlue,
                    ),
                    title: Text(
                      test,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Get.back();
                      controller.selectLanguageTest(test);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}