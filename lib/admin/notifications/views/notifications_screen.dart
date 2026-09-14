import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/util/app_colors.dart';
import '../../../../common/util/responsive.dart';

import '../../model/students_record.dart';
import '../../overview/controller/overview_controller.dart';

import '../controller/notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      NotificationsController(),
    );

    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(controller),

            ResponsiveDashboardWrapper(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPublishCard(controller),
                    const SizedBox(height: 24),
                    _buildActivitySection(controller),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader(
      NotificationsController controller,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        30,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.navyDark,
            AppColors.navyLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: const Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),

          Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 5),

          Text(
            'Send updates and announcements to students',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.5,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PUBLISH CARD
  // =========================================================

  Widget _buildPublishCard(
      NotificationsController controller,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.borderGrey,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              'Publish Notification',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Send a notification to one or more students.',
              style: TextStyle(
                fontSize: 13.5,
                color: AppColors.textGrey,
              ),
            ),

            const SizedBox(height: 20),

            _buildRecipientSelector(controller),

            const SizedBox(height: 18),

            Obx(
                  () => controller.sendToAllStudents.value
                  ? _buildAllStudentsRecipient()
                  : _buildStudentSelector(controller),
            ),

            const SizedBox(height: 20),

            _buildTitleField(controller),

            const SizedBox(height: 16),

            _buildMessageField(controller),

            const SizedBox(height: 16),

            _buildNotificationType(controller),

            const SizedBox(height: 22),

            _buildPublishButton(controller),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // RECIPIENT MODE
  // =========================================================

  Widget _buildRecipientSelector(
      NotificationsController controller,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Recipients',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),

        const SizedBox(height: 10),

        Obx(
              () => Row(
            children: [
              Expanded(
                child: _recipientOption(
                  title: 'All Students',
                  subtitle: 'Send to everyone',
                  icon: Icons.groups_outlined,
                  selected:
                  controller.sendToAllStudents.value,
                  onTap:
                  controller.selectAllStudents,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _recipientOption(
                  title: 'Select Students',
                  subtitle: 'Choose one or more',
                  icon:
                  Icons.person_search_outlined,
                  selected:
                  !controller.sendToAllStudents.value,
                  onTap:
                  controller.selectSpecificStudents,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _recipientOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryBlue
              .withOpacity(0.08)
              : Colors.white,
          borderRadius:
          BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.primaryBlue
                : AppColors.borderGrey,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primaryBlue
                    .withOpacity(0.12)
                    : AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 19,
                color: selected
                    ? AppColors.primaryBlue
                    : AppColors.textGrey,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? AppColors.primaryBlue
                          : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),

            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: AppColors.primaryBlue,
              ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // ALL STUDENTS
  // =========================================================

  Widget _buildAllStudentsRecipient() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue
            .withOpacity(0.06),
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryBlue
              .withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue
                  .withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: AppColors.primaryBlue,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'All Students',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Every active student will receive this notification.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.check_circle,
            color: AppColors.primaryBlue,
            size: 20,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // STUDENT SELECTOR
  // =========================================================

  Widget _buildStudentSelector(
      NotificationsController controller,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.borderGrey,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Select Students',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),

              Obx(
                    () => Text(
                  '${controller.selectedStudentCount} selected',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Search
          TextField(
            controller:
            controller.studentSearchController,
            decoration: InputDecoration(
              hintText: 'Search students...',
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Select all / clear
          Obx(
                () => Row(
              children: [
                TextButton(
                  onPressed: controller
                      .allVisibleStudentsSelected
                      ? controller
                      .deselectAllVisibleStudents
                      : controller
                      .selectAllVisibleStudents,
                  child: Text(
                    controller
                        .allVisibleStudentsSelected
                        ? 'Deselect Visible'
                        : 'Select Visible',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Spacer(),

                if (controller.selectedStudentCount >
                    0)
                  TextButton(
                    onPressed: controller
                        .clearSelectedStudents,
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        fontSize: 12.5,
                        color:
                        AppColors.errorColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Obx(
                () {
              if (controller.studentsController
                  .isLoading.value) {
                return const Padding(
                  padding:
                  EdgeInsets.all(24),
                  child: Center(
                    child:
                    CircularProgressIndicator(),
                  ),
                );
              }

              final students =
                  controller.filteredStudents;

              if (students.isEmpty) {
                return const Padding(
                  padding:
                  EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'No students found.',
                      style: TextStyle(
                        color:
                        AppColors.textGrey,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: students
                    .map(
                      (student) =>
                      _studentSelectionTile(
                        controller,
                        student,
                      ),
                )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _studentSelectionTile(
      NotificationsController controller,
      StudentRecord student,
      ) {
    return Obx(
          () {
        final selected =
        controller.isStudentSelected(
          student.id,
        );

        return GestureDetector(
          onTap: () => controller
              .toggleStudent(student),
          child: Container(
            margin:
            const EdgeInsets.only(
              bottom: 6,
            ),
            padding:
            const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryBlue
                  .withOpacity(0.06)
                  : Colors.white,
              borderRadius:
              BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? AppColors.primaryBlue
                    : AppColors.borderGrey,
              ),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: selected,
                  activeColor:
                  AppColors.primaryBlue,
                  onChanged: (_) =>
                      controller
                          .toggleStudent(
                        student,
                      ),
                ),

                Container(
                  width: 38,
                  height: 38,
                  alignment:
                  Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors
                        .primaryBlue
                        .withOpacity(0.1),
                    borderRadius:
                    BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Text(
                    student.initials,
                    style:
                    const TextStyle(
                      fontSize: 13,
                      fontWeight:
                      FontWeight.bold,
                      color: AppColors
                          .primaryBlue,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        student.name,
                        maxLines: 1,
                        overflow:
                        TextOverflow
                            .ellipsis,
                        style:
                        const TextStyle(
                          fontSize: 13.5,
                          fontWeight:
                          FontWeight.w700,
                          color: AppColors
                              .textDark,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        student.email,
                        maxLines: 1,
                        overflow:
                        TextOverflow
                            .ellipsis,
                        style:
                        const TextStyle(
                          fontSize: 11.5,
                          color: AppColors
                              .textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // TITLE
  // =========================================================

  Widget _buildTitleField(
      NotificationsController controller,
      ) {
    return _fieldLabel(
      label: 'Title',
      child: TextField(
        controller:
        controller.titleController,
        textInputAction:
        TextInputAction.next,
        decoration: _inputDecoration(
          hint: 'Enter notification title',
        ),
      ),
    );
  }

  // =========================================================
  // MESSAGE
  // =========================================================

  Widget _buildMessageField(
      NotificationsController controller,
      ) {
    return _fieldLabel(
      label: 'Message',
      child: TextField(
        controller:
        controller.messageController,
        maxLines: 5,
        minLines: 4,
        decoration: _inputDecoration(
          hint: 'Write your notification message...',
        ),
      ),
    );
  }

  // =========================================================
  // TYPE
  // =========================================================

  Widget _buildNotificationType(
      NotificationsController controller,
      ) {
    return _fieldLabel(
      label: 'Notification Type',
      child: Obx(
            () => DropdownButtonFormField<String>(
          value:
          controller.selectedType.value,
          decoration: _inputDecoration(
            hint: 'Select notification type',
          ),
          items: const [
            DropdownMenuItem(
              value: 'info',
              child: Text('Info'),
            ),
            DropdownMenuItem(
              value: 'success',
              child: Text('Success'),
            ),
            DropdownMenuItem(
              value: 'warning',
              child: Text('Warning'),
            ),
            DropdownMenuItem(
              value: 'alert',
              child: Text('Alert'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              controller
                  .setNotificationType(
                value,
              );
            }
          },
        ),
      ),
    );
  }

  // =========================================================
  // PUBLISH BUTTON
  // =========================================================

  Widget _buildPublishButton(
      NotificationsController controller,
      ) {
    return Obx(
          () => SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed:
          controller.isPublishing.value
              ? null
              : controller
              .publishNotification,
          style:
          ElevatedButton.styleFrom(
            backgroundColor:
            AppColors.primaryBlue,
            foregroundColor: Colors.white,
            disabledBackgroundColor:
            AppColors.primaryBlue
                .withOpacity(0.5),
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),
          ),
          icon: controller
              .isPublishing.value
              ? const SizedBox(
            width: 18,
            height: 18,
            child:
            CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Icon(
            Icons.send_rounded,
            size: 18,
          ),
          label: Text(
            controller.isPublishing.value
                ? 'Publishing...'
                : 'Publish Notification',
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // ACTIVITY / HISTORY
  // =========================================================

  Widget _buildActivitySection(
      NotificationsController controller,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    AppColors.textDark,
                  ),
                ),
              ),

              Text(
                '${controller.activities.length} items',
                style: const TextStyle(
                  fontSize: 12.5,
                  color:
                  AppColors.textGrey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ...controller.activities.map(
                (activity) =>
                _activityTile(activity),
          ),
        ],
      ),
    );
  }

  Widget _activityTile(
      RecentActivity activity,
      ) {
    late IconData icon;
    late Color color;

    switch (activity.status) {
      case ActivityStatus.approved:
        icon = Icons.check_rounded;
        color = const Color(0xFF16A34A);
        break;

      case ActivityStatus.inProgress:
        icon =
            Icons.show_chart_rounded;
        color =
            AppColors.primaryBlue;
        break;

      case ActivityStatus.rejected:
        icon = Icons.close_rounded;
        color =
            AppColors.errorColor;
        break;
    }

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
      const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color:
          AppColors.borderGrey,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration:
            BoxDecoration(
              color:
              color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 17,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  activity.name,
                  style:
                  const TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    AppColors.textDark,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  activity.action,
                  style:
                  const TextStyle(
                    fontSize: 13,
                    color:
                    AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),

          Text(
            activity.time,
            style:
            const TextStyle(
              fontSize: 12,
              color:
              AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // COMMON FIELD HELPERS
  // =========================================================

  Widget _fieldLabel({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),

        const SizedBox(height: 8),

        child,
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.textGrey,
        fontSize: 13.5,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.borderGrey,
        ),
      ),
      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.borderGrey,
        ),
      ),
      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primaryBlue,
          width: 1.5,
        ),
      ),
    );
  }
}