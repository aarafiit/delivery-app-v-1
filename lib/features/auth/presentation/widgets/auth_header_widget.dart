import 'package:flutter/material.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_spacing.dart';

/// Reusable header widget for authentication screens.
///
/// Displays a title, subtitle, and optional illustration/image.
/// Used across Auth Gateway, Phone Login, and OTP Verification screens
/// to maintain consistent branding and layout.
///
/// Requirements: 28.2
class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.illustration,
  });

  /// Main heading text (e.g., "Welcome to Delivery App")
  final String title;

  /// Supporting text below the title (e.g., "Sign in to continue")
  final String subtitle;

  /// Optional illustration widget (can be Image, Lottie, or any Widget)
  final Widget? illustration;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (illustration != null) ...[
          illustration!,
          const SizedBox(height: AppSpacing.xl),
        ],
        Semantics(
          header: true,
          child: Text(
            title,
            style: AppTextStyles.heading1,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: AppTextStyles.bodySecondary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
