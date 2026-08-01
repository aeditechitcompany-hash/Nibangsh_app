import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/util/academic_constants.dart';
import '../../../common/util/app_colors.dart';
import '../../model/students_record.dart';
import '../../students/controller/students_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

// Country name -> code, matching the codes already used across the app
// (StudentRecord.countryCode, DestinationStat.code, etc).
const Map<String, String> _countryCodes = {
  'South Korea': 'KR',
  'United States': 'US',
  'United Kingdom': 'GB',
  'Canada': 'CA',
  'Australia': 'AU',
  'Japan': 'JP',
};

void showEditStudentSheet(
    BuildContext context,
    StudentsController controller,
    StudentRecord student,
    ) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return _EditStudentSheet(controller: controller, student: student);
    },
  );
}

class _EditStudentSheet extends StatefulWidget {
  final StudentsController controller;
  final StudentRecord student;

  const _EditStudentSheet({required this.controller, required this.student});

  @override
  State<_EditStudentSheet> createState() => _EditStudentSheetState();
}

class _EditStudentSheetState extends State<_EditStudentSheet> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _university;
  late final TextEditingController _course;
  late final TextEditingController _gpa;
  late final TextEditingController _languageScore;
  late final TextEditingController _visaStatus;
  late final TextEditingController _flightStatus;

  late String _countryName;
  late String _degree;
  late String _passoutYear;
  late String _languageTestName;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    _name = TextEditingController(text: s.name);
    _email = TextEditingController(text: s.email);
    _phone = TextEditingController(text: s.phone);
    _university = TextEditingController(text: s.university);
    _course = TextEditingController(text: s.course);
    _gpa = TextEditingController(text: s.gpa);
    _languageScore = TextEditingController(text: s.languageTestScore);
    _visaStatus = TextEditingController(text: s.visaStatus);
    _flightStatus = TextEditingController(text: s.flightStatus);

    _countryName = AcademicConstants.countries.contains(s.countryName)
        ? s.countryName
        : AcademicConstants.countries.first;
    _degree = AcademicConstants.degrees.contains(s.degree)
        ? s.degree
        : AcademicConstants.degrees.first;
    _passoutYear = AcademicConstants.passoutYears.contains(s.passoutYear)
        ? s.passoutYear
        : AcademicConstants.passoutYears.first;
    _languageTestName =
    AcademicConstants.languageTests.contains(s.languageTestName)
        ? s.languageTestName
        : AcademicConstants.languageTests.first;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _university.dispose();
    _course.dispose();
    _gpa.dispose();
    _languageScore.dispose();
    _visaStatus.dispose();
    _flightStatus.dispose();
    super.dispose();
  }

  void _save() {
    if (_name.text.trim().isEmpty || _email.text.trim().isEmpty) {
      Get.snackbar(
        'Missing info',
        'Name and email are required.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    widget.controller.updateStudent(
      widget.student.id,
          (current) => current.copyWith(
        name: _name.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        university: _university.text.trim(),
        course: _course.text.trim(),
        gpa: _gpa.text.trim(),
        degree: _degree,
        passoutYear: _passoutYear,
        languageTestName: _languageTestName,
        languageTestScore: _languageScore.text.trim(),
        countryName: _countryName,
        countryCode: _countryCodes[_countryName] ?? current.countryCode,
        visaStatus: _visaStatus.text.trim(),
        flightStatus: _flightStatus.text.trim(),
      ),
    );

    Get.back();
    Get.snackbar(
      'Saved',
      'Student profile updated.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF16A34A),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: _decoration(label),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SingleChildScrollView(
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
                    const Text(
                      'Edit Student Profile',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _name,
                      decoration: _decoration('Full Name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(controller: _email, decoration: _decoration('Email')),
                    const SizedBox(height: 12),
                    TextField(controller: _phone, decoration: _decoration('Phone')),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _university,
                      decoration: _decoration('University'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _course,
                      decoration: _decoration('Course'),
                    ),
                    const SizedBox(height: 12),
                    _dropdown<String>(
                      label: 'Destination Country',
                      value: _countryName,
                      items: AcademicConstants.countries,
                      onChanged: (v) => setState(() => _countryName = v!),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _gpa,
                            decoration: _decoration('GPA'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _dropdown<String>(
                            label: 'Degree',
                            value: _degree,
                            items: AcademicConstants.degrees,
                            onChanged: (v) => setState(() => _degree = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _dropdown<String>(
                      label: 'Passout Year',
                      value: _passoutYear,
                      items: AcademicConstants.passoutYears,
                      onChanged: (v) => setState(() => _passoutYear = v!),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _dropdown<String>(
                            label: 'Language Test',
                            value: _languageTestName,
                            items: AcademicConstants.languageTests,
                            onChanged: (v) =>
                                setState(() => _languageTestName = v!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _languageScore,
                            decoration: _decoration('Score'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _visaStatus,
                      decoration: _decoration('Visa Status'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _flightStatus,
                      decoration: _decoration('Flight Status'),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
