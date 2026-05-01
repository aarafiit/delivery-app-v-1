import 'package:flutter/material.dart';
import 'package:delivery_app/config/theme/app_colors.dart';

/// Reusable gradient background widget for authentication screens.
/// 
/// Displays a soft lavender-to-plum gradient from top to bottom,
/// providing a premium visual experience for auth flows.
/// 
/// Usage:
/// ```dart
/// AuthGradientBackground(
///   child: YourAuthScreen(),
/// )
/// ```
class AuthGradientBackground extends StatelessWidget {
  /// The widget to display on top of the gradient background
  final Widget child;

  const AuthGradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.authGradientStart,
            AppColors.authGradientEnd,
          ],
        ),
      ),
      child: child,
    );
  }
}
