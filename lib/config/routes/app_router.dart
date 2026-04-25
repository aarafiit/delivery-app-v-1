import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/help_support_screen.dart';
import '../../features/profile/presentation/screens/saved_addresses_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

/// Application router.
///
/// Defines all named routes and a redirect guard stub.
/// The guard always returns `null` (no redirect) for now; authentication
/// checks will be wired in once the auth feature is complete.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: (BuildContext context, GoRouterState state) {
    // Auth guard stub — always returns null (no redirect) for now.
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splashName,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.loginName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.homeName,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      name: AppRoutes.editProfileName,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.savedAddresses,
      name: AppRoutes.savedAddressesName,
      builder: (context, state) => const SavedAddressesScreen(),
    ),
    GoRoute(
      path: AppRoutes.helpSupport,
      name: AppRoutes.helpSupportName,
      builder: (context, state) => const HelpSupportScreen(),
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);

// ---------------------------------------------------------------------------
// 404 / fallback screen (Requirements 4.4)
// ---------------------------------------------------------------------------

/// Displayed when an unknown route is accessed.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '404',
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('The page you are looking for does not exist.'),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => context.goNamed(AppRoutes.splashName),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
