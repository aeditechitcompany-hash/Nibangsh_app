import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/api_services/api_constants.dart';
import '../../../common/models/book_resource.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../../../common/util/responsive.dart';

import '../controller/books_controller.dart';
import 'admin_pdf_viewer_screen.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminBooksController());

    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadSheet(
          context,
          controller,
        ),
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(
          Icons.upload_file_rounded,
          color: Colors.white,
        ),
        label: const Text(
          'Upload PDF',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              controller,
              context,
            ),

            ResponsiveDashboardWrapper(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: _buildBookList(
                  controller,
                  context,
                ),
              ),
            ),

            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
      AdminBooksController controller,
      BuildContext context,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        30,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.navyDark,
            AppColors.navyLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Books & Resources',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Obx(
                        () => Text(
                      '${controller.books.length} PDFs shared with students',
                      style: TextStyle(
                        color:
                        Colors.white.withOpacity(0.75),
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ],
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoute.notifications,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color:
                    Colors.white.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOOK LIST
  // ============================================================

  Widget _buildBookList(
      AdminBooksController controller,
      BuildContext context,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Obx(
            () {
          final books = controller.books;

          if (books.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 60,
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 40,
                      color: AppColors.textGrey
                          .withOpacity(0.4),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    const Text(
                      'No books uploaded yet',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    const Text(
                      'Tap "Upload PDF" to add one for students',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: books
                .map(
                  (book) => _bookCard(
                controller,
                book,
                context,
              ),
            )
                .toList(),
          );
        },
      ),
    );
  }

  // ============================================================
  // BOOK CARD
  // ============================================================

  Widget _bookCard(
      AdminBooksController controller,
      BookResource book,
      BuildContext context,
      ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderGrey,
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // PDF ICON
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryRed
                  .withOpacity(0.1),
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              color: AppColors.primaryRed,
              size: 22,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          // BOOK DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                if (book.description.isNotEmpty) ...[
                  const SizedBox(
                    height: 3,
                  ),

                  Text(
                    book.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                    ),
                    maxLines: 2,
                    overflow:
                    TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(
                  height: 6,
                ),

                Text(
                  book.fileSizeLabel.isEmpty
                      ? book.fileName
                      : '${book.fileName} • ${book.fileSizeLabel}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),

          // ACTION BUTTONS
          Column(
            children: [
              // VIEW
              IconButton(
                onPressed: () {
                  _openBook(book);
                },
                icon: const Icon(
                  Icons.visibility_outlined,
                  color:
                  AppColors.primaryBlue,
                  size: 20,
                ),
                tooltip: 'View',
              ),

              // EDIT
              IconButton(
                onPressed: () {
                  _showUploadSheet(
                    context,
                    controller,
                    editBook: book,
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFFF59E0B),
                  size: 20,
                ),
                tooltip: 'Edit',
              ),

              // DELETE
              IconButton(
                onPressed: () {
                  _confirmDelete(
                    controller,
                    book,
                  );
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color:
                  AppColors.primaryRed,
                  size: 20,
                ),
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONFIRM DELETE
  // ============================================================

  Future<void> _confirmDelete(
      AdminBooksController controller,
      BookResource book,
      ) async {
    final confirmed =
    await Get.dialog<bool>(
      AlertDialog(
        title: const Text(
          'Delete Book',
        ),
        content: Text(
          'Are you sure you want to delete "${book.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(
                result: false,
              );
            },
            child: const Text(
              'Cancel',
            ),
          ),

          ElevatedButton(
            onPressed: () {
              Get.back(
                result: true,
              );
            },
            child: const Text(
              'Delete',
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    try {
      await controller.deleteBook(
        book.id,
      );

      Get.snackbar(
        'Deleted',
        'Book deleted successfully.',
        snackPosition:
        SnackPosition.BOTTOM,
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
      );
    }
  }

  // ============================================================
  // OPEN PDF
  // ============================================================

  void _openBook(
      BookResource book,
      ) {
    if (book.pdfUrl.trim().isEmpty) {
      Get.snackbar(
        'PDF unavailable',
        'This book does not have a PDF file.',
        snackPosition:
        SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      return;
    }

    final pdfUrl =
    ApiConstants.mediaUrl(
      book.pdfUrl,
    );

    debugPrint(
      '====================================',
    );
    debugPrint(
      'OPENING BOOK',
    );
    debugPrint(
      'TITLE: ${book.title}',
    );
    debugPrint(
      'PDF URL: $pdfUrl',
    );
    debugPrint(
      '====================================',
    );

    Get.to(
          () => AdminPdfViewerScreen(
        title: book.title,
        pdfUrl: pdfUrl,
      ),
    );
  }

  // ============================================================
  // UPLOAD / EDIT SHEET
  // ============================================================

  void _showUploadSheet(
      BuildContext context,
      AdminBooksController controller, {
        BookResource? editBook,
      }) {
    // Start editing or adding
    if (editBook != null) {
      controller.startEdit(
        editBook,
      );
    } else {
      controller.startAdd();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight:
        MediaQuery.of(context)
            .size
            .height *
            0.9,
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(
              sheetContext,
            ).viewInsets.bottom,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                20,
              ),
              child: Column(
                mainAxisSize:
                MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // DRAG HANDLE
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin:
                      const EdgeInsets.only(
                        bottom: 18,
                      ),
                      decoration:
                      BoxDecoration(
                        color:
                        AppColors.borderGrey,
                        borderRadius:
                        BorderRadius.circular(
                          4,
                        ),
                      ),
                    ),
                  ),

                  // TITLE
                  Obx(
                        () => Text(
                      controller.isEditing
                          ? 'Edit Book'
                          : 'Upload a Book (PDF)',
                      style:
                      const TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        AppColors.textDark,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // BOOK TITLE
                  TextField(
                    controller:
                    controller.titleController,
                    decoration:
                    InputDecoration(
                      labelText: 'Title',
                      hintText:
                      'e.g. IELTS Preparation Guide',
                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // DESCRIPTION
                  TextField(
                    controller:
                    controller
                        .descriptionController,
                    maxLines: 2,
                    decoration:
                    InputDecoration(
                      labelText:
                      'Description (optional)',
                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  // PDF PICKER
                  Obx(
                        () => InkWell(
                      borderRadius:
                      BorderRadius.circular(
                        14,
                      ),
                      onTap:
                      controller
                          .isPicking
                          .value
                          ? null
                          : controller.pickPdf,
                      child: Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        decoration:
                        BoxDecoration(
                          color:
                          AppColors.background,
                          borderRadius:
                          BorderRadius.circular(
                            14,
                          ),
                          border: Border.all(
                            color:
                            AppColors
                                .borderGrey,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration:
                              BoxDecoration(
                                color: AppColors
                                    .primaryRed
                                    .withOpacity(
                                  0.1,
                                ),
                                shape:
                                BoxShape.circle,
                              ),
                              child:
                              const Icon(
                                Icons
                                    .picture_as_pdf_rounded,
                                color:
                                AppColors
                                    .primaryRed,
                                size: 18,
                              ),
                            ),

                            const SizedBox(
                              width: 12,
                            ),

                            Expanded(
                              child: Text(
                                controller
                                    .hasPickedFile
                                    ? '${controller.pickedFileName.value} (${controller.pickedFileSize.value})'
                                    : controller
                                    .isPicking
                                    .value
                                    ? 'Opening file picker...'
                                    : controller
                                    .isEditing
                                    ? 'Keep current PDF (tap to replace)'
                                    : 'Choose a PDF file',
                                style:
                                const TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.w600,
                                  color:
                                  AppColors
                                      .textDark,
                                ),
                                overflow:
                                TextOverflow
                                    .ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                      controller.saveBook,
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        AppColors
                            .primaryBlue,
                        foregroundColor:
                        Colors.white,
                        padding:
                        const EdgeInsets
                            .symmetric(
                          vertical: 14,
                        ),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Obx(
                            () => Text(
                          controller.isEditing
                              ? 'Save Changes'
                              : 'Upload & Share',
                          style:
                          const TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}