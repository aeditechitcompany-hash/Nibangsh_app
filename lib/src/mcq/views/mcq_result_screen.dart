import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/models/quiz_models.dart';
import '../../../common/util/app_colors.dart';
import '../../../common/util/app_route.dart';

class McqResultScreen extends StatelessWidget {
  const McqResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;
    final QuizSet quizSet = args['quizSet'] as QuizSet;
    final int score = args['score'] as int;
    final total = quizSet.totalQuestions;
    final passed = total == 0 ? false : score / total >= 0.6;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Container(
                width: 220,
                height: 220,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(AppColors.primaryBlue, Colors.black, 0.5)!,
                      AppColors.primaryBlue,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: AppColors.primaryBlue.withOpacity(0.3), blurRadius: 30, spreadRadius: 4),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Your Score', style: TextStyle(color: Colors.white70, fontSize: 15)),
                    const SizedBox(height: 6),
                    Text(
                      '$score/$total',
                      style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              Text(
                passed ? 'Congratulations' : 'Keep Practicing',
                style: const TextStyle(color: AppColors.primaryBlue, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                passed ? 'Great job! You did it.' : 'Review the topic and try this set again.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textGrey, fontSize: 13.5),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => Get.snackbar(
                    'Share',
                    'Sharing your result isn\'t wired up yet.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.primaryBlue,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  ),
                  icon: const Icon(Icons.share_outlined, size: 18, color: AppColors.primaryBlue),
                  label: const Text('Share', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Get.until((route) => route.settings.name == AppRoute.home),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}