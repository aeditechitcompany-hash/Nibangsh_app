import 'package:flutter/material.dart';

import '../../../common/util/app_colors.dart';

class DocsScreen extends StatefulWidget {
  const DocsScreen({super.key});

  @override
  State<DocsScreen> createState() => _DocsScreenState();
}

class _DocsScreenState extends State<DocsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Docs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Docs Screen — Coming Soon',
          style: TextStyle(fontSize: 16, color: AppColors.textGrey),
        ),
      ),
    );
  }
}
