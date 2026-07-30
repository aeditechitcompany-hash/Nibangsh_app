import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/models/required_document.dart';
import '../../../common/util/app_route.dart';
import '../../home/controller/home_controller.dart';

class DocsController extends GetxController {
  final documents = <RequiredDocument>[].obs;
  final ImagePicker _picker = ImagePicker();

  // Guards against repeat-triggering the "all done" flow if something
  // toggles uploaded state more than once after completion.
  bool _completionHandled = false;

  @override
  void onInit() {
    super.onInit();
    documents.assignAll(RequiredDocumentsCatalog.seed);
  }

  List<RequiredDocument> get uploadedFiles =>
      documents.where((d) => d.uploaded).toList();

  int get uploadedCount => documents.where((d) => d.uploaded).length;
  int get pendingCount => documents.where((d) => !d.uploaded).length;
  int get totalCount => documents.length;

  bool get allUploaded =>
      documents.isNotEmpty && documents.every((d) => d.uploaded);

  void markUploaded(String id) {
    final index = documents.indexWhere((d) => d.id == id);
    if (index == -1) return;
    documents[index] = documents[index].copyWith(uploaded: true);
    _checkAllUploadedAndProceed();
  }

  void removeUpload(String id) {
    final index = documents.indexWhere((d) => d.id == id);
    if (index == -1) return;
    documents[index] = documents[index].copyWith(uploaded: false);
    // A document was pulled back out, so the "all done" flow can fire
    // again the next time everything gets uploaded.
    _completionHandled = false;
  }

  // Picks a photo for a specific document and marks it uploaded once a file is chosen.
  Future<void> pickDocumentPhoto(String id, ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1600,
      );
      if (picked == null) return;
      final index = documents.indexWhere((d) => d.id == id);
      if (index == -1) return;
      documents[index] = documents[index].copyWith(
        uploaded: true,
        filePath: picked.path,
      );
      _checkAllUploadedAndProceed();
    } catch (e) {
      Get.snackbar(
        'Error',
        source == ImageSource.camera
            ? 'Could not open camera.'
            : 'Could not open gallery.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // Used by the "Browse Files" drag & drop zone — picks a photo for the
  // next pending document.
  Future<void> browseAndUploadNextPending(ImageSource source) async {
    for (final doc in documents) {
      if (!doc.uploaded) {
        await pickDocumentPhoto(doc.id, source);
        break;
      }
    }
  }

  // Once every required document has been uploaded: mark Step 3 complete
  // back on the home screen, let the user know, then return them there.
  void _checkAllUploadedAndProceed() {
    if (_completionHandled || !allUploaded) return;
    _completionHandled = true;

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().markStep3Done();
    }

    Get.snackbar(
      'All Set!',
      'All documents uploaded — Step 3 is complete.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF16A34A),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );

    Future.delayed(const Duration(milliseconds: 700), () {
      if (Get.currentRoute == AppRoute.docs) {
        Get.back();
      }
    });
  }
}