import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/models/book_resource.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../controller/student_books_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class StudentBooksScreen extends StatelessWidget {
  const StudentBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentBooksController());

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      child: Obx(() {
        // CHECKING BOOK ACCESS
        if (controller.isCheckingBookAccess.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryBlue,
            ),
          );
        }

        // BOOK ACCESS NOT GRANTED
        if (!controller.bookAccess.value) {
          return _buildBookAccessPendingScreen(
            controller,
            context,
          );
        }

        // BOOK ACCESS GRANTED
        return _buildBooksContent(
          controller,
          context,
        );
      }),
    );
  }

  // PHONE CALL

  Future<void> _makePhoneCall() async {
    const phone = '9851001970';

    final uri = Uri.parse('tel:$phone');

    if (!await launchUrl(uri)) {
      debugPrint('Could not launch dialer');
    }
  }

  // WHATSAPP

  Future<void> _openWhatsApp() async {
    const phone = '9779851001970';

    const message =
        'Hi, I would like to request Books access.';

    final uri = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint('Could not launch WhatsApp');
    }
  }

  // FACEBOOK

  Future<void> _openFacebook() async {
    final uri = Uri.parse(
      'https://www.facebook.com/nibangshconsultancy',
    );

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint('Could not launch Facebook');
    }
  }

  // CONTACT ICON BUTTON

  Widget _contactIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }

  // BOOK ACCESS PENDING SCREEN

  Widget _buildBookAccessPendingScreen(
    StudentBooksController controller,
    BuildContext context,
  ) {
    return RefreshIndicator(
      onRefresh: controller.refreshBookAccess,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                children: [
                  _buildHeader(
                    controller,
                    context,
                  ),

                  ResponsiveWrapper(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(
                          24,
                          30,
                          24,
                          20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.borderGrey,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.menu_book_rounded,
                                size: 40,
                                color:
                                    AppColors.primaryBlue,
                              ),
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              'Books Access Pending',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              'Your Books access has not been granted yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textGrey,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              'Please wait for an administrator to approve your access.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textGrey,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 24),

                            Obx(() {
                              final refreshing = controller
                                  .isRefreshingBookAccess
                                  .value;

                              return OutlinedButton.icon(
                                onPressed: refreshing
                                    ? null
                                    : controller
                                        .refreshBookAccess,
                                icon: refreshing
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons
                                            .refresh_rounded,
                                      ),
                                label: Text(
                                  refreshing
                                      ? 'Checking...'
                                      : 'Check Again',
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                style:
                                    OutlinedButton.styleFrom(
                                  foregroundColor:
                                      AppColors.primaryBlue,
                                  side: const BorderSide(
                                    color:
                                        AppColors.primaryBlue,
                                  ),
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                      12,
                                    ),
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                _contactIconButton(
                                  icon: Icons.call_rounded,
                                  color:
                                      AppColors.primaryBlue,
                                  onTap: _makePhoneCall,
                                ),
                                const SizedBox(width: 14),
                                _contactIconButton(
                                  icon: Icons.chat_rounded,
                                  color:
                                      const Color(0xFF25D366),
                                  onTap: _openWhatsApp,
                                ),
                                const SizedBox(width: 14),
                                _contactIconButton(
                                  icon:
                                      Icons.facebook_rounded,
                                  color:
                                      const Color(0xFF1877F2),
                                  onTap: _openFacebook,
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            const Text(
                              'This page checks automatically for admin approval.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // BOOKS CONTENT

  Widget _buildBooksContent(
    StudentBooksController controller,
    BuildContext context,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(
                controller,
                context,
              ),

              ResponsiveWrapper(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 100,
                  ),
                  child: _buildBookList(controller),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // HEADER

  Widget _buildHeader(
    StudentBooksController controller,
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Books & Resources',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Shared by your consultancy',
                      style: TextStyle(
                        color:
                            Colors.white.withOpacity(0.85),
                        fontSize: 14.5,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () => Get.toNamed(
                  AppRoute.studentNotifications,
                ),
                child: Stack(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(0.16),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons
                            .notifications_none_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color:
                              AppColors.primaryRed,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                AppColors.navyDark,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.16),
              borderRadius:
                  BorderRadius.circular(14),
              border: Border.all(
                color:
                    Colors.white.withOpacity(0.2),
              ),
            ),
            child: TextField(
              controller:
                  controller.searchController,
              onChanged:
                  controller.onSearchChanged,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.5,
              ),
              decoration: InputDecoration(
                hintText: 'Search books...',
                hintStyle: TextStyle(
                  color:
                      Colors.white.withOpacity(0.75),
                  fontSize: 15.5,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color:
                      Colors.white.withOpacity(0.85),
                  size: 21,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BOOK LIST

  Widget _buildBookList(
    StudentBooksController controller,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final books =
            controller.filteredBooks;

        // LOADING

        if (controller.isLoadingBooks.value) {
          return const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 60,
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlue,
              ),
            ),
          );
        }

        // ERROR

        if (controller.bookError.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 60,
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 44,
                    color: AppColors.primaryRed
                        .withOpacity(0.7),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Could not load books',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    controller.bookError.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 18),

                  ElevatedButton.icon(
                    onPressed:
                        controller.refreshBooks,
                    icon: const Icon(
                      Icons.refresh_rounded,
                    ),
                    label:
                        const Text('Try Again'),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primaryBlue,
                      foregroundColor:
                          Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // EMPTY

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
                    size: 44,
                    color: AppColors.textGrey
                        .withOpacity(0.4),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'No books available',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Your consultancy will post study materials here.',
                    textAlign: TextAlign.center,
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

        // BOOKS

        return Column(
          children: books
              .map(
                (book) => _bookCard(book),
              )
              .toList(),
        );
      }),
    );
  }

  // BOOK CARD

  Widget _bookCard(BookResource book) {
    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderGrey,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset:
                const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // BOOK ICON

          Container(
            width: 48,
            height: 48,
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
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          // BOOK INFORMATION

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        AppColors.textDark,
                  ),
                ),

                // AUTHOR
                if (book.author.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'By ${book.author}',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color:
                          AppColors.textGrey,
                    ),
                  ),
                ],

                // DESCRIPTION
                if (book.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    book.description,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color:
                          AppColors.textGrey,
                      height: 1.35,
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // ACTION BUTTONS

                Row(
                  children: [
                    Expanded(
                      child:
                          OutlinedButton.icon(
                        onPressed:
                            book.pdfUrl.isEmpty
                                ? null
                                : () =>
                                    _viewBook(book),
                        icon: const Icon(
                          Icons
                              .visibility_outlined,
                          size: 16,
                        ),
                        label: const Text(
                          'View',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                        style:
                            OutlinedButton
                                .styleFrom(
                          foregroundColor:
                              AppColors
                                  .primaryBlue,
                          side:
                              const BorderSide(
                            color: AppColors
                                .primaryBlue,
                          ),
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 9,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child:
                          ElevatedButton.icon(
                        onPressed:
                            book.pdfUrl.isEmpty
                                ? null
                                : () =>
                                    _downloadBook(
                                      book,
                                    ),
                        icon: const Icon(
                          Icons
                              .download_rounded,
                          size: 16,
                        ),
                        label: const Text(
                          'Download',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              AppColors
                                  .primaryBlue,
                          foregroundColor:
                              Colors.white,
                          elevation: 0,
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 9,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // VIEW BOOK

  Future<void> _viewBook(
    BookResource book,
  ) async {
    try {
      if (book.pdfUrl.isEmpty) {
        Get.snackbar(
          'PDF unavailable',
          'This book does not have a PDF file.',
          snackPosition:
              SnackPosition.BOTTOM,
        );
        return;
      }

      final uri =
          Uri.parse(book.pdfUrl);

      debugPrint(
        'OPENING BOOK: ${book.pdfUrl}',
      );

      final launched =
          await launchUrl(
        uri,
        mode:
            LaunchMode.externalApplication,
      );

      if (!launched) {
        Get.snackbar(
          'Unable to open PDF',
          'Could not open ${book.title}.',
          snackPosition:
              SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint(
        'VIEW BOOK ERROR: $e',
      );

      Get.snackbar(
        'Error',
        'Could not open this book.',
        snackPosition:
            SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // DOWNLOAD BOOK
  // ============================================================
  //
  // IMPORTANT:
  // For this step we open the remote PDF URL.
  //
  // We are NOT using OpenFile.open() here because the Django
  // "pdf" field is a remote URL, not a local phone file.
  //
  // Actual file downloading can be added after the API is
  // confirmed working.
  // ============================================================

  Future<void> _downloadBook(
    BookResource book,
  ) async {
    try {
      if (book.pdfUrl.isEmpty) {
        Get.snackbar(
          'PDF unavailable',
          'This book does not have a PDF file.',
          snackPosition:
              SnackPosition.BOTTOM,
        );
        return;
      }

      final uri =
          Uri.parse(book.pdfUrl);

      debugPrint(
        'OPENING PDF FOR DOWNLOAD: ${book.pdfUrl}',
      );

      final launched =
          await launchUrl(
        uri,
        mode:
            LaunchMode.externalApplication,
      );

      if (!launched) {
        Get.snackbar(
          'Unable to open PDF',
          'Could not open ${book.title}.',
          snackPosition:
              SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint(
        'DOWNLOAD BOOK ERROR: $e',
      );

      Get.snackbar(
        'Error',
        'Could not open this book.',
        snackPosition:
            SnackPosition.BOTTOM,
      );
    }
  }
}