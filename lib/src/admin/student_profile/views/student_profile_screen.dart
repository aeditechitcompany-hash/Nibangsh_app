import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/models/required_document.dart';
import '../../../../common/util/academic_constants.dart';
import '../../../../common/util/app_colors.dart';
import '../../students/model/students_record.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  static const _journeySteps = [
    'Document Submission',
    'Language Test',
    'Application Review',
    'Interview',
    'Offer Letter',
    'Visa Processing',
    'Final Approval',
  ];

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
            Transform.translate(
              offset: const Offset(0, -22),
              child: Container(
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
                    _buildAcademicCard(student),
                    const SizedBox(height: 20),
                    _buildProgressCard(student),
                    const SizedBox(height: 20),
                    _buildDocumentsCard(student),
                    const SizedBox(height: 24),
                    _buildActionButtons(context),
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
  Widget _buildHeader(StudentRecord student) {
    final navyDark = Color.lerp(AppColors.primaryBlue, Colors.black, 0.62)!;
    final navyLight = Color.lerp(AppColors.primaryBlue, Colors.black, 0.35)!;
    final flag = AcademicConstants.countryFlags[student.countryName] ?? '🌍';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
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
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.14), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: student.status.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: student.status.color.withOpacity(0.5)),
                ),
                child: Text(
                  student.status.label,
                  style: TextStyle(color: student.status.color, fontSize: 11.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: Column(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    student.initials,
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  student.name,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  student.email,
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  '$flag ${student.countryName}',
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Academic details card ──
  Widget _buildAcademicCard(StudentRecord student) {
    return _sectionCard(
      title: 'Academic Details',
      child: Column(
        children: [
          _infoRow('GPA', student.gpa),
          _infoRow('Interested Degree', student.degree),
          _infoRow('Pass-out Year', student.passoutYear, isLast: true),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.borderGrey, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.primaryBlue)),
          Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ],
      ),
    );
  }

  // ── Application progress card ──
  Widget _buildProgressCard(StudentRecord student) {
    return _sectionCard(
      title: 'Application Progress',
      trailing: Text(
        'Step ${student.currentStep}/${student.totalSteps}',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
      ),
      child: Column(
        children: List.generate(_journeySteps.length, (index) {
          final stepNumber = index + 1;
          final done = stepNumber < student.currentStep;
          final active = stepNumber == student.currentStep;
          final color = done
              ? const Color(0xFF16A34A)
              : active
              ? AppColors.primaryBlue
              : AppColors.textGrey;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                  child: done
                      ? Icon(Icons.check, size: 14, color: color)
                      : Text('$stepNumber', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _journeySteps[index],
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: active ? FontWeight.bold : FontWeight.w500,
                      color: active || done ? AppColors.textDark : AppColors.textGrey,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── Documents card ──
  Widget _buildDocumentsCard(StudentRecord student) {
    final docs = RequiredDocumentsCatalog.seed;

    return _sectionCard(
      title: 'Documents',
      trailing: Text(
        '${student.documentsUploaded}/${student.documentsTotal}',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
      ),
      child: Column(
        children: List.generate(docs.length, (index) {
          final doc = docs[index];
          final uploaded = index < student.documentsUploaded;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: (uploaded ? const Color(0xFF16A34A) : AppColors.textGrey).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    doc.icon,
                    size: 15,
                    color: uploaded ? const Color(0xFF16A34A) : AppColors.textGrey,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    doc.title,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  ),
                ),
                Icon(
                  uploaded ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 16,
                  color: uploaded ? const Color(0xFF16A34A) : AppColors.borderGrey,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child, Widget? trailing}) {
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
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: AppColors.textDark)),
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

  // ── Action buttons ──
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () => Get.snackbar(
            'Message',
            'Messaging isn\'t wired up yet.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.primaryBlue,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          ),
          icon: const Icon(Icons.send_outlined, size: 18),
          label: const Text('Message Student', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}