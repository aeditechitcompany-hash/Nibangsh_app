import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/api_services/api_service.dart';
import '../../../common/api_services/api_constants.dart';
import '../../../common/models/book_resource.dart';
import '../../../common/services/books_repository.dart';

class StudentBooksController extends GetxController {
  final ApiService _apiService = const ApiService();

  final RxBool bookAccess = false.obs;
  final RxBool isCheckingBookAccess = true.obs;
  final RxBool isRefreshingBookAccess = false.obs;

  final BooksRepository _repo = BooksRepository.to;
  final searchController = TextEditingController();
  final query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkBookAccess();
  }

  Future<void> checkBookAccess() async {
    try {
      isCheckingBookAccess.value = true;

      final response = await _apiService.get(
        url: ApiConstants.myMcqAccess,
      );

      bookAccess.value = response["book_access"] == true;

      print("================================");
      print("BOOK ACCESS CHECK");
      print("Response: $response");
      print("Book Access: ${bookAccess.value}");
      print("================================");
    } catch (e) {
      print("BOOK ACCESS CHECK ERROR");
      print(e);

      // Fail closed.
      bookAccess.value = false;
    } finally {
      isCheckingBookAccess.value = false;
    }
  }

  Future<void> refreshBookAccess() async {
    try {
      isRefreshingBookAccess.value = true;

      await checkBookAccess();

      // If access was granted, reload books as well.
      if (bookAccess.value) {
        // Call whatever method your controller currently uses
        // to load/reload books.
        //
        // Example:
        // await loadBooks();
      }
    } finally {
      isRefreshingBookAccess.value = false;
    }
  }

  List<BookResource> get books => _repo.books;

  List<BookResource> get filteredBooks {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return books;
    return books
        .where(
          (b) =>
              b.title.toLowerCase().contains(q) ||
              b.description.toLowerCase().contains(q),
        )
        .toList();
  }

  void onSearchChanged(String value) => query.value = value;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
