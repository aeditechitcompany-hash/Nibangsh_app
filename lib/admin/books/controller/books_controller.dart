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

  // Set when editing an existing book instead of adding a new one.
  final editingBookId = Rxn<String>();
  bool get isEditing => editingBookId.value != null;

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

  // Opens the sheet in "Add" mode with a blank form.
  void startAdd() {
    editingBookId.value = null;
    titleController.clear();
    descriptionController.clear();
    clearPickedFile();
  }

  // Opens the sheet in "Edit" mode, pre-filled with the existing book.
  // The PDF file is kept as-is unless the admin picks a new one.
  void startEdit(BookResource book) {
    editingBookId.value = book.id;
    titleController.text = book.title;
    descriptionController.text = book.description;
    pickedFileName.value = '';
    pickedFilePath.value = '';
    pickedFileSize.value = '';
  }

  void saveBook() {
    final title = titleController.text.trim();
    final editingId = editingBookId.value;

    // A new PDF is required when adding; when editing, the existing PDF
    // stays unless the admin picks a replacement.
    if (title.isEmpty || (editingId == null && !hasPickedFile)) {
      Get.snackbar(
        'Missing info',
        'Add a title and choose a PDF first.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (editingId != null) {
      final existing = books.firstWhereOrNull((b) => b.id == editingId);
      if (existing == null) return;
      _repo.updateBook(
        existing.copyWith(
          title: title,
          description: descriptionController.text.trim(),
          fileName: hasPickedFile ? pickedFileName.value : null,
          filePath: hasPickedFile ? pickedFilePath.value : null,
          fileSizeLabel: hasPickedFile ? pickedFileSize.value : null,
        ),
      );
      Get.back();
      Get.snackbar(
        'Updated',
        'Changes are now visible to students.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF16A34A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } else {
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

    titleController.clear();
    descriptionController.clear();
    clearPickedFile();
    editingBookId.value = null;
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
