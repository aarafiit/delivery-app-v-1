import 'package:flutter/material.dart';
import 'package:delivery_app/config/theme/app_colors.dart';
import 'package:delivery_app/config/theme/app_radius.dart';
import 'package:delivery_app/config/theme/app_shadows.dart';
import 'package:delivery_app/config/theme/app_spacing.dart';

/// Elevated white card widget for authentication screens.
/// 
/// Provides a premium elevated card with consistent styling:
/// - White background
/// - Medium shadow for depth
/// - Large border radius for modern look
/// - Configurable padding (defaults to xxl)
/// 
/// Usage:
/// ```dart
/// AuthCard(
///   child: Column(
///     children: [
///       Text('Sign in'),
///       TextField(),
///     ],
///   ),
/// )
/// ```
class AuthCard extends StatelessWidget {
  /// The widget to display inside the card
  final Widget child;

  /// Optional custom padding. Defaults to AppSpacing.xxl on all sides.
  final EdgeInsets? padding;

  const AuthCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: padding ?? const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.authCardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.medium,
      ),
      child: child,
    );
  }
}
