import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/models/required_document.dart';

class DocsController extends GetxController {
  final documents = <RequiredDocument>[].obs;
  final ImagePicker _picker = ImagePicker();

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

  void markUploaded(String id) {
    final index = documents.indexWhere((d) => d.id == id);
    if (index == -1) return;
    documents[index] = documents[index].copyWith(uploaded: true);
  }

  void removeUpload(String id) {
    final index = documents.indexWhere((d) => d.id == id);
    if (index == -1) return;
    documents[index] = documents[index].copyWith(uploaded: false);
  }

  // Picks a photo (camera or gallery) for a specific document and marks
  // it uploaded once a file is chosen.
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
}