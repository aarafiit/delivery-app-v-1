import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';

/// Home screen placeholder.
///
/// Confirms the scaffold is wired correctly. Business logic will be
/// added in future feature tasks. (Requirements 10.3)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text('Scaffold is working!', style: AppTextStyles.heading2),
            SizedBox(height: 8),
            Text(
              'Welcome to DeliveryApp',
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}
