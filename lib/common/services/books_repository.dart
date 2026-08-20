import 'package:get/get.dart';

import '../api_services/api_constants.dart';
import '../api_services/api_service.dart';
import '../models/book_resource.dart';

class BooksRepository extends GetxService {
  static BooksRepository get to =>
      Get.isRegistered<BooksRepository>()
          ? Get.find<BooksRepository>()
          : Get.put(
              BooksRepository(),
              permanent: true,
            );

  final ApiService _apiService =
      const ApiService();

  final books = <BookResource>[].obs;

  final isLoading = false.obs;

  final errorMessage = ''.obs;

  // LOAD BOOKS FROM DJANGO

  Future<void> loadBooks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.get(
        url: ApiConstants.books,
      );

      print('================================');
      print('BOOKS API RESPONSE');
      print(response);
      print('================================');

      if (response is List) {
        final loadedBooks = response
            .map(
              (item) => BookResource.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();

        books.assignAll(loadedBooks);
      } else if (response is Map &&
          response['results'] is List) {
        final loadedBooks =
            (response['results'] as List)
                .map(
                  (item) => BookResource.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList();

        books.assignAll(loadedBooks);
      } else {
        throw Exception(
          'Unexpected books API response.',
        );
      }
    } catch (e) {
      print('================================');
      print('BOOKS API ERROR');
      print(e);
      print('================================');

      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // REFRESH

  Future<void> refreshBooks() async {
    await loadBooks();
  }

  // ============================================================
  // LOCAL ADD
  // ============================================================
  //
  // IMPORTANT:
  // This method currently only updates the local GetX store.
  //
  // We will replace this with Django multipart upload next.
  //

  void addBook(BookResource book) {
    books.insert(0, book);
  }

  // LOCAL UPDATE

  void updateBook(BookResource updated) {
    final index = books.indexWhere(
      (book) => book.id == updated.id,
    );

    if (index != -1) {
      books[index] = updated;
      books.refresh();
    }
  }

  // LOCAL DELETE

  void removeBook(String id) {
    books.removeWhere(
      (book) => book.id == id,
    );
  }
}