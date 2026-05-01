import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/auth_gradient_background.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header_widget.dart';

/// Auth Gateway Screen - Entry point for authentication.
///
/// Offers two options:
/// 1. Continue with Phone - Navigate to phone login
/// 2. Continue as Guest - Navigate to home in guest mode
///
/// Requirements: 28.1, 28.2, 28.3, 28.4, 28.5, 28.6
class AuthGatewayScreen extends ConsumerWidget {
  const AuthGatewayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    
    return AuthGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.xxxl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Delivery illustration placeholder
                  // TODO: Replace with actual illustration or Lottie animation
                  Semantics(
                    label: 'Delivery service illustration',
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.delivery_dining,
                        size: 100,
                        color: AppColors.navSelected,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  
                  // Hero title and subtitle
                  AuthHeaderWidget(
                    title: l10n.authGatewayTitle,
                    subtitle: '',
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  
                  // Continue with Phone button (Primary - Pink)
                  SizedBox(
                    width: double.infinity,
                    child: Semantics(
                      button: true,
                      label: 'Continue with phone number',
                      hint: 'Navigate to phone login screen',
                      child: ElevatedButton(
                        onPressed: () {
                          context.goNamed(AppRoutes.phoneLoginName);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navSelected,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: AppColors.authPrimary.withOpacity(0.3),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.lg,
                            horizontal: AppSpacing.xl,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.continueWithPhone,
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Continue as Guest button (Secondary - White outlined)
                  SizedBox(
                    width: double.infinity,
                    child: Semantics(
                      button: true,
                      label: 'Continue as guest',
                      hint: 'Browse the app without signing in',
                      child: OutlinedButton(
                        onPressed: () {
                          // Set guest mode
                          ref.read(authProvider.notifier).setGuestMode();
                          // Navigate to home
                          context.goNamed(AppRoutes.homeName);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.authPrimary,
                          side: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                          elevation: 1,
                          shadowColor: Colors.black.withOpacity(0.1),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.lg,
                            horizontal: AppSpacing.xl,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.continueAsGuest,
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.authPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
