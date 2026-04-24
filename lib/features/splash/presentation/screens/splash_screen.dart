import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';

/// Splash screen displayed on app launch.
///
/// Shows the app logo and name, then navigates to the Login screen
/// after a 2-second delay. (Requirements 10.1, 10.4)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.goNamed(AppRoutes.loginName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delivery_dining,
              size: 80,
              color: AppColors.textOnPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              'DeliveryApp',
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.textOnPrimary,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fast. Fresh. Delivered.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textOnPrimary.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
