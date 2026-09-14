import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/models/book_resource.dart';
import '../../../common/services/books_repository.dart';

class AdminBooksController extends GetxController {
  // ============================================================
  // REPOSITORY
  // ============================================================

  final BooksRepository _repo = BooksRepository.to;

  // ============================================================
  // BOOKS
  // ============================================================

  List<BookResource> get books => _repo.books;

  // ============================================================
  // FORM CONTROLLERS
  // ============================================================

  final titleController = TextEditingController();

  final descriptionController =
  TextEditingController();

  final authorController =
  TextEditingController();

  // ============================================================
  // PDF PICKER
  // ============================================================

  final pickedFileName = ''.obs;

  final pickedFilePath = ''.obs;

  final pickedFileSize = ''.obs;

  final isPicking = false.obs;

  // ============================================================
  // LOADING
  // ============================================================

  final isSaving = false.obs;

  final isLoading = false.obs;

  // ============================================================
  // EDITING
  // ============================================================

  final editingBookId = Rxn<String>();

  bool get isEditing =>
      editingBookId.value != null;

  bool get hasPickedFile =>
      pickedFilePath.value.isNotEmpty;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    loadBooks();
  }

  // ============================================================
  // LOAD BOOKS
  // ============================================================

  Future<void> loadBooks() async {
    try {
      isLoading.value = true;

      final loadedBooks =
      await _repo.loadBooks();

      debugPrint(
        '====================================',
      );

      debugPrint(
        'ADMIN BOOKS LOADED: ${loadedBooks.length}',
      );

      debugPrint(
        '====================================',
      );
    } catch (e) {
      debugPrint(
        'LOAD ADMIN BOOKS ERROR: $e',
      );

      Get.snackbar(
        'Error',
        'Could not load books from server.',
        snackPosition:
        SnackPosition.BOTTOM,
        margin:
        const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // PICK PDF
  // ============================================================

  Future<void> pickPdf() async {
    if (isPicking.value) {
      return;
    }

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

      if (filePath == null || filePath.isEmpty) {
        Get.snackbar(
          'Error',
          'Could not access the selected PDF.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );

        return;
      }

      pickedFileName.value = file.name;
      pickedFilePath.value = filePath;

      final selectedFile = File(filePath);

      if (await selectedFile.exists()) {
        final sizeBytes = await selectedFile.length();

        pickedFileSize.value =
            _formatSize(sizeBytes);
      } else {
        pickedFileSize.value = '';
      }

      debugPrint('========== PDF SELECTED ==========');
      debugPrint('NAME: ${pickedFileName.value}');
      debugPrint('PATH: ${pickedFilePath.value}');
      debugPrint('SIZE: ${pickedFileSize.value}');
      debugPrint('==================================');
    } catch (e) {
      debugPrint('PDF PICKER ERROR: $e');

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

  // ============================================================
  // CLEAR PICKED FILE
  // ============================================================

  void clearPickedFile() {
    pickedFileName.value = '';

    pickedFilePath.value = '';

    pickedFileSize.value = '';
  }

  // ============================================================
  // FORMAT FILE SIZE
  // ============================================================

  String _formatSize(int bytes) {
    if (bytes <= 0) {
      return '';
    }

    final kb = bytes / 1024;

    if (kb < 1024) {
      return '${kb.toStringAsFixed(0)} KB';
    }

    final mb = kb / 1024;

    if (mb < 1024) {
      return '${mb.toStringAsFixed(1)} MB';
    }

    final gb = mb / 1024;

    return '${gb.toStringAsFixed(2)} GB';
  }

  // ============================================================
  // START ADD
  // ============================================================

  void startAdd() {
    editingBookId.value = null;

    titleController.clear();

    authorController.clear();

    descriptionController.clear();

    clearPickedFile();
  }

  // ============================================================
  // START EDIT
  // ============================================================

  void startEdit(
      BookResource book,
      ) {
    editingBookId.value =
        book.id;

    titleController.text =
        book.title;

    authorController.text =
        book.author;

    descriptionController.text =
        book.description;

    // Do NOT put remote URL into pickedFilePath.
    //
    // pickedFilePath is only for a newly
    // selected local PDF.

    clearPickedFile();
  }

  // ============================================================
  // SAVE BOOK
  // ============================================================

  Future<void> saveBook() async {
    if (isSaving.value) {
      return;
    }

    final title =
    titleController.text.trim();

    final author =
    authorController.text.trim();

    final description =
    descriptionController.text.trim();

    final editingId =
        editingBookId.value;

    // ----------------------------------------------------------
    // VALIDATION
    // ----------------------------------------------------------

    if (title.isEmpty) {
      Get.snackbar(
        'Missing information',
        'Please enter a book title.',
        snackPosition:
        SnackPosition.BOTTOM,
        margin:
        const EdgeInsets.all(16),
      );

      return;
    }

    // New books require PDF.
    if (editingId == null &&
        !hasPickedFile) {
      Get.snackbar(
        'Missing PDF',
        'Please choose a PDF file.',
        snackPosition:
        SnackPosition.BOTTOM,
        margin:
        const EdgeInsets.all(16),
      );

      return;
    }

    try {
      isSaving.value = true;

      // ========================================================
      // EDIT EXISTING BOOK
      // ========================================================

      if (editingId != null) {
        final existing =
        books.firstWhereOrNull(
              (book) =>
          book.id == editingId,
        );

        if (existing == null) {
          throw Exception(
            'The selected book could not be found.',
          );
        }

        /*
         * IMPORTANT:
         *
         * At this stage, updateBook() only
         * updates local GetX state.
         *
         * We are NOT pretending that the PDF
         * has been uploaded to Django yet.
         */

        final updatedBook =
        existing.copyWith(
          title: title,
          author: author,
          description: description,

          // Keep existing PDF unless
          // a new PDF was selected.
          pdfUrl: hasPickedFile
              ? pickedFilePath.value
              : null,

          fileName: hasPickedFile
              ? pickedFileName.value
              : null,

          fileSizeLabel:
          hasPickedFile
              ? pickedFileSize.value
              : null,
        );

        _repo.updateBook(
          updatedBook,
        );

        Get.back();

        Get.snackbar(
          'Updated',
          'Book details have been updated.',
          snackPosition:
          SnackPosition.BOTTOM,
          backgroundColor:
          const Color(0xFF16A34A),
          colorText: Colors.white,
          margin:
          const EdgeInsets.all(16),
        );
      }

      // ========================================================
      // ADD NEW BOOK
      // ========================================================

      else {
        final newBook =
        BookResource(
          id: DateTime.now()
              .millisecondsSinceEpoch
              .toString(),

          title: title,

          author: author,

          description: description,

          coverUrl: '',

          pdfUrl:
          pickedFilePath.value,

          fileName:
          pickedFileName.value,

          fileSizeLabel:
          pickedFileSize.value,

          uploadedAt:
          DateTime.now(),
        );

        _repo.addBook(
          newBook,
        );

        Get.back();

        Get.snackbar(
          'Added',
          'Book has been added to the library.',
          snackPosition:
          SnackPosition.BOTTOM,
          backgroundColor:
          const Color(0xFF16A34A),
          colorText: Colors.white,
          margin:
          const EdgeInsets.all(16),
        );
      }

      _clearForm();
    } catch (e) {
      debugPrint(
        'SAVE BOOK ERROR: $e',
      );

      Get.snackbar(
        'Error',
        'Could not save the book.',
        snackPosition:
        SnackPosition.BOTTOM,
        margin:
        const EdgeInsets.all(16),
      );
    } finally {
      isSaving.value = false;
    }
  }

  // ============================================================
  // DELETE BOOK
  // ============================================================

  Future<void> deleteBook(
      String id,
      ) async {
    if (id.isEmpty) {
      return;
    }

    try {
      isLoading.value = true;

      await _repo.deleteBook(id);

      Get.snackbar(
        'Deleted',
        'Book deleted successfully.',
        snackPosition:
        SnackPosition.BOTTOM,
        margin:
        const EdgeInsets.all(16),
      );
    } catch (e) {
      debugPrint(
        'DELETE BOOK ERROR: $e',
      );

      Get.snackbar(
        'Error',
        'Could not delete the book.',
        snackPosition:
        SnackPosition.BOTTOM,
        margin:
        const EdgeInsets.all(16),
      );

      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CLEAR FORM
  // ============================================================

  void _clearForm() {
    titleController.clear();

    authorController.clear();

    descriptionController.clear();

    clearPickedFile();

    editingBookId.value = null;
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  void onClose() {
    titleController.dispose();

    authorController.dispose();

    descriptionController.dispose();

    super.onClose();
  }
}