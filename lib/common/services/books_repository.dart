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

  final ApiService _api = const ApiService();

  final books = <BookResource>[].obs;

  final errorMessage = ''.obs;

  // ============================================================
  // LOCAL STATE
  // ============================================================

  void setBooks(List<BookResource> value) {
    books.assignAll(value);
  }

  void addBook(BookResource book) {
    books.add(book);
  }

  void updateBook(BookResource book) {
    final index = books.indexWhere(
          (item) => item.id == book.id,
    );

    if (index != -1) {
      books[index] = book;
    }
  }

  void removeBook(String id) {
    books.removeWhere(
          (book) => book.id == id,
    );
  }

  // ============================================================
  // FETCH BOOKS FROM SERVER
  // ============================================================

  Future<List<BookResource>> loadBooks() async {
    try {
      errorMessage.value = '';

      final response = await _api.get(
        url: ApiConstants.books,
      );

      List<dynamic> rawBooks = [];

      if (response is List) {
        rawBooks = response;
      } else if (response is Map &&
          response['results'] is List) {
        rawBooks = response['results'] as List;
      }

      final loadedBooks = rawBooks
          .map(
            (json) => BookResource.fromJson(
          Map<String, dynamic>.from(json),
        ),
      )
          .toList();

      setBooks(loadedBooks);

      return loadedBooks;
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    }
  }

  // Keep this alias too, so existing code using fetchBooks()
  // continues to work.
  Future<List<BookResource>> fetchBooks() async {
    return loadBooks();
  }

  // ============================================================
  // DELETE BOOK FROM SERVER
  // ============================================================

  Future<void> deleteBook(String id) async {
    if (id.isEmpty) {
      throw Exception('Book ID is missing.');
    }

    await _api.delete(
      url: '${ApiConstants.books}$id/',
      authenticated: true,
    );

    removeBook(id);
  }

  // ============================================================
  // LOCAL HELPERS
  // ============================================================

  void addBookLocal(BookResource book) {
    addBook(book);
  }

  void updateBookLocal(BookResource book) {
    updateBook(book);
  }

  void removeBookLocal(String id) {
    removeBook(id);
  }
}