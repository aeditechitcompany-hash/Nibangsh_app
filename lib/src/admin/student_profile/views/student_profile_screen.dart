import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/models/required_document.dart';
import '../../../../common/util/academic_constants.dart';
import '../../../../common/util/app_colors.dart';
import '../../model/students_record.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final student = Get.arguments as StudentRecord;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(student),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.only(top: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(student),
                  const SizedBox(height: 20),
                  _buildStudentInfoCard(student),
                  const SizedBox(height: 20),
                  _buildProgressCard(student),
                  const SizedBox(height: 20),
                  _buildDocumentsCard(student, context),
                  const SizedBox(height: 20),
                  _buildVisaFlightRow(student),
                  const SizedBox(height: 20),
                  _buildAdminActionsCard(context, student),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(StudentRecord student) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.darkBlue,
            AppColors.darkBlue,
            AppColors.primaryRed,
          ],
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
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Student Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  student.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      student.email,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: student.status.color.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: student.status.color.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            student.status.label,
                            style: TextStyle(
                              color: student.status.color,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Joined ${student.joinedDate}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Stats row ──
  Widget _buildStatsRow(StudentRecord student) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _statCard(student.gpa, 'GPA')),
          const SizedBox(width: 10),
          Expanded(child: _statCard(student.passoutYear, 'Year')),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              student.languageTestScore,
              student.languageTestName,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  // ── Student Information card ──
  Widget _buildStudentInfoCard(StudentRecord student) {
    final flag = AcademicConstants.countryFlags[student.countryName] ?? '🌍';

    final rows = [
      {
        'icon': Icons.person_outline,
        'label': 'Full Name',
        'value': student.name,
      },
      {
        'icon': Icons.mail_outline_rounded,
        'label': 'Email',
        'value': student.email,
      },
      {'icon': Icons.call_outlined, 'label': 'Phone', 'value': student.phone},
      {
        'icon': Icons.menu_book_outlined,
        'label': 'Course',
        'value': student.course,
      },
      {
        'icon': Icons.account_balance_outlined,
        'label': 'University',
        'value': student.university,
      },
      {
        'icon': Icons.public_outlined,
        'label': 'Destination',
        'value': '$flag ${student.countryName}',
      },
    ];

    return _sectionCard(
      title: 'Student Information',
      child: Column(
        children: List.generate(rows.length, (index) {
          final row = rows[index];
          final isLast = index == rows.length - 1;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(color: AppColors.borderGrey, width: 1),
                    ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    row['icon'] as IconData,
                    size: 16,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row['label'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        row['value'] as String,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── Application progress card ──
  Widget _buildProgressCard(StudentRecord student) {
    final total = StudentRecord.totalSteps;
    return _sectionCard(
      title: 'Application Progress',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            'Step ${student.currentStep} of $total — ${student.currentStepTitle}',
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Documents card ──
  Widget _buildDocumentsCard(StudentRecord student, BuildContext context) {
    final docs = RequiredDocumentsCatalog.seed;
    final fraction = student.documentsUploaded / student.documentsTotal;

    return _sectionCard(
      title: 'Documents',
      trailing: Text(
        '${student.documentsUploaded}/${student.documentsTotal}',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 14),
          ...List.generate(docs.length, (index) {
            final doc = docs[index];
            final uploaded = index < student.documentsUploaded;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Icon(
                    doc.icon,
                    size: 16,
                    color: uploaded
                        ? const Color(0xFF16A34A)
                        : AppColors.textGrey,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      doc.title,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  if (uploaded) ...[
                    const Text(
                      'Uploaded',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => Get.snackbar(
                        'Preview',
                        '${doc.title} preview isn\'t wired up yet.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.primaryRed,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye_outlined,
                            size: 13,
                            color: Color(0xFF16A34A),
                          ),
                          SizedBox(width: 2),
                          Text(
                            'View',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF16A34A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else
                    const Text(
                      'Missing',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Visa Status + Flight mini cards ──
  Widget _buildVisaFlightRow(StudentRecord student) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _miniStatusCard(
              icon: Icons.shield_outlined,
              iconColor: AppColors.primaryBlue,
              title: 'Visa Status',
              value: student.visaStatus,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _miniStatusCard(
              icon: Icons.flight_takeoff_outlined,
              iconColor: const Color(0xFFF59E0B),
              title: 'Flight',
              value: student.flightStatus,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStatusCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Admin actions ──
  Widget _buildAdminActionsCard(BuildContext context, StudentRecord student) {
    return _sectionCard(
      title: 'Admin Actions',
      child: Column(
        children: [
          _adminActionButton(
            label: 'Approve Student',
            icon: Icons.person_add_alt_1_rounded,
            color: const Color(0xFF16A34A),
            onTap: () => _confirmAction(
              context,
              title: 'Approve Student',
              message: 'Approve ${student.name}\'s application?',
              confirmLabel: 'Approve',
              confirmColor: const Color(0xFF16A34A),
              onConfirm: () => Get.snackbar(
                'Approved',
                '${student.name} marked as approved (not persisted yet).',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF16A34A),
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _adminActionButton(
            label: 'Reject Application',
            icon: Icons.person_remove_alt_1_rounded,
            color: AppColors.errorColor,
            onTap: () => _confirmAction(
              context,
              title: 'Reject Application',
              message: 'Reject ${student.name}\'s application?',
              confirmLabel: 'Reject',
              confirmColor: AppColors.errorColor,
              onConfirm: () => Get.snackbar(
                'Rejected',
                '${student.name}\'s application marked as rejected (not persisted yet).',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.errorColor,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _adminActionButton(
            label: 'Export Profile PDF',
            icon: Icons.picture_as_pdf_outlined,
            color: AppColors.textGrey,
            filled: false,
            onTap: () => Get.snackbar(
              'Export Profile PDF',
              'PDF export isn\'t wired up yet — add the `pdf`/`printing` package to generate one.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.primaryRed,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _adminActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool filled = true,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: filled
          ? ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18),
              label: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            )
          : ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18, color: Colors.black),
              label: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.white,
                side: BorderSide(
                  color: AppColors.textGrey.withOpacity(0.3),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
    );
  }

  void _confirmAction(
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

  Widget _sectionCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
