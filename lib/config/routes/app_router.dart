import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/products/presentation/screens/product_details_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/help_support_screen.dart';
import '../../features/profile/presentation/screens/saved_addresses_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

/// Application router.
///
/// Profile sub-screens (Edit, Addresses, Help) are nested under /home so that
/// GoRouter maintains a proper navigation stack and the device back button
/// returns to the previous screen instead of exiting the app.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: (BuildContext context, GoRouterState state) => null,
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
    // /home is the shell — sub-routes are pushed on top of it so the
    // back button correctly pops back to HomeScreen (Account tab).
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.homeName,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'profile/edit',
          name: AppRoutes.editProfileName,
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: 'profile/saved-addresses',
          name: AppRoutes.savedAddressesName,
          builder: (context, state) => const SavedAddressesScreen(),
        ),
        GoRoute(
          path: 'profile/help-support',
          name: AppRoutes.helpSupportName,
          builder: (context, state) => const HelpSupportScreen(),
        ),
        GoRoute(
          path: 'product/:id',
          name: AppRoutes.productDetailsName,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return ProductDetailsScreen(productId: id);
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);

// ---------------------------------------------------------------------------
// 404 / fallback screen
// ---------------------------------------------------------------------------

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
