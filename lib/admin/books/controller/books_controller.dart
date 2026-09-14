import 'dart:io';
import 'package:file_picker/file_picker.dart';import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/api_services/api_constants.dart';
import '../../../common/api_services/api_service.dart';
import '../../../common/models/book_resource.dart';
import '../../../common/services/books_repository.dart';

class AdminBooksController extends GetxController {
  final BooksRepository _repo = BooksRepository.to;
  final ApiService _api = const ApiService();

  List<BookResource> get books => _repo.books;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final authorController = TextEditingController();

  final pickedFileName = ''.obs;
  final pickedFilePath = ''.obs;
  final pickedFileSize = ''.obs;

  final isPicking = false.obs;

  // ID of the book currently being edited.
  final editingBookId = Rxn<String>();

  bool get isEditing => editingBookId.value != null;

  bool get hasPickedFile =>
      pickedFilePath.value.isNotEmpty;

  // PICK PDF

  Future<void> pickPdf() async {
    isPicking.value = true;

    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (file == null) {
        return;
      }

      final filePath = file.path;

      if (filePath == null) {
        return;
      }

      pickedFileName.value = file.name;
      pickedFilePath.value = file.path!;

      if (filePath == null || filePath.isEmpty) {
        pickedFileSize.value = '';
      } else {
        final selectedFile = File(filePath);
        final sizeBytes = await selectedFile.length();
        pickedFileSize.value = _formatSize(sizeBytes);
      }    } catch (e) {
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

  // CLEAR SELECTED PDF

  void clearPickedFile() {
    pickedFileName.value = '';
    pickedFilePath.value = '';
    pickedFileSize.value = '';
  }

  // FILE SIZE

  String _formatSize(int bytes) {
    if (bytes <= 0) {
      return '';
    }

    final kb = bytes / 1024;

    if (kb < 1024) {
      return '${kb.toStringAsFixed(0)} KB';
    }

    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }

  // START ADD

  void startAdd() {
    editingBookId.value = null;

    titleController.clear();
    authorController.clear();
    descriptionController.clear();

    clearPickedFile();
  }

  // START EDIT

  void startEdit(BookResource book) {
    editingBookId.value = book.id;

    titleController.text = book.title;
    authorController.text = book.author;
    descriptionController.text = book.description;

    // Don't automatically put the remote PDF URL into
    // pickedFilePath.
    //
    // If the admin wants to replace the PDF, they can select
    // another file.
    pickedFileName.value = '';
    pickedFilePath.value = '';
    pickedFileSize.value = '';
  }

  // SAVE BOOK

  void saveBook() {
    final title = titleController.text.trim();
    final author = authorController.text.trim();
    final description =
        descriptionController.text.trim();

    final editingId = editingBookId.value;

    // New book requires a PDF.
    //
    // During editing, the existing PDF can remain unchanged.
    if (title.isEmpty ||
        (editingId == null && !hasPickedFile)) {
      Get.snackbar(
        'Missing info',
        'Add a title and choose a PDF first.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      return;
    }

    // EDIT EXISTING BOOK

    if (editingId != null) {
      final existing =
          books.firstWhereOrNull(
        (book) => book.id == editingId,
      );

      if (existing == null) {
        Get.snackbar(
          'Error',
          'The selected book could not be found.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );

        return;
      }

      final updatedBook = existing.copyWith(
        title: title,
        author: author,
        description: description,

        // If a new PDF was selected, temporarily use the
        // selected local path as pdfUrl.
        //
        // This will be replaced by the Django upload URL
        // once the multipart upload is connected.
        pdfUrl: hasPickedFile
            ? pickedFilePath.value
            : null,

        fileName: hasPickedFile
            ? pickedFileName.value
            : null,

        fileSizeLabel: hasPickedFile
            ? pickedFileSize.value
            : null,
      );

      _repo.updateBook(updatedBook);

      Get.back();

      Get.snackbar(
        'Updated',
        'Book details have been updated.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor:
            const Color(0xFF16A34A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }

    // ADD NEW BOOK

    else {
      final newBook = BookResource(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),

        title: title,

        author: author,

        description: description,

        coverUrl: '',

        // Temporary local path.
        //
        // Django upload will replace this with the actual
        // /media/books/pdfs/... URL.
        pdfUrl: pickedFilePath.value,

        fileName: pickedFileName.value,

        fileSizeLabel: pickedFileSize.value,

        uploadedAt: DateTime.now(),
      );

      _repo.addBook(newBook);

      Get.back();

      Get.snackbar(
        'Added',
        'Book has been added to the library.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor:
            const Color(0xFF16A34A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }

    _clearForm();
  }

  // DELETE BOOK

  void deleteBook(String id) {
    _repo.removeBook(id);

    Get.snackbar(
      'Removed',
      'Book removed from the library.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  // CLEAR FORM

  void _clearForm() {
    titleController.clear();
    authorController.clear();
    descriptionController.clear();

    clearPickedFile();

    editingBookId.value = null;
  }

  // CLOSE

  @override
  void onClose() {
    titleController.dispose();
    authorController.dispose();
    descriptionController.dispose();

    super.onClose();
  }
  @override
  void onInit() {
    super.onInit();
    loadBooks();
  }

  Future<void> loadBooks() async {
    try {
      final response = await _api.get(
        url: ApiConstants.books,
      );

      debugPrint('========== ADMIN BOOKS ==========');
      debugPrint('$response');
      debugPrint('=================================');

      if (response is List) {
        final books = response
            .map(
              (json) => BookResource.fromJson(
            Map<String, dynamic>.from(json),
          ),
        )
            .toList();

        _repo.setBooks(books);
      }
    } catch (e) {
      debugPrint('LOAD ADMIN BOOKS ERROR: $e');

      Get.snackbar(
        'Error',
        'Could not load books from server.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
