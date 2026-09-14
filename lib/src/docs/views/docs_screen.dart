import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/models/required_document.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../../../common/util/responsive.dart';
import '../controller/docs_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      DocsController(),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Documents',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            ResponsiveWrapper(
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
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildStatsRow(controller),

                    const SizedBox(height: 24),

                    _buildUploadedFilesSection(
                      controller,
                      context,
                    ),

                    const SizedBox(height: 24),

                    _buildRequiredDocumentsSection(
                      controller,
                      context,
                    ),

                    const SizedBox(height: 22),

                    _buildDragAndDropZone(
                      controller,
                      context,
                    ),

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

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        40,
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
      child: Column(
        children: [
          const SizedBox(height: 30),

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Documents',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Upload & manage your files',
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(0.85),
                        fontSize: 14.5,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () => Get.toNamed(
                  AppRoute.studentNotifications,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.16),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons
                            .notifications_none_rounded,
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
                        decoration:
                        BoxDecoration(
                          color:
                          AppColors.primaryRed,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                            AppColors.navyDark,
                            width: 1.5,
                          ),
                        ),
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

  // ============================================================
  // STATS
  // ============================================================

  Widget _buildStatsRow(
      DocsController controller,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Obx(
            () => Row(
          children: [
            Expanded(
              child: _statCard(
                '${controller.uploadedCount}',
                'Uploaded',
                const Color(0xFF16A34A),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _statCard(
                '${controller.pendingCount}',
                'Pending',
                const Color(0xFFF59E0B),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _statCard(
                '${controller.totalCount}',
                'Total',
                AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(
      String value,
      String label,
      Color color,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset:
            const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 23,
              fontWeight:
              FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color:
              AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // UPLOADED FILES
  // ============================================================

  Widget _buildUploadedFilesSection(
      DocsController controller,
      BuildContext context,
      ) {
    return Obx(() {
      final files =
          controller.uploadedFiles;

      if (files.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              'Uploaded Files',
              style: TextStyle(
                fontSize: 17,
                fontWeight:
                FontWeight.bold,
                color:
                AppColors.textDark,
              ),
            ),

            const SizedBox(height: 12),

            ...files.map(
                  (document) =>
                  _uploadedFileTile(
                    controller,
                    document,
                    context,
                  ),
            ),
          ],
        ),
      );
    });
  }

  Widget _uploadedFileTile(
      DocsController controller,
      RequiredDocument document,
      BuildContext context,
      ) {
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
            width: 42,
            height: 42,
            clipBehavior:
            Clip.antiAlias,
            decoration:
            BoxDecoration(
              color: AppColors
                  .primaryBlue
                  .withOpacity(0.1),
              borderRadius:
              BorderRadius.circular(
                10,
              ),
            ),
            child: _documentPreview(
              document,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        document.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: document.required
                            ? const Color(0xFFFEE2E2)
                            : const Color(0xFFF3F4F6),
                      ),
                      child: Text(
                        document.required
                            ? 'Required'
                            : 'Optional',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: document.required
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      document.uploaded
                          ? Icons.check_circle
                          : Icons.error_outline,
                      size: 13,
                      color: document.uploaded
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFF59E0B),
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        document.uploaded
                            ? 'Uploaded'
                            : 'Not uploaded yet',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: document.uploaded
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          if (!document.uploaded)
            ElevatedButton.icon(
              onPressed: () => _showUploadOptions(
                controller,
                document,
                context,
              ),
              icon: const Icon(
                Icons.upload_rounded,
                size: 15,
              ),
              label: const Text(
                'Upload',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),

          _circleIconButton(
            icon: Icons
                .visibility_outlined,
            color:
            AppColors.textGrey,
            background:
            AppColors.background,
            onTap: () =>
                _previewDocument(
                  document,
                  context,
                ),
          ),

          const SizedBox(width: 8),

          _circleIconButton(
            icon:
            Icons.close_rounded,
            color:
            AppColors.errorColor,
            background:
            AppColors.errorColor
                .withOpacity(0.1),
            onTap: () =>
                controller.removeUpload(
                  document.id,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragAndDropZone(
      DocsController controller,
      BuildContext context,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: DottedBorderBox(
        onBrowse: () {
          _showBrowseOptions(
            controller,
            context,
          );
        },
      ),
    );
  }

  // ============================================================
  // DOCUMENT PREVIEW
  // ============================================================

  Widget _documentPreview(
      RequiredDocument document,
      ) {
    final path =
        document.filePath;

    if (path == null ||
        path.trim().isEmpty) {
      return Icon(
        document.icon,
        color:
        document.accentColor,
        size: 20,
      );
    }

    if (path.startsWith(
      'http://',
    ) ||
        path.startsWith(
          'https://',
        )) {
      return Image.network(
        path,
        width: 42,
        height: 42,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) {
          return Icon(
            document.icon,
            color:
            document.accentColor,
            size: 20,
          );
        },
        loadingBuilder:
            (
            context,
            child,
            loadingProgress,
            ) {
          if (loadingProgress ==
              null) {
            return child;
          }

          return const Center(
            child:
            SizedBox(
              width: 16,
              height: 16,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        },
      );
    }

    final file =
    File(path);

    if (file.existsSync()) {
      return Image.file(
        file,
        width: 42,
        height: 42,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) {
          return Icon(
            document.icon,
            color:
            document.accentColor,
            size: 20,
          );
        },
      );
    }

    return Icon(
      document.icon,
      color:
      document.accentColor,
      size: 20,
    );
  }

  String _documentTypeLabel(
      RequiredDocument document,
      ) {
    switch (document.id) {
      case 'photo':
        return 'Photo';

      case 'confirmation':
      case 'offer':
      case 'loc':
      case 'visa':
      case 'ticket':
        return 'Document';

      default:
        return 'File';
    }
  }

  void _previewDocument(
      RequiredDocument document,
      BuildContext context,
      ) {
    final path = document.filePath;

    if (path == null || path.trim().isEmpty) {
      Get.snackbar(
        'Preview',
        'No file available.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.88,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  child: _buildDocumentViewer(document),
                ),

                Positioned(
                  top: 4,
                  right: 4,
                  child: Material(
                    color: Colors.black54,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDocumentViewer(
      RequiredDocument document,
      ) {
    final path = document.filePath;

    if (path == null || path.trim().isEmpty) {
      return const Center(
        child: Icon(
          Icons.description_outlined,
          color: Colors.white,
          size: 80,
        ),
      );
    }

    final lowerPath = path.toLowerCase();

    final isPdf =
        lowerPath.contains('.pdf') ||
            lowerPath.contains('application/pdf');

    if (isPdf) {
      if (path.startsWith('http://') ||
          path.startsWith('https://')) {
        return SfPdfViewer.network(
          path,
          canShowScrollHead: true,
          canShowScrollStatus: true,
          onDocumentLoadFailed:
              (PdfDocumentLoadFailedDetails details) {
            debugPrint(
              'PDF LOAD FAILED: ${details.description}',
            );
          },
        );
      }

      return SfPdfViewer.file(
        File(path),
        onDocumentLoadFailed:
            (PdfDocumentLoadFailedDetails details) {
          debugPrint(
            'PDF LOAD FAILED: ${details.description}',
          );
        },
      );
    }

    // ------------------------------------------------------------
    // IMAGE
    // ------------------------------------------------------------

    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return InteractiveViewer(
        minScale: 0.8,
        maxScale: 4,
        child: Center(
          child: Image.network(
            path,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white,
                  size: 70,
                ),
              );
            },
            loadingBuilder: (
                context,
                child,
                loadingProgress,
                ) {
              if (loadingProgress == null) {
                return child;
              }

              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      );
    }

    // ------------------------------------------------------------
    // LOCAL IMAGE
    // ------------------------------------------------------------

    final file = File(path);

    return InteractiveViewer(
      minScale: 0.8,
      maxScale: 4,
      child: Image.file(
        file,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: Colors.white,
              size: 70,
            ),
          );
        },
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required Color color,
    required Color background,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration:
        BoxDecoration(
          color: background,
          shape:
          BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
      ),
    );
  }

  // ============================================================
  // REQUIRED DOCUMENTS
  // ============================================================

  Widget _buildRequiredDocumentsSection(
      DocsController controller,
      BuildContext context,
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
          const Text(
            'Required Documents',
            style: TextStyle(
              fontSize: 17,
              fontWeight:
              FontWeight.bold,
              color:
              AppColors.textDark,
            ),
          ),

          const SizedBox(height: 12),

          Obx(
                () => Column(
              children: controller
                  .documents
                  .map(
                    (document) =>
                    _requiredDocTile(
                      controller,
                      document,
                      context,
                    ),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _requiredDocTile(
      DocsController controller,
      RequiredDocument document,
      BuildContext context,
      ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: document.uploaded
              ? const Color(0xFF16A34A)
              : AppColors.borderGrey,
          width: document.uploaded ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          // ========================================================
          // ICON
          // ========================================================
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: document.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              document.icon,
              color: document.accentColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // ========================================================
          // DOCUMENT INFORMATION
          // ========================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      document.uploaded
                          ? Icons.check_circle
                          : Icons.error_outline,
                      size: 13,
                      color: document.uploaded
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFF59E0B),
                    ),

                    const SizedBox(width: 4),

                    Flexible(
                      child: Text(
                        document.uploaded
                            ? 'Uploaded'
                            : 'Not uploaded yet',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: document.uploaded
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ========================================================
          // REQUIRED / OPTIONAL BADGE
          // ========================================================
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: document.required
                  ? const Color(0xFFFEE2E2)
                  : const Color(0xFFF3F4F6),
            ),
            child: Text(
              document.required ? 'Required' : 'Optional',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: document.required
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ========================================================
          // UPLOAD BUTTON
          // ========================================================
          if (!document.uploaded)
            ElevatedButton.icon(
              onPressed: () => _showUploadOptions(
                controller,
                document,
                context,
              ),
              icon: const Icon(
                Icons.upload_rounded,
                size: 15,
              ),
              label: const Text(
                'Upload',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),

          // ========================================================
          // VIEW BUTTON
          // ========================================================
          if (document.uploaded) ...[
            const SizedBox(width: 4),

            _circleIconButton(
              icon: Icons.visibility_outlined,
              color: AppColors.textGrey,
              background: AppColors.background,
              onTap: () => _previewDocument(
                document,
                context,
              ),
            ),
          ],
        ],
      ),
    );
  }
  // ============================================================
  // UPLOAD OPTIONS
  // ============================================================

  void _showUploadOptions(
      DocsController controller,
      RequiredDocument document,
      BuildContext context,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
      Colors.white,
      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(
            24,
          ),
        ),
      ),
      constraints:
      BoxConstraints(
        maxHeight:
        MediaQuery.of(context)
            .size
            .height *
            0.9,
      ),
      builder:
          (sheetContext) {
        return SafeArea(
          child:
          SingleChildScrollView(
            padding:
            const EdgeInsets
                .fromLTRB(
              20,
              12,
              20,
              20,
            ),
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                _sheetHandle(),

                Text(
                  'Upload ${document.title}',
                  style:
                  const TextStyle(
                    fontSize: 17,
                    fontWeight:
                    FontWeight
                        .bold,
                    color:
                    AppColors
                        .textDark,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                _uploadOptionTile(
                  icon: Icons
                      .camera_alt_rounded,
                  label:
                  'Take a Photo',
                  onTap: () {
                    Get.back();

                    controller
                        .pickDocumentPhoto(
                      document.id,
                      ImageSource
                          .camera,
                    );
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                _uploadOptionTile(
                  icon: Icons
                      .photo_library_rounded,
                  label:
                  'Choose from Gallery',
                  onTap: () {
                    Get.back();

                    controller
                        .pickDocumentPhoto(
                      document.id,
                      ImageSource
                          .gallery,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sheetHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin:
        const EdgeInsets.only(
          bottom: 18,
        ),
        decoration:
        BoxDecoration(
          color:
          AppColors.borderGrey,
          borderRadius:
          BorderRadius.circular(
            4,
          ),
        ),
      ),
    );
  }

  Widget _uploadOptionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius:
      BorderRadius.circular(
        14,
      ),
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets
            .symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        decoration:
        BoxDecoration(
          color:
          AppColors.background,
          borderRadius:
          BorderRadius.circular(
            14,
          ),
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
                color: AppColors
                    .primaryBlue
                    .withOpacity(0.1),
                shape:
                BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors
                    .primaryBlue,
                size: 18,
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            Text(
              label,
              style:
              const TextStyle(
                fontSize: 15.5,
                fontWeight:
                FontWeight.w600,
                color:
                AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BROWSE FILES
  // ============================================================


  void _showBrowseOptions(
      DocsController controller,
      BuildContext context,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
      Colors.white,
      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(
            24,
          ),
        ),
      ),
      constraints:
      BoxConstraints(
        maxHeight:
        MediaQuery.of(context)
            .size
            .height *
            0.9,
      ),
      builder:
          (sheetContext) {
        return SafeArea(
          child:
          SingleChildScrollView(
            padding:
            const EdgeInsets
                .fromLTRB(
              20,
              12,
              20,
              20,
            ),
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                _sheetHandle(),

                const Text(
                  'Upload a Document',
                  style:
                  TextStyle(
                    fontSize: 17,
                    fontWeight:
                    FontWeight
                        .bold,
                    color:
                    AppColors
                        .textDark,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                _uploadOptionTile(
                  icon: Icons
                      .camera_alt_rounded,
                  label:
                  'Take a Photo',
                  onTap: () {
                    Get.back();

                    controller
                        .browseAndUploadNextPending(
                      ImageSource
                          .camera,
                    );
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                _uploadOptionTile(
                  icon: Icons
                      .photo_library_rounded,
                  label:
                  'Choose from Gallery',
                  onTap: () {
                    Get.back();

                    controller
                        .browseAndUploadNextPending(
                      ImageSource
                          .gallery,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



// ================================================================
// DOTTED BORDER
// ================================================================

class DottedBorderBox
    extends StatelessWidget {
  final VoidCallback onBrowse;

  const DottedBorderBox({
    super.key,
    required this.onBrowse,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return CustomPaint(
      painter:
      _DashedBorderPainter(
        color: AppColors
            .primaryBlue
            .withOpacity(0.4),
      ),
      child: Container(
        width:
        double.infinity,
        padding:
        const EdgeInsets
            .symmetric(
          vertical: 30,
          horizontal: 20,
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration:
              BoxDecoration(
                color: AppColors
                    .primaryBlue
                    .withOpacity(0.1),
                shape:
                BoxShape.circle,
              ),
              child:
              const Icon(
                Icons
                    .upload_rounded,
                color: AppColors
                    .primaryBlue,
                size: 24,
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            const Text(
              'Drag & drop or browse',
              style:
              TextStyle(
                fontSize: 16,
                fontWeight:
                FontWeight
                    .bold,
                color: AppColors
                    .textDark,
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            const Text(
              'PDF, JPG, PNG supported • Max 10MB',
              style:
              TextStyle(
                fontSize: 12.5,
                color: AppColors
                    .textGrey,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            SizedBox(
              width:
              double.infinity,
              child:
              ElevatedButton(
                onPressed:
                onBrowse,
                style:
                ElevatedButton
                    .styleFrom(
                  backgroundColor:
                  AppColors
                      .primaryBlue,
                  foregroundColor:
                  Colors.white,
                  padding:
                  const EdgeInsets
                      .symmetric(
                    vertical: 13,
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius
                        .circular(
                      12,
                    ),
                  ),
                  elevation: 0,
                ),
                child:
                const Text(
                  'Browse Files',
                  style:
                  TextStyle(
                    fontSize: 15.5,
                    fontWeight:
                    FontWeight
                        .bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }

}

class _DashedBorderPainter
    extends CustomPainter {
  final Color color;

  const _DashedBorderPainter({
    required this.color,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style =
          PaintingStyle.stroke;

    final rrect =
    RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      const Radius.circular(
        18,
      ),
    );

    const dashWidth = 6.0;
    const dashSpace = 4.0;

    final path = Path()
      ..addRRect(rrect);

    for (final metric
    in path.computeMetrics()) {
      double distance = 0;

      while (
      distance <
          metric.length) {
        final next =
            distance +
                dashWidth;

        canvas.drawPath(
          metric.extractPath(
            distance,
            next.clamp(
              0,
              metric.length,
            ),
          ),
          paint,
        );

        distance =
            next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(
      covariant
      _DashedBorderPainter
      oldDelegate,
      ) {
    return oldDelegate.color !=
        color;
  }
}