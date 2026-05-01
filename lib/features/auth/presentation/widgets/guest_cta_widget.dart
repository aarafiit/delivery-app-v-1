import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';

/// Reusable "Continue as Guest" button with secondary styling.
///
/// Features:
/// - White outlined button style
/// - Secondary/ghost appearance
/// - Consistent with design system
/// - Used on Auth Gateway screen
///
/// Requirements: 28.4
class GuestCtaWidget extends StatelessWidget {
  const GuestCtaWidget({
    super.key,
    required this.onTap,
  });

  /// Callback when the button is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(
          color: AppColors.divider,
          width: 1.5,
        ),
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.smAll,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.xl,
        ),
        minimumSize: const Size(double.infinity, 48),
      ),
      child: Text(
        'Continue as Guest',
        style: AppTextStyles.button.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
