import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/app_routes.dart';
import '../../config/theme/app_colors.dart';

/// Dialog shown when the user's session has expired.
/// 
/// Forces the user to log in again to continue using the app.
/// Cannot be dismissed by tapping outside or pressing back button.
/// 
/// Requirements: JWT Auth Upgrade Phase 5, Task 14
class SessionExpiredDialog extends StatelessWidget {
  const SessionExpiredDialog({super.key});

  /// Shows the session expired dialog.
  /// 
  /// The dialog is non-dismissible and requires the user to tap the login button.
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Cannot dismiss by tapping outside
      builder: (context) => const SessionExpiredDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents back button from dismissing
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.access_time_outlined,
              color: AppColors.warning,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text('Session Expired'),
          ],
        ),
        content: const Text(
          'Your session has expired. Please log in again to continue.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.goNamed(AppRoutes.authGatewayName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
