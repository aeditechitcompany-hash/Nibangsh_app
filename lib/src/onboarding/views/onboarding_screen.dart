import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';

class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final Color topColor;
  final Color bottomColor;

  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.topColor,
    required this.bottomColor,
  });
}

const List<OnboardingData> onboardingPages = [
  OnboardingData(
    title: 'About Us',
    subtitle: 'Trusted Consultancy',
    description:
    'We are Nepal\'s most trusted educational consultancy, guiding students to their dream universities around the world with expert counseling and support.',
    imagePath: 'assets/images/logo.png',
    topColor: Color(0xFFD32F2F),
    bottomColor: Color(0xFF0D47A1),
  ),
  OnboardingData(
    title: 'Explore Countries',
    subtitle: 'Countries',
    description:
    'Discover top study destinations including the USA, UK, Australia, Canada, Japan, and more. We help you choose the right country and university for your future.',
    imagePath: 'assets/images/world.png',
    topColor:  Color(0xFF0D47A1),
    bottomColor:Color(0xFFD32F2F),
  ),
  OnboardingData(
    title: 'Join Nibangsh',
    subtitle: 'Join to Nibangsh',
    description:
    'Become part of the Nibangsh family. Create your account today and take the first step toward your global education journey with us by your side.',
    imagePath: 'assets/images/ni2.png',
    topColor: Color(0xFFD32F2F),
    bottomColor: Color(0xFF0D47A1),
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(AppRoute.signup);
    }
  }

  void _skip() {
    Get.offAllNamed(AppRoute.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Smooth Gradient Background (animated based on page scroll)
          AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double page = _currentPage.toDouble();
              if (_pageController.position.haveDimensions) {
                page = _pageController.page ?? _currentPage.toDouble();
              }

              final int currentIndex = page.floor().clamp(0, onboardingPages.length - 1);
              final int nextIndex = (currentIndex + 1 < onboardingPages.length)
                  ? currentIndex + 1
                  : currentIndex;
              final double transitionProgress = (page - currentIndex).clamp(0.0, 1.0);

              final Color currentTopColor = onboardingPages[currentIndex].topColor;
              final Color nextTopColor = onboardingPages[nextIndex].topColor;
              final Color interpolatedTopColor =
                  Color.lerp(currentTopColor, nextTopColor, transitionProgress) ??
                      currentTopColor;

              final Color currentBottomColor = onboardingPages[currentIndex].bottomColor;
              final Color nextBottomColor = onboardingPages[nextIndex].bottomColor;
              final Color interpolatedBottomColor =
                  Color.lerp(currentBottomColor, nextBottomColor, transitionProgress) ??
                      currentBottomColor;

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.3, 0.7],
                    colors: [interpolatedTopColor, interpolatedBottomColor],
                  ),
                ),
              );
            },
          ),

          // PageView for Content
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingPages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final page = onboardingPages[index];
              return _buildPageContent(page);
            },
          ),

          // Skip button top right
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 16),
                child: TextButton(
                  onPressed: _skip,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
              child: Column(
                children: [
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingPages.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 28 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Next / Get Started button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black26,
                      ),
                      child: Text(
                        _currentPage == onboardingPages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sign In link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.offAllNamed(AppRoute.login),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(OnboardingData page) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 60),

            // Circular Image Container
            Container(
              height: 180,
              width: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  page.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.withOpacity(0.3),
                    child: const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 48),

            // Slide number badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.4)),
              ),
              child: Text(
                page.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Subtitle
            Text(
              page.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              page.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 14.5,
                height: 1.6,
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}