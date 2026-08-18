import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import '../controller/mcq_home_controller.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class McqHomeScreen extends StatelessWidget {
  const McqHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(McqHomeController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.background,
        child: Obx(() {
          // INITIAL CHECK
          if (controller.isCheckingAccess.value) {
            return _buildCheckingScreen();
          }

          // ACCESS NOT GRANTED
          if (!controller.mcqAccess.value) {
            return _buildWaitingScreen(controller);
          }

          // ACCESS GRANTED
          return _buildMcqContent(controller);
        }),
      ),
    );
  }

  // WHATSAPP LAUNCH
  Future<void> _openWhatsApp() async {
    const phone = '9779851001970'; // country code + number
    const message = 'Hi, I would like to request MCQ access.';
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
              'Checking MCQ access...',
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

  // WAITING FOR ADMIN APPROVAL
  Widget _buildWaitingScreen(
    McqHomeController controller,
  ) {
    return RefreshIndicator(
      onRefresh: controller.refreshAccess,
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
                  _buildHeader(context),

                  ResponsiveWrapper(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.borderGrey,
                          ),
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
                                Icons.lock_clock_rounded,
                                size: 40,
                                color: AppColors.primaryBlue,
                              ),
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              'MCQ Access Pending',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              'Your MCQ access has not been granted yet.',
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
                              final refreshing =
                                  controller.isRefreshingAccess.value;

                              return OutlinedButton.icon(
                                onPressed: refreshing
                                    ? null
                                    : controller.refreshAccess,
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

  // NORMAL MCQ CONTENT
  Widget _buildMcqContent(
    McqHomeController controller,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
            builder: (context) => _buildHeader(context),
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
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _buildBanner(controller),

                  const SizedBox(height: 20),

                  _buildSearchBar(controller),

                  const SizedBox(height: 24),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      'List of Sets',
                      style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  _buildSetList(controller),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // HEADER
  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,

      // This includes the status bar height so the blue
      // gradient goes behind the time / battery area.
      padding: EdgeInsets.fromLTRB(
        20,
        topPadding + 10,
        20,
        40,
      ),

      decoration:  BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.navyDark,
            AppColors.navyLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Quizzes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 4),

              Text(
                'Test what you\'ve learned',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // BANNER
  Widget _buildBanner(
    McqHomeController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Obx(() {
        // ACCESS NOT GRANTED
        if (!controller.mcqAccess.value) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient:  LinearGradient(
                colors: [
                  AppColors.navyLight,
                  AppColors.darkBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white,
                  size: 38,
                ),

                const SizedBox(height: 12),

                const Text(
                  'MCQ Access Pending',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Your MCQ access has not been approved yet.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        }

        final firstSet = controller.firstSet;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient:  LinearGradient(
              colors: [
                AppColors.navyLight,
                AppColors.darkBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                top: -10,
                child: Icon(
                  Icons.emoji_events_rounded,
                  color:
                      Colors.white.withOpacity(0.15),
                  size: 90,
                ),
              ),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Test Your Knowledge\nwith Quizzes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19.5,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Quick multiple-choice sets to check how much you remember.',
                    style: TextStyle(
                      color:
                          Colors.white.withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                        AppRoute.mcqInstructions,
                        arguments: firstSet,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor:
                          AppColors.navyLight,
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Play Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  // SEARCH
  Widget _buildSearchBar(
    McqHomeController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller:
              controller.searchController,
          decoration: const InputDecoration(
            hintText: 'Search sets...',
            hintStyle: TextStyle(
              color: AppColors.textGrey,
              fontSize: 15.5,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.primaryBlue,
              size: 21,
            ),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  // SET LIST
  Widget _buildSetList(
    McqHomeController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Obx(() {
        final sets = controller.filteredSets;

        if (sets.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 40,
            ),
            child: Center(
              child: Text(
                'No MCQ sets available.',
                style: TextStyle(
                  color: AppColors.textGrey,
                ),
              ),
            ),
          );
        }

        return Column(
          children: sets
              .map(
                (set) => _setTile(
                  controller,
                  set,
                ),
              )
              .toList(),
        );
      }),
    );
  }

  // SET TILE
  Widget _setTile(
    McqHomeController controller,
    QuizSet set,
  ) {
    return GestureDetector(
      onTap: () {
        // Extra security check.
        if (!controller.mcqAccess.value) {
          return;
        }

        Get.toNamed(
          AppRoute.mcqInstructions,
          arguments: set,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 12,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.borderGrey,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color:
                    set.color.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                set.icon,
                color: set.color,
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
                    set.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    '${set.totalQuestions} Question${set.totalQuestions == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontSize: 13,
                      color:
                          AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),

            Obx(() {
              final best =
                  controller.bestScoreFor(
                set.id,
              );

              return _scoreRing(
                best,
                set.totalQuestions,
                set.color,
              );
            }),
          ],
        ),
      ),
    );
  }

  // SCORE RING
  Widget _scoreRing(
    int? score,
    int total,
    Color color,
  ) {
    final attempted = score != null;

    final fraction =
        attempted && total > 0
            ? score / total
            : 0.0;

    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              value: attempted
                  ? fraction
                  : 1,
              strokeWidth: 4,
              backgroundColor:
                  AppColors.borderGrey,
              valueColor:
                  AlwaysStoppedAnimation(
                attempted
                    ? color
                    : AppColors.borderGrey,
              ),
            ),
          ),

          attempted
              ? Text(
                  '$score/$total',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        AppColors.textDark,
                  ),
                )
              : Icon(
                  Icons.play_arrow_rounded,
                  color: color,
                  size: 22,
                ),
        ],
      ),
    );
  }
}