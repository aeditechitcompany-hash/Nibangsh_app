import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
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
          return _buildCheckingScreen();
        }

        // BOOK ACCESS NOT GRANTED

        if (!controller.bookAccess.value) {
          return _buildBookAccessPendingScreen(controller);
        }

        // BOOK ACCESS GRANTED

        return _buildBooksContent(controller, context);
      }),
    );
  }

  // WHATSAPP LAUNCH
  Future<void> _openWhatsApp() async {
    const phone = '9779851001970'; // country code + number
    const message = 'Hi, I would like to request Books access.';
    final uri = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch WhatsApp');
    }
  }

  // CHECKING SCREEN

  Widget _buildCheckingScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppColors.primaryBlue,
            ),
            SizedBox(height: 16),
            Text(
              'Checking Books access...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BOOK ACCESS PENDING

  Widget _buildBookAccessPendingScreen(
    StudentBooksController controller,
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
                  // Keep the same Books header
                  // even when access is pending.
                  _buildHeader(controller, context),

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
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.borderGrey,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // ICON

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
                                color: AppColors.primaryBlue,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // TITLE
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

                            // DESCRIPTION
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

                            // CHECK AGAIN BUTTON
                            Obx(() {
                              final refreshing =
                                  controller.isRefreshingBookAccess.value;

                              return OutlinedButton.icon(
                                onPressed: refreshing
                                    ? null
                                    : controller.refreshBookAccess,
                                icon: refreshing
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.refresh_rounded,
                                      ),
                                label: Text(
                                  refreshing
                                      ? 'Checking...'
                                      : 'Check Again',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      AppColors.primaryBlue,
                                  side: const BorderSide(
                                    color: AppColors.primaryBlue,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 12),

                            TextButton.icon(
                              onPressed: _openWhatsApp,
                              icon: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: Color(0xFF25D366),
                                size: 18,
                              ),
                              label: const Text(
                                'Ask on WhatsApp: 9851001970',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF25D366),
                                ),
                              ),
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

  // NORMAL BOOKS CONTENT

  Widget _buildBooksContent(
    StudentBooksController controller,
    BuildContext context,
  ) {
    return LayoutBuilder(
      builder: (context, outerConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: outerConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(controller, context),

                  Expanded(
                    child: ResponsiveWrapper(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            _buildBookList(controller),

                            const SizedBox(height: 100),
                          ],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: Colors.white.withOpacity(0.85),
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
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
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
                          color: AppColors.primaryRed,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.navyDark,
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

          // Search bar only appears when access is granted.
          if (controller.bookAccess.value)
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                ),
                decoration: InputDecoration(
                  hintText: 'Search books...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 15.5,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.85),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final books = controller.filteredBooks;

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
                    color:
                        AppColors.textGrey.withOpacity(0.4),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'No books shared yet',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Your consultancy will post study materials here',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderGrey,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              color: AppColors.primaryRed,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

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
                  const SizedBox(height: 3),

                  Text(
                    book.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 10),

                Row(
                  children: [
                    // VIEW
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            OpenFile.open(book.filePath),
                        icon: const Icon(
                          Icons.visibility_outlined,
                          size: 16,
                        ),
                        label: const Text(
                          'View',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              AppColors.primaryBlue,
                          side: const BorderSide(
                            color: AppColors.primaryBlue,
                          ),
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // DOWNLOAD
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            OpenFile.open(book.filePath),
                        icon: const Icon(
                          Icons.download_rounded,
                          size: 16,
                        ),
                        label: const Text(
                          'Download',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          elevation: 0,
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
}