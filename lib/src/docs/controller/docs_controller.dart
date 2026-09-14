import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/api_services/student_application_service.dart';
import '../../../common/models/required_document.dart';
import '../../../common/util/app_route.dart';
import '../../home/controller/home_controller.dart';

class DocsController extends GetxController {
  final documents = <RequiredDocument>[].obs;

  final ImagePicker _picker = ImagePicker();

  final StudentApplicationService _applicationService =
  StudentApplicationService();

  bool _completionHandled = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    // Step 3 documents.
    //
    // Transcript is NOT included here because it is uploaded
    // during Step 1.
    documents.assignAll(
      RequiredDocumentsCatalog.seed,
    );

    loadDocumentsFromBackend();
  }

  // ============================================================
  // GETTERS
  // ============================================================

  List<RequiredDocument> get uploadedFiles {
    return documents
        .where(
          (document) => document.uploaded,
    )
        .toList();
  }

  int get uploadedCount {
    return documents
        .where(
          (document) => document.uploaded,
    )
        .length;
  }

  int get pendingCount {
    return documents
        .where(
          (document) => !document.uploaded,
    )
        .length;
  }

  int get totalCount {
    return documents.length;
  }

  bool get allRequiredUploaded {
    final requiredDocuments = documents
        .where(
          (document) => document.required,
    )
        .toList();

    return requiredDocuments.isNotEmpty &&
        requiredDocuments.every(
              (document) => document.uploaded,
        );
  }

  // ============================================================
  // LOAD DOCUMENTS FROM BACKEND
  // ============================================================

  Future<void> loadDocumentsFromBackend() async {
    try {
      debugPrint(
        '========== LOADING DOCUMENTS ==========',
      );

      final application =
      await _applicationService.getMyApplication();

      debugPrint(
        'APPLICATION RESPONSE:',
      );

      debugPrint(
        application.toString(),
      );

      debugPrint(
        '=======================================',
      );

      _applyBackendDocuments(
        application,
      );
    } catch (e) {
      debugPrint(
        'LOAD DOCUMENTS ERROR: $e',
      );

      Get.snackbar(
        'Error',
        'Could not load your documents.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // ============================================================
  // APPLY BACKEND DATA
  // ============================================================

  void _applyBackendDocuments(
      Map<String, dynamic> application,
      ) {
    final updatedDocuments =
    documents.map(
          (document) {
        String? backendUrl;

        switch (document.id) {
        // ----------------------------------------------------
        // STUDENT PHOTO
        // ----------------------------------------------------

          case 'photo':
            backendUrl =
                application['step1_photo']?.toString();
            break;

        // ----------------------------------------------------
        // CONFIRMATION
        // ----------------------------------------------------

          case 'confirmation':
            backendUrl =
                application['confirmation_file']?.toString();
            break;

        // ----------------------------------------------------
        // OFFER
        // ----------------------------------------------------

          case 'offer':
            backendUrl =
                application['offer_file']?.toString();
            break;

        // ----------------------------------------------------
        // LOC
        // ----------------------------------------------------

          case 'loc':
            backendUrl =
                application['loc_file']?.toString();
            break;

        // ----------------------------------------------------
        // VISA
        // ----------------------------------------------------

          case 'visa':
            backendUrl =
                application[
                'visa_approval_letter_file'
                ]?.toString();
            break;

        // ----------------------------------------------------
        // TICKET
        // ----------------------------------------------------

          case 'ticket':
            backendUrl =
                application['ticket_file']?.toString();
            break;
        }

        final cleanedUrl =
        backendUrl?.trim();

        final hasFile =
            cleanedUrl != null &&
                cleanedUrl.isNotEmpty &&
                cleanedUrl != 'null';

        return document.copyWith(
          uploaded: hasFile,
          filePath: hasFile
              ? cleanedUrl
              : null,
        );
      },
    ).toList();

    documents.assignAll(
      updatedDocuments,
    );

    // ----------------------------------------------------------
    // DEBUG
    // ----------------------------------------------------------

    debugPrint(
      '========== DOCUMENT STATUS ==========',
    );

    for (final document in documents) {
      debugPrint(
        '${document.id}: '
            'uploaded=${document.uploaded}, '
            'path=${document.filePath}',
      );
    }

    debugPrint(
      '=====================================',
    );
  }

  // ============================================================
  // PICK + UPLOAD DOCUMENT
  // ============================================================

  Future<void> pickDocumentPhoto(
      String id,
      ImageSource source,
      ) async {
    try {
      // --------------------------------------------------------
      // PICK IMAGE
      // --------------------------------------------------------

      final XFile? picked =
      await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1600,
      );

      if (picked == null) {
        return;
      }

      // --------------------------------------------------------
      // FIND BACKEND FIELD
      // --------------------------------------------------------

      final backendField =
      _backendFieldForDocument(id);

      if (backendField == null) {
        debugPrint(
          'DOCUMENT NOT CONFIGURED: $id',
        );

        Get.snackbar(
          'Error',
          'Document "$id" is not configured.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );

        return;
      }

      final file =
      File(picked.path);

      // --------------------------------------------------------
      // DEBUG
      // --------------------------------------------------------

      debugPrint(
        '========== UPLOADING DOCUMENT ==========',
      );

      debugPrint(
        'Document ID: $id',
      );

      debugPrint(
        'Backend field: $backendField',
      );

      debugPrint(
        'Local file: ${picked.path}',
      );

      debugPrint(
        '=========================================',
      );

      // --------------------------------------------------------
      // UPLOADING MESSAGE
      // --------------------------------------------------------

      Get.snackbar(
        'Uploading',
        'Uploading ${_titleForDocument(id)}...',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );

      // --------------------------------------------------------
      // UPLOAD TO BACKEND
      // --------------------------------------------------------

      final response =
      await _applicationService.updateApplication(
        files: {
          backendField: file,
        },
      );

      // --------------------------------------------------------
      // DEBUG RESPONSE
      // --------------------------------------------------------

      debugPrint(
        '========== UPLOAD RESPONSE ==========',
      );

      debugPrint(
        response.toString(),
      );

      debugPrint(
        '====================================',
      );

      // ========================================================
      // IMPORTANT FIX
      // ========================================================
      //
      // DO NOT DO THIS:
      //
      // filePath: picked.path
      //
      // because picked.path is only the local temporary path.
      //
      // Instead, reload the application from Django.
      // Django returns the actual Supabase URL.
      // ========================================================

      await loadDocumentsFromBackend();

      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------

      Get.snackbar(
        'Success',
        '${_titleForDocument(id)} uploaded successfully.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      // --------------------------------------------------------
      // CHECK STEP 3
      // --------------------------------------------------------

      await _checkAllUploadedAndProceed();
    } catch (e) {
      debugPrint(
        'DOCUMENT UPLOAD ERROR: $e',
      );

      Get.snackbar(
        'Upload Failed',
        'Could not upload the document.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // ============================================================
  // BACKEND FIELD MAPPING
  // ============================================================

  String? _backendFieldForDocument(
      String id,
      ) {
    switch (id) {
      case 'photo':
        return 'step1_photo';

      case 'confirmation':
        return 'confirmation_file';

      case 'offer':
        return 'offer_file';

      case 'loc':
        return 'loc_file';

      case 'visa':
        return 'visa_approval_letter_file';

      case 'ticket':
        return 'ticket_file';

      default:
        return null;
    }
  }

  // ============================================================
  // DOCUMENT TITLES
  // ============================================================

  String _titleForDocument(
      String id,
      ) {
    switch (id) {
      case 'photo':
        return 'Passport Photo';

      case 'confirmation':
        return 'Confirmation File';

      case 'offer':
        return 'Offer Letter';

      case 'loc':
        return 'Letter of Confirmation';

      case 'visa':
        return 'Visa Approval Letter';

      case 'ticket':
        return 'Flight Ticket';

      default:
        return 'Document';
    }
  }

  // ============================================================
  // BROWSE NEXT PENDING
  // ============================================================

  Future<void> browseAndUploadNextPending(
      ImageSource source,
      ) async {
    for (final document in documents) {
      if (!document.uploaded) {
        await pickDocumentPhoto(
          document.id,
          source,
        );

        return;
      }
    }

    Get.snackbar(
      'All Documents Uploaded',
      'There are no pending documents.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  // ============================================================
  // MARK UPLOADED
  // ============================================================

  void markUploaded(
      String id,
      ) {
    final index =
    documents.indexWhere(
          (document) => document.id == id,
    );

    if (index == -1) {
      return;
    }

    documents[index] =
        documents[index].copyWith(
          uploaded: true,
        );

    _checkAllUploadedAndProceed();
  }

  // ============================================================
  // REMOVE LOCAL STATE
  // ============================================================

  void removeUpload(
      String id,
      ) {
    final index =
    documents.indexWhere(
          (document) => document.id == id,
    );

    if (index == -1) {
      return;
    }

    documents[index] =
        documents[index].copyWith(
          uploaded: false,
          clearFilePath: true,
        );

    _completionHandled = false;
  }

  // ============================================================
  // STEP 3 COMPLETION
  // ============================================================

  Future<void> _checkAllUploadedAndProceed() async {
    // ----------------------------------------------------------
    // Already handled
    // ----------------------------------------------------------

    if (_completionHandled) {
      return;
    }

    // ----------------------------------------------------------
    // Required documents are not complete
    // ----------------------------------------------------------

    if (!allRequiredUploaded) {
      return;
    }

    _completionHandled = true;

    // ----------------------------------------------------------
    // HomeController must exist
    // ----------------------------------------------------------

    if (!Get.isRegistered<HomeController>()) {
      _completionHandled = false;

      Get.snackbar(
        'Error',
        'Home process controller is not available.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      return;
    }

    final homeController =
    Get.find<HomeController>();

    // ----------------------------------------------------------
    // IMPORTANT:
    // Only complete Step 3 if Step 3 is actually current.
    // ----------------------------------------------------------

    if (homeController.currentStep.value != 3) {
      debugPrint(
        'STEP 3 NOT COMPLETED: '
            'current step is '
            '${homeController.currentStep.value}',
      );

      _completionHandled = false;
      return;
    }

    debugPrint(
      '========== COMPLETING STEP 3 ==========',
    );

    final completed =
    await homeController.completeStudentStep(3);

    debugPrint(
      'STEP 3 COMPLETED: $completed',
    );

    debugPrint(
      '=======================================',
    );

    if (!completed) {
      _completionHandled = false;
      return;
    }

    // ----------------------------------------------------------
    // SUCCESS MESSAGE
    // ----------------------------------------------------------

    const duration =
    Duration(seconds: 2);

    Get.snackbar(
      'All Set!',
      'All documents uploaded — Step 3 is complete.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
      const Color(0xFF16A34A),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: duration,
    );

    // ----------------------------------------------------------
    // RETURN TO HOME
    // ----------------------------------------------------------

    await Future.delayed(
      duration +
          const Duration(
            milliseconds: 300,
          ),
    );

    if (Get.currentRoute ==
        AppRoute.docs) {
      Get.back();
    }
  }
}