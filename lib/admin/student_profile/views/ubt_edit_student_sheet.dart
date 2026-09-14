import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/util/app_colors.dart';
import '../../model/students_record.dart';
import '../../students/controller/ubt_students_controller.dart';

Future<void> showUbtEditStudentSheet(
    BuildContext context,
    UbtStudentsController controller,
    UbtStudent student,
    ) async {
  final fullNameController =
  TextEditingController(
    text: student.fullName,
  );

  final phoneController =
  TextEditingController(
    text: student.phone,
  );

  final emailController =
  TextEditingController(
    text: student.email,
  );

  final formKey =
  GlobalKey<FormState>();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Padding(
        padding:
        EdgeInsets.only(
          bottom:
          MediaQuery.of(sheetContext)
              .viewInsets
              .bottom,
        ),
        child: Container(
          decoration:
          const BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.only(
              topLeft:
              Radius.circular(24),
              topRight:
              Radius.circular(24),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding:
              const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 45,
                        height: 5,
                        decoration:
                        BoxDecoration(
                          color: AppColors
                              .borderGrey,
                          borderRadius:
                          BorderRadius
                              .circular(
                            10,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Edit Student',
                            style:
                            TextStyle(
                              fontSize: 21,
                              fontWeight:
                              FontWeight
                                  .bold,
                              color:
                              AppColors
                                  .textDark,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () =>
                              Get.back(),
                          icon:
                          const Icon(
                            Icons
                                .close_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    _buildField(
                      controller:
                      fullNameController,
                      label:
                      'Full Name',
                      icon:
                      Icons.person_outline,
                      validator:
                          (value) {
                        if (value == null ||
                            value
                                .trim()
                                .isEmpty) {
                          return 'Full name is required.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    _buildField(
                      controller:
                      phoneController,
                      label:
                      'Phone Number',
                      icon:
                      Icons.call_outlined,
                      keyboardType:
                      TextInputType.phone,
                      validator:
                          (value) {
                        if (value == null ||
                            value
                                .trim()
                                .isEmpty) {
                          return 'Phone number is required.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    _buildField(
                      controller:
                      emailController,
                      label:
                      'Email',
                      icon:
                      Icons
                          .mail_outline_rounded,
                      keyboardType:
                      TextInputType
                          .emailAddress,
                      validator:
                          (value) {
                        final email =
                            value
                                ?.trim() ??
                                '';

                        if (email.isEmpty) {
                          return 'Email is required.';
                        }

                        final valid =
                        RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        ).hasMatch(email);

                        if (!valid) {
                          return 'Enter a valid email address.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    Obx(
                          () => SizedBox(
                        width:
                        double.infinity,
                        height: 52,
                        child:
                        ElevatedButton(
                          onPressed:
                          controller
                              .isUpdating
                              .value
                              ? null
                              : () async {
                            if (!formKey
                                .currentState!
                                .validate()) {
                              return;
                            }

                            final fullName =
                            fullNameController
                                .text
                                .trim();

                            final phone =
                            phoneController
                                .text
                                .trim();

                            final email =
                            emailController
                                .text
                                .trim();

                            final success =
                            await controller
                                .updateBasicInfo(
                              studentId:
                              student.id,
                              fullName:
                              fullName,
                              phoneNumber:
                              phone,
                              email:
                              email,
                            );

                            if (!success) {
                              return;
                            }

                            Get.back();

                            Get.snackbar(
                              'Updated',
                              'Student information updated successfully.',
                              snackPosition:
                              SnackPosition
                                  .BOTTOM,
                              backgroundColor:
                              const Color(
                                0xFF16A34A,
                              ),
                              colorText:
                              Colors
                                  .white,
                              margin:
                              const EdgeInsets
                                  .all(
                                16,
                              ),
                              borderRadius:
                              12,
                            );
                          },
                          style:
                          ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            AppColors
                                .primaryBlue,
                            foregroundColor:
                            Colors.white,
                            elevation: 0,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                14,
                              ),
                            ),
                          ),
                          child: controller
                              .isUpdating
                              .value
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child:
                            CircularProgressIndicator(
                              strokeWidth:
                              2.5,
                              color: Colors
                                  .white,
                            ),
                          )
                              : const Text(
                            'Save Changes',
                            style:
                            TextStyle(
                              fontSize:
                              16,
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
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
      );
    },
  );

  fullNameController.dispose();
  phoneController.dispose();
  emailController.dispose();
}

Widget _buildField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: AppColors.primaryBlue,
      ),
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(13),
        borderSide: BorderSide(
          color: AppColors.borderGrey,
        ),
      ),
      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(13),
        borderSide: BorderSide(
          color: AppColors.borderGrey,
        ),
      ),
      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(13),
        borderSide:
        const BorderSide(
          color:
          AppColors.primaryBlue,
          width: 1.5,
        ),
      ),
      errorBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(13),
        borderSide:
        const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(13),
        borderSide:
        const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    ),
  );
}