import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class McqInstructionsScreen extends StatelessWidget {
  const McqInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizSet quizSet = Get.arguments as QuizSet;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(quizSet),
            ResponsiveWrapper(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'सुरु गर्नु अघि',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'कृपया निर्देशनहरू ध्यानपूर्वक पढ्नुहोस्।',
                      style: TextStyle(fontSize: 18.5, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 20),
                    _instructionTile(
                      icon: Icons.timer_outlined,
                      color: AppColors.primaryBlue,
                      title: 'समय सीमा',
                      description: 'यो सेट पूरा गर्न तपाईंलाई ५० मिनेट समय हुनेछ।',
                    ),
                    _instructionTile(
                      icon: Icons.flag_outlined,
                      color: AppColors.primaryRed,
                      title: 'क्विज सकाउने तरिका',
                      description:
                      'सबै ${quizSet.totalQuestions} प्रश्न${quizSet.totalQuestions == 1 ? '' : 'हरू'} उत्तर दिएपछि "समाप्त गर्नुहोस्" थिच्नुहोस्।',
                    ),
                    _instructionTile(
                      icon: Icons.hourglass_bottom_rounded,
                      color: AppColors.darkBlue,
                      title: 'समय सकिएमा',
                      description: 'समय सकिए क्विज स्वतः रोकिन्छ र तपाईंको नतिजा देखिन्छ।',
                    ),
                    _instructionTile(
                      icon: Icons.touch_app_outlined,
                      color: AppColors.navyLight,
                      title: 'प्रश्नहरूको उत्तर दिने तरिका',
                      description: '"अघिल्लो" र "अर्को" ले सर्नुहोस्। उत्तर जुनसुकै बेला बदल्न सकिन्छ।',
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Get.offNamed(AppRoute.mcqQuiz, arguments: quizSet),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('जारी राख्नुहोस्', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(QuizSet quizSet) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDark, AppColors.navyLight],
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
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quizSet.title,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'नियम र शर्तहरू',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _instructionTile({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 17, color: AppColors.textGrey, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}