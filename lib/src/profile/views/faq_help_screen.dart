import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/util/app_colors.dart';
import 'package:nibangsh_consultancy/common/util/responsive.dart';

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem(this.question, this.answer);
}

class FaqHelpScreen extends StatelessWidget {
  const FaqHelpScreen({super.key});

  static const List<_FaqItem> _faqs = [
    _FaqItem(
      'How do I start the study abroad process?',
      'Begin with a free consultation with our counselors. We assess your '
          'academic profile, goals, and budget, then create a personalized '
          'roadmap for your study abroad journey.',
    ),
    _FaqItem(
      'What documents do I need for a student visa?',
      'Requirements vary by country, but typically include a valid '
          'passport, admission letter, financial statements, academic '
          'transcripts, IELTS/language test scores, and a statement of '
          'purpose. Our documentation team guides you through every '
          'requirement.',
    ),
    _FaqItem(
      'How long does the university application process take?',
      'Typically 3\u20136 months from initial consultation to receiving an '
          'offer letter. We recommend starting at least 6\u201312 months '
          'before your intended intake date.',
    ),
    _FaqItem(
      'Do you offer scholarship guidance?',
      'Absolutely! We help identify and apply for scholarships at '
          'universities, government-funded programs (like MEXT, '
          'K-Government, Chevening), and private foundations.',
    ),
    _FaqItem(
      'Which countries do you help with?',
      'We provide guidance for USA, UK, Canada, Australia, Japan, South '
          'Korea, and Europe, with partnerships across 50+ universities.',
    ),
    _FaqItem(
      'What services do you offer?',
      'Study abroad counseling, IELTS preparation, TOPIK preparation, visa '
          'assistance, documentation support, and university selection.',
    ),
    _FaqItem(
      'What is your visa success rate?',
      'We maintain a 95%+ visa approval rate across all major study '
          'destinations we support.',
    ),
  ];

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        _showLaunchError(url);
      }
    } catch (_) {
      _showLaunchError(url);
    }
  }

  void _showLaunchError(String url) {
    Get.snackbar(
      'Unable to Open',
      'Could not open $url. Please check if the required app is installed.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: const Text(
          'FAQ & Help Center',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ResponsiveWrapper(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Quick answers to the questions we get asked most.',
              style: TextStyle(fontSize: 13, color: AppColors.textGrey),
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderGrey),
              ),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: Column(
                  children: List.generate(_faqs.length, (index) {
                    final faq = _faqs[index];
                    return Column(
                      children: [
                        ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                          childrenPadding: const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            16,
                          ),
                          iconColor: AppColors.primaryBlue,
                          collapsedIconColor: AppColors.textGrey,
                          title: Text(
                            faq.question,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                faq.answer,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: AppColors.textGrey,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (index != _faqs.length - 1)
                          const Divider(height: 1, color: AppColors.borderGrey),
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Still need help?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Reach out to us directly \u2014 we\'re happy to help.',
              style: TextStyle(fontSize: 13, color: AppColors.textGrey),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderGrey),
              ),
              child: Column(
                children: [
                  _contactRow(
                    icon: Icons.access_time_rounded,
                    title: 'Office Hours',
                    subtitle: 'Sun \u2013 Fri, 6:00 AM \u2013 6:00 PM',
                  ),
                  const Divider(height: 24, color: AppColors.borderGrey),
                  _contactRow(
                    icon: Icons.call_outlined,
                    title: 'Call Us',
                    subtitle: '01-5929970 / +977 9851001970',
                    onTap: () => _launch('tel:+9779851001970'),
                  ),
                  const Divider(height: 24, color: AppColors.borderGrey),
                  _contactRow(
                    icon: Icons.email_outlined,
                    title: 'Email Us',
                    subtitle: 'info@nibangshconsultancy.com',
                    onTap: () => _launch('mailto:info@nibangshconsultancy.com'),
                  ),
                  const Divider(height: 24, color: AppColors.borderGrey),
                  _contactRow(
                    icon: Icons.chat_outlined,
                    title: 'WhatsApp',
                    subtitle: 'Chat with us instantly',
                    onTap: () => _launch('https://wa.me/+9779851001970'),
                  ),
                  const Divider(height: 24, color: AppColors.borderGrey),
                  _contactRow(
                    icon: Icons.location_on_outlined,
                    title: 'Visit Us',
                    subtitle:
                    'Bagbazar, J.F Restaurant Building, Top Floor, '
                        'Kathmandu, Nepal',
                    onTap: () => _launch(
                      'https://maps.app.goo.gl/1HW7DPGntmG7WvLEA?g_st=ac'
                          '${Uri.encodeComponent('Bagbazar, J.F Restaurant Building, Top Floor, Kathmandu, Nepal')}',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _contactRow({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(Icons.chevron_right_rounded, color: AppColors.textGrey),
        ],
      ),
    );
  }
}
