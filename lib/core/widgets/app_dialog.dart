import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

/// Utility class for showing standardized dialogs across the app.
///
/// Usage:
/// ```dart
/// final confirmed = await AppDialog.showConfirmDialog(
///   context: context,
///   title: 'Delete item?',
///   message: 'This action cannot be undone.',
/// );
/// ```
class AppDialog {
  AppDialog._();

  /// Shows a confirmation dialog with confirm and cancel actions.
  ///
  /// Returns `true` if the user confirms, `false` otherwise.
  static Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        title: Text(title, style: AppTextStyles.heading2),
        content: Text(message, style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              cancelLabel,
              style: AppTextStyles.button.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              confirmLabel,
              style: AppTextStyles.button.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Shows an error dialog with a single dismiss action.
  static Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String dismissLabel = 'OK',
  }) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        title: Text(title, style: AppTextStyles.heading2),
        content: Text(message, style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              dismissLabel,
              style: AppTextStyles.button.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
