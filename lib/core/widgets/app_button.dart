import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../config/theme/app_radius.dart';
import '../../config/theme/app_spacing.dart';

/// Button variant enum.
enum AppButtonVariant {
  /// Filled orange background — primary CTA.
  primary,

  /// Outlined with primary color border — secondary action.
  secondary,

  /// Outlined with red border — destructive action (e.g. Log Out).
  danger,
}

/// A reusable button widget with primary, secondary, and danger variants.
///
/// All variants provide immediate visual ripple feedback via Material ink.
/// (Requirements 23.1, 23.5)
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final double? width;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final button = _buildButton();
    if (width != null) {
      return SizedBox(width: width, child: button);
    }
    return button;
  }

  Widget _buildButton() {
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            disabledBackgroundColor: AppColors.disabled,
            disabledForegroundColor: AppColors.disabledText,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.smAll,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.xl,
            ),
          ),
          child: _buildChild(AppColors.textOnPrimary),
        );

      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.smAll,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.xl,
            ),
          ),
          child: _buildChild(AppColors.primary),
        );

      case AppButtonVariant.danger:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error, width: 1.5),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.smAll,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.xl,
            ),
          ),
          child: _buildChild(AppColors.error),
        );
    }
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: color),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTextStyles.button.copyWith(color: color)),
        ],
      );
    }
    return Text(label, style: AppTextStyles.button.copyWith(color: color));
  }
}
