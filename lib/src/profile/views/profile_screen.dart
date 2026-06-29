import 'package:flutter/material.dart';
import '../../../common/util/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Profile Screen — Coming Soon',
          style: TextStyle(fontSize: 16, color: AppColors.textGrey),
        ),
      ),
    );
  }
}