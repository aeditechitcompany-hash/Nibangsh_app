import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nibangsh_consultancy/const/resources.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final String image;
  final IconData icon;
  final List<Color> gradientColors;

  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.icon,
    required this.gradientColors,
  });
}

final List<OnboardingData> onboardingPages = [
  OnboardingData(
    title: 'About Us',
    subtitle: 'Trusted Consultancy',
    description:
    'We are Nepal\'s most trusted educational consultancy, guiding students to their dream universities around the world with expert counseling and support.',
    image: AppResources.onboarding1,
    icon: Icons.verified_rounded,
    gradientColors: [AppColors.darkBlue, AppColors.navyLight],
  ),
  OnboardingData(
    title: 'Explore Countries',
    subtitle: 'Countries',
    description:
    'Discover top study destinations including the USA, UK, Australia, Canada, Japan, and more. We help you choose the right country and university for your future.',
    image: AppResources.onboarding2,
    icon: Icons.public_rounded,
    gradientColors: [AppColors.navyLight, AppColors.darkBlue],
  ),
  OnboardingData(
    title: 'Join Nibangsh',
    subtitle: 'Join to Nibangsh',
    description:
    'Become part of the Nibangsh family. Create your account today and take the first step toward your global education journey with us by your side.',
    image: AppResources.logoPath,
    icon: Icons.group_rounded,
    gradientColors: [AppColors.darkBlue, AppColors.navyLight],
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingPages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final page = onboardingPages[index];
              return _buildPage(page, size, context);
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
                      fontSize: 16,
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
              padding: EdgeInsets.fromLTRB(
                28,
                size.height < 640 ? 12 : 24,
                28,
                size.height < 640 ? 20 : 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  SizedBox(height: size.height < 640 ? 14 : 28),

                  // Next / Get Started button
                  SizedBox(
                    width: double.infinity,
                    height: size.height < 640 ? 46 : 54,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.navyLight,
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
                          fontSize: 18.5,
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
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.offAllNamed(AppRoute.login),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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

  Widget _buildPage(OnboardingData page, Size size, BuildContext context) {
    final isShort = size.height < 640;
    final imageSize = context.responsive(
      mobile: isShort ? 96.0 : 160.0,
      tablet: 190.0,
      laptop: 210.0,
      desktop: 220.0,
    );
    final subtitleSize = context.responsive(
      mobile: isShort ? 22.0 : 30.0,
      tablet: 32.0,
      laptop: 34.0,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: page.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: SingleChildScrollView(
            // Reserve space so content never sits under the bottom controls
            padding: EdgeInsets.only(bottom: isShort ? 150 : 210),
            child: Column(
              children: [
                SizedBox(height: isShort ? 20 : 60),

                // Big image in circle
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        blurRadius: 28,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      page.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(page.icon, color: Colors.white, size: 76),
                    ),
                  ),
                ),

                SizedBox(height: isShort ? 24 : 48),

                // Subtitle
                Text(
                  page.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: subtitleSize,
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
                    fontSize: 16.5,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
