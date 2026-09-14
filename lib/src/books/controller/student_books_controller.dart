import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/api_services/api_constants.dart';
import '../../../common/api_services/api_service.dart';
import '../../../common/models/book_resource.dart';
import '../../../common/services/books_repository.dart';

class StudentBooksController extends GetxController {
  final ApiService _apiService = const ApiService();

  final BooksRepository _repo = BooksRepository.to;

  final searchController = TextEditingController();

  final query = ''.obs;

  // ============================================================
  // BOOK ACCESS
  // ============================================================

  final RxBool bookAccess = false.obs;

  final RxBool isCheckingBookAccess = true.obs;

  final RxBool isRefreshingBookAccess = false.obs;

  // ============================================================
  // BOOK LOADING
  // ============================================================

  final RxBool isLoadingBooks = false.obs;

  final RxString bookError = ''.obs;



  // ============================================================
  // BOOKS
  // ============================================================

  List<BookResource> get books => _repo.books;

  List<BookResource> get filteredBooks {
    final q = query.value.trim().toLowerCase();

    if (q.isEmpty) {
      return books;
    }

    return books.where((book) {
      return book.title.toLowerCase().contains(q) ||
          book.author.toLowerCase().contains(q) ||
          book.description.toLowerCase().contains(q);
    }).toList();
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    checkBookAccess(showLoading: true);

  }

  // ============================================================
  // ACCESS POLLING
  // ============================================================


  // ============================================================
  // CHECK BOOK ACCESS
  // ============================================================

  Future<void> checkBookAccess({
    bool showLoading = false,
  }) async {
    try {
      if (showLoading) {
        isCheckingBookAccess.value = true;
      }

      final response = await _apiService.get(
        url: ApiConstants.myMcqAccess,
      );

      debugPrint('================================');
      debugPrint('BOOK ACCESS CHECK');
      debugPrint('Response: $response');
      debugPrint('================================');

      // Only update the access value when we successfully
      // receive a valid response from the backend.
      if (response is Map<String, dynamic>) {
        final access =
            response["book_access"] == true;

        bookAccess.value = access;

        debugPrint(
          'BOOK ACCESS VALUE: ${bookAccess.value}',
        );

        // If access is available, load books.
        if (access) {
          await loadBooks();
        }
      } else if (response is Map) {
        // Handles Map<dynamic, dynamic> safely.
        final access =
            response["book_access"] == true;

        bookAccess.value = access;

        debugPrint(
          'BOOK ACCESS VALUE: ${bookAccess.value}',
        );

        if (access) {
          await loadBooks();
        }
      }
    } catch (e) {
      debugPrint('================================');
      debugPrint('BOOK ACCESS CHECK ERROR');
      debugPrint(e.toString());
      debugPrint('================================');

      // IMPORTANT:
      // Do NOT set:
      //
      // bookAccess.value = false;
      //
      // A network/DNS/server error does NOT mean
      // that the student has no access.
      //
      // Keep the previous valid access value.
    } finally {
      if (showLoading) {
        isCheckingBookAccess.value = false;
      }
    }
  }

  // ============================================================
  // LOAD BOOKS
  // ============================================================

  Future<void> loadBooks() async {
    try {
      isLoadingBooks.value = true;
      bookError.value = '';

      await _repo.loadBooks();

      // Repository may have an error.
      if (_repo.errorMessage.value.isNotEmpty) {
        bookError.value =
            _repo.errorMessage.value;
      }
    } catch (e) {
      debugPrint('================================');
      debugPrint('LOAD BOOKS ERROR');
      debugPrint(e.toString());
      debugPrint('================================');

      bookError.value =
      'Could not load books.';
    } finally {
      isLoadingBooks.value = false;
    }
  }

  // ============================================================
  // REFRESH BOOK ACCESS + BOOKS
  // ============================================================

  Future<void> refreshBookAccess() async {
    if (isRefreshingBookAccess.value) {
      return;
    }

    isRefreshingBookAccess.value = true;

    try {
      await checkBookAccess(
        showLoading: false,
      );
    } finally {
      isRefreshingBookAccess.value = false;
    }
  }

  // ============================================================
  // REFRESH BOOKS
  // ============================================================

  Future<void> refreshBooks() async {
    if (!bookAccess.value) {
      await checkBookAccess(
        showLoading: false,
      );
      return;
    }

    await loadBooks();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void onSearchChanged(String value) {
    query.value = value;
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  void onClose() {


    searchController.dispose();

    super.onClose();
  }
}