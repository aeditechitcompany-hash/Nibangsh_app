import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/util/academic_constants.dart';
import '../../../common/util/app_colors.dart';
import '../controller/academic_details_controller.dart';

class AcademicDetailsScreen extends StatelessWidget {
  const AcademicDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AcademicDetailsController());
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: controller.isEditMode,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                height: size.height * 0.26,
                padding: const EdgeInsets.only(top: 44),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.darkRed, AppColors.primaryRed, AppColors.primaryBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Stack(
                  children: [
                    if (controller.isEditMode)
                      Positioned(
                        left: 8,
                        top: 0,
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.school_outlined, color: Colors.white, size: 46),
                        const SizedBox(height: 12),
                        Text(
                          controller.isEditMode
                              ? 'Update Your Academic Details'
                              : 'Tell Us About Yourself',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            controller.isEditMode
                                ? 'Keep your profile accurate and up to date'
                                : 'A few quick details so we can personalize your journey',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Country / Destination
                      _buildLabel('Choose Country / Destination'),
                      const SizedBox(height: 8),
                      Obx(() => _buildDropdown(
                        value: controller.selectedCountry.value.isEmpty
                            ? null
                            : controller.selectedCountry.value,
                        hint: 'Select your preferred destination',
                        icon: Icons.public_outlined,
                        items: AcademicConstants.countries,
                        onChanged: controller.setCountry,
                        errorText: controller.showErrors.value &&
                            controller.selectedCountry.value.isEmpty
                            ? 'Please select a destination'
                            : null,
                      )),
                      const SizedBox(height: 18),

                      // GPA
                      _buildLabel('Enter your GPA'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.gpaController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: controller.validateGpa,
                        style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                        decoration: _fieldDecoration(
                          hint: 'e.g. 3.5 or 4.0',
                          icon: Icons.grade_outlined,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Passout Year
                      _buildLabel('Passout Year'),
                      const SizedBox(height: 8),
                      Obx(() => _buildDropdown(
                        value: controller.selectedPassoutYear.value.isEmpty
                            ? null
                            : controller.selectedPassoutYear.value,
                        hint: 'Select your passout year',
                        icon: Icons.calendar_today_outlined,
                        items: AcademicConstants.passoutYears,
                        onChanged: controller.setPassoutYear,
                        errorText: controller.showErrors.value &&
                            controller.selectedPassoutYear.value.isEmpty
                            ? 'Please select a year'
                            : null,
                      )),
                      const SizedBox(height: 18),

                      // Interested Degree
                      _buildLabel('Choose Interested Degree'),
                      const SizedBox(height: 8),
                      Obx(() => Row(
                        children: AcademicConstants.degrees.map((degree) {
                          final selected = controller.selectedDegree.value == degree;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => controller.setDegree(degree),
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: degree == AcademicConstants.degrees.last ? 0 : 10,
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.primaryRed
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.primaryRed
                                        : AppColors.borderGrey,
                                    width: 1.4,
                                  ),
                                ),
                                child: Text(
                                  degree,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: selected ? Colors.white : AppColors.textDark,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                      Obx(() => controller.showErrors.value &&
                          controller.selectedDegree.value.isEmpty
                          ? const Padding(
                        padding: EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          'Please choose a degree',
                          style: TextStyle(color: AppColors.errorColor, fontSize: 12),
                        ),
                      )
                          : const SizedBox.shrink()),

                      const SizedBox(height: 36),

                      // Continue button
                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.submit(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            disabledBackgroundColor:
                            AppColors.primaryRed.withOpacity(0.6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 3,
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : Text(
                            controller.isEditMode ? 'Save Changes' : 'Continue',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      )),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  InputDecoration _fieldDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
      prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.errorColor),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    String? errorText,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      isExpanded: true,
      menuMaxHeight: 320,
      borderRadius: BorderRadius.circular(18),
      dropdownColor: Colors.white,
      elevation: 8,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.primaryBlue,
        size: 25,
      ),
      decoration: _fieldDecoration(hint: hint, icon: icon).copyWith(errorText: errorText),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        );
      }).toList(),
    );
  }
}