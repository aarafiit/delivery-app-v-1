import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

/// A centered loading indicator widget.
///
/// Displays a [CircularProgressIndicator] centered within its parent.
/// Optionally accepts a custom [color] and [size].
class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.color,
    this.size = 36.0,
  });

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color ?? AppColors.primary,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
