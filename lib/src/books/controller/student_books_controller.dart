import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/models/book_resource.dart';
import '../../../common/services/books_repository.dart';

class StudentBooksController extends GetxController {
  final BooksRepository _repo = BooksRepository.to;
  final searchController = TextEditingController();
  final query = ''.obs;

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
