import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibangsh_consultancy/admin/student_profile/views/ubt_edit_student_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/util/app_colors.dart';
import '../../../../common/util/responsive.dart';
import '../../model/students_record.dart';
import '../../students/controller/ubt_students_controller.dart';


class UbtStudentProfileScreen
    extends StatelessWidget {
  const UbtStudentProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final argument = Get.arguments;

    if (argument is! UbtStudent) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Invalid student information.',
          ),
        ),
      );
    }

    final initial = argument;

    final controller =
    Get.isRegistered<UbtStudentsController>()
        ? Get.find<UbtStudentsController>()
        : Get.put(
      UbtStudentsController(),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final student =
            controller.byId(initial.id) ??
                initial;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              _buildHeader(student),

              ResponsiveDashboardWrapper(
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.only(
                    top: 22,
                  ),
                  child: Column(
                    children: [
                      _buildStudentInfo(
                        context,
                        controller,
                        student,
                      ),

                      const SizedBox(height: 20),

                      _buildDocuments(
                        student,
                      ),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader(
      UbtStudent student,
      ) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        28,
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
        borderRadius:
        const BorderRadius.only(
          bottomLeft:
          Radius.circular(32),
          bottomRight:
          Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding:
                  const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child:
                  const Icon(
                    Icons
                        .arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                'Student Information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                alignment:
                Alignment.center,
                decoration:
                BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.16),
                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),
                ),
                child: Text(
                  student.initials,
                  style:
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName
                          .isEmpty
                          ? 'No name'
                          : student.fullName,
                      style:
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      student.email.isEmpty
                          ? 'No email'
                          : student.email,
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(
                          0.8,
                        ),
                        fontSize: 13.5,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      student.phone.isEmpty
                          ? 'No phone number'
                          : student.phone,
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(
                          0.75,
                        ),
                        fontSize: 13,
                      ),
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

  // ==========================================================
  // BASIC INFORMATION
  // ==========================================================

  Widget _buildStudentInfo(
      BuildContext context,
      UbtStudentsController controller,
      UbtStudent student,
      ) {
    return _sectionCard(
      title: 'Student Information',
      trailing: GestureDetector(
        onTap: () {
          showUbtEditStudentSheet(
            context,
            controller,
            student,
          );
        },
        child: Container(
          padding:
          const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue
                .withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.edit_outlined,
            size: 17,
            color:
            AppColors.primaryBlue,
          ),
        ),
      ),
      child: Column(
        children: [
          _infoRow(
            icon: Icons.person_outline,
            label: 'Full Name',
            value:
            student.fullName.isEmpty
                ? 'Not provided'
                : student.fullName,
          ),

          _divider(),

          _infoRow(
            icon:
            Icons.mail_outline_rounded,
            label: 'Email',
            value:
            student.email.isEmpty
                ? 'Not provided'
                : student.email,
          ),

          _divider(),

          _infoRow(
            icon: Icons.call_outlined,
            label: 'Phone Number',
            value:
            student.phone.isEmpty
                ? 'Not provided'
                : student.phone,
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue
                  .withOpacity(0.1),
              borderRadius:
              BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 17,
              color:
              AppColors.primaryBlue,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                  const TextStyle(
                    fontSize: 12.5,
                    color:
                    AppColors.textGrey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style:
                  const TextStyle(
                    fontSize: 15.5,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      color: AppColors.borderGrey,
    );
  }

  // ==========================================================
  // DOCUMENTS
  // ==========================================================

  Widget _buildDocuments(
      UbtStudent student,
      ) {
    final documents =
        student.documents;

    return _sectionCard(
      title: 'Uploaded Documents',
      trailing: Text(
        '${documents.length}',
        style:
        const TextStyle(
          fontSize: 15,
          fontWeight:
          FontWeight.bold,
          color:
          AppColors.primaryBlue,
        ),
      ),
      child: documents.isEmpty
          ? _emptyDocuments()
          : Column(
        children:
        List.generate(
          documents.length,
              (index) {
            final document =
            documents[index];

            return Column(
              children: [
                _documentRow(
                  document,
                ),

                if (index !=
                    documents.length - 1)
                  _divider(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _emptyDocuments() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 30,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 45,
              color: AppColors.textGrey
                  .withOpacity(0.5),
            ),

            const SizedBox(height: 12),

            const Text(
              'No documents uploaded',
              style:
              TextStyle(
                fontSize: 15,
                fontWeight:
                FontWeight.w600,
                color:
                AppColors.textDark,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'The student has not uploaded any documents yet.',
              textAlign:
              TextAlign.center,
              style:
              TextStyle(
                fontSize: 13,
                color:
                AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _documentRow(
      StudentDocument document,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue
                  .withOpacity(0.1),
              borderRadius:
              BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.description_outlined,
              color:
              AppColors.primaryBlue,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              document.name,
              maxLines: 2,
              overflow:
              TextOverflow.ellipsis,
              style:
              const TextStyle(
                fontSize: 14.5,
                fontWeight:
                FontWeight.w600,
                color:
                AppColors.textDark,
              ),
            ),
          ),

          const SizedBox(width: 10),

          ElevatedButton.icon(
            onPressed:
            document.url.isEmpty
                ? null
                : () => _openDocument(
              document.url,
            ),
            icon: const Icon(
              Icons
                  .visibility_outlined,
              size: 15,
            ),
            label: const Text(
              'View',
            ),
            style:
            ElevatedButton.styleFrom(
              backgroundColor:
              AppColors.primaryBlue,
              foregroundColor:
              Colors.white,
              elevation: 0,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 8,
              ),
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                  9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDocument(
      String url,
      ) async {
    final uri =
    Uri.tryParse(url);

    if (uri == null) {
      Get.snackbar(
        'Invalid document',
        'The document URL is invalid.',
        snackPosition:
        SnackPosition.BOTTOM,
        backgroundColor:
        AppColors.errorColor,
        colorText: Colors.white,
        margin:
        const EdgeInsets.all(16),
      );
      return;
    }

    try {
      final opened =
      await launchUrl(
        uri,
        mode: LaunchMode
            .externalApplication,
      );

      if (!opened) {
        throw Exception(
          'Unable to open document.',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Unable to open document',
        'Could not open this document.',
        snackPosition:
        SnackPosition.BOTTOM,
        backgroundColor:
        AppColors.errorColor,
        colorText: Colors.white,
        margin:
        const EdgeInsets.all(16),
      );
    }
  }

  // ==========================================================
  // SECTION CARD
  // ==========================================================

  Widget _sectionCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        width: double.infinity,
        padding:
        const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(18),
          border: Border.all(
            color:
            AppColors.borderGrey,
          ),
          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(
                0.03,
              ),
              blurRadius: 8,
              offset:
              const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: [
                Text(
                  title,
                  style:
                  const TextStyle(
                    fontSize: 16.5,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    AppColors.textDark,
                  ),
                ),

                if (trailing != null)
                  trailing,
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