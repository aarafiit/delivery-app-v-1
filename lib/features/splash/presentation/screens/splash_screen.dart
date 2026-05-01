import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Splash screen displayed on app launch.
///
/// Shows the app logo and name, then checks authentication state and navigates
/// to either Home (if authenticated) or Auth Gateway (if not authenticated).
/// Requirements: 10.1, 10.4, 31.6
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Check authentication state
    final authState = ref.read(authProvider);
    
    authState.when(
      data: (state) {
        if (state.isAuthenticated) {
          // Navigate to Home if authenticated
          context.goNamed(AppRoutes.homeName);
        } else {
          // Navigate to Auth Gateway if not authenticated
          context.goNamed(AppRoutes.authGatewayName);
        }
      },
      loading: () {
        // Navigate to Auth Gateway while loading
        context.goNamed(AppRoutes.authGatewayName);
      },
      error: (_, __) {
        // Navigate to Auth Gateway on error
        context.goNamed(AppRoutes.authGatewayName);
      },
    );
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
