import 'package:get/get.dart';
import '../models/book_resource.dart';

// Shared store for admin-uploaded book/resource PDFs, so the list an admin
// adds to instantly shows up on the student's Books screen.
//
// NOTE: this is in-memory/local, matching the rest of this app's mock data
// (no backend yet). It works great for demoing on one device/simulator. To
// make books actually appear on a *different* student's phone than the one
// the admin uploaded from, the file itself needs to live somewhere both
// devices can reach (e.g. Firebase Storage, S3, or your own server) with
// this repository fetching/caching the list from there instead.
class BooksRepository extends GetxService {
  static BooksRepository get to =>
      Get.isRegistered<BooksRepository>()
          ? Get.find<BooksRepository>()
          : Get.put(BooksRepository(), permanent: true);

  final books = <BookResource>[].obs;

  void addBook(BookResource book) => books.insert(0, book);

  void removeBook(String id) => books.removeWhere((b) => b.id == id);
}