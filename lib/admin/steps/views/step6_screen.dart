import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/util/academic_constants.dart';
import '../../../../common/util/app_colors.dart';
import '../../model/students_record.dart';
import '../controller/step6_controller.dart';

class Step6Screen extends StatelessWidget {
  const Step6Screen({super.key});

  static const Color stepColor = Color(0xFFDC2626); // red, matches Step 6 meta

  @override
  Widget build(BuildContext context) {
    final StudentRecord student = Get.arguments as StudentRecord;
    final controller = Get.put(Step6Controller(student), tag: student.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
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
                  _buildUploadBox(controller, student),
                  const SizedBox(height: 12),
                  _buildUploadedChip(controller),
                  const SizedBox(height: 20),
                  _sectionLabel('OFFER TYPE'),
                  const SizedBox(height: 8),
                  _buildOfferTypeRow(controller),
                  const SizedBox(height: 20),
                  _sectionLabel('OFFER EXPIRY DATE'),
                  const SizedBox(height: 8),
                  _buildDateField(context, controller),
                  const SizedBox(height: 24),
                  _buildSubmitButton(controller),
                ],
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
          colors: [Color(0xFF7F1D1D), Color(0xFFDC2626)],
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
                  'Step 6 of 10 · Admin Approval',
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
                child: const Icon(Icons.mail_outline_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Offer Letter', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text('Upload Offer Letter', style: TextStyle(color: Colors.white70, fontSize: 12)),
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

  // ── Dashed upload box ──
  Widget _buildUploadBox(Step6Controller controller, StudentRecord student) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
      decoration: BoxDecoration(
        color: stepColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stepColor.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Icon(Icons.mail_outline_rounded, color: stepColor, size: 26),
          const SizedBox(height: 10),
          Text(
            'Upload Offer Letter from\n${student.university}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.35),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: controller.browseForFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: stepColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text('Browse File', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── Green confirmation chip ──
  Widget _buildUploadedChip(Step6Controller controller) {
    return Obx(() {
      final fileName = controller.offerFileName.value;
      if (fileName == null) return const SizedBox.shrink();
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF16A34A).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF16A34A).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.description_outlined, size: 16, color: Color(0xFF16A34A)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                fileName,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF16A34A)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.check_circle, size: 18, color: Color(0xFF16A34A)),
          ],
        ),
      );
    });
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 0.4),
  );

  // ── Offer type toggle ──
  Widget _buildOfferTypeRow(Step6Controller controller) {
    const types = ['Conditional', 'Unconditional'];
    return Obx(() => Row(
      children: types.map((type) {
        final selected = controller.offerType.value == type;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: type == types.last ? 0 : 8),
            child: GestureDetector(
              onTap: () => controller.setOfferType(type),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryBlue.withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? AppColors.primaryBlue : AppColors.borderGrey,
                    width: selected ? 1.4 : 1,
                  ),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: selected ? AppColors.primaryBlue : AppColors.textGrey,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }

  // ── Expiry date field ──
  Widget _buildDateField(BuildContext context, Step6Controller controller) {
    return Obx(() {
      final hasDate = controller.offerExpiryDate.value != null;
      return GestureDetector(
        onTap: () => controller.pickExpiryDate(context),
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
                hasDate ? controller.formattedExpiryDate : 'mm/dd/yyyy',
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

  // ── Submit button ──
  Widget _buildSubmitButton(Step6Controller controller) {
    return Obx(() {
      final complete = controller.isComplete;
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: complete ? controller.submit : null,
          icon: Icon(Icons.mail_outline_rounded, color: complete ? Colors.white : AppColors.textGrey, size: 18),
          label: Text(
            'Confirm Offer Letter — Approve Step 6',
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