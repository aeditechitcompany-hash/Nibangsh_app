import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/models/book_resource.dart';
import '../../../common/services/books_repository.dart';

class AdminBooksController extends GetxController {
  final BooksRepository _repo = BooksRepository.to;

  List<BookResource> get books => _repo.books;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final pickedFileName = ''.obs;
  final pickedFilePath = ''.obs;
  final pickedFileSize = ''.obs;
  final isPicking = false.obs;

  bool get hasPickedFile => pickedFilePath.value.isNotEmpty;

  Future<void> pickPdf() async {
    isPicking.value = true;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.single;
      if (file.path == null) {
        Get.snackbar(
          'Error',
          'Could not access that file on this device.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }
      pickedFileName.value = file.name;
      pickedFilePath.value = file.path!;
      pickedFileSize.value = _formatSize(file.size);
    } catch (e) {
      debugPrint('PDF picker failed: $e');
      Get.snackbar(
        'Error',
        'Could not open the file picker.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isPicking.value = false;
    }
  }

  void clearPickedFile() {
    pickedFileName.value = '';
    pickedFilePath.value = '';
    pickedFileSize.value = '';
  }

  String _formatSize(int bytes) {
    if (bytes <= 0) return '';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(0)} KB';
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }

  void saveBook() {
    final title = titleController.text.trim();
    if (title.isEmpty || !hasPickedFile) {
      Get.snackbar(
        'Missing info',
        'Add a title and choose a PDF first.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    _repo.addBook(
      BookResource(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: descriptionController.text.trim(),
        fileName: pickedFileName.value,
        filePath: pickedFilePath.value,
        fileSizeLabel: pickedFileSize.value,
        uploadedAt: DateTime.now(),
      ),
    );

    titleController.clear();
    descriptionController.clear();
    clearPickedFile();

    Get.back();
    Get.snackbar(
      'Uploaded',
      'Book is now visible to students.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF16A34A),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  void deleteBook(String id) {
    _repo.removeBook(id);
    Get.snackbar(
      'Removed',
      'Book removed from the library.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
