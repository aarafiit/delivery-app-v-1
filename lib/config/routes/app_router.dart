import 'package:delivery_app/features/cart/presentation/screens/all_carts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/providers/auth_redirect_provider.dart';
import '../../features/auth/presentation/screens/auth_gateway_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/phone_login_screen.dart';
import '../../features/cart/presentation/screens/checkout_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/products/presentation/screens/product_details_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/help_support_screen.dart';
import '../../features/profile/presentation/screens/saved_addresses_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

/// List of routes that require authentication.
/// 
/// Requirements: 27.1, 27.2, 27.3, 27.4, 27.5, 34.6
const List<String> _protectedRoutes = [
  '/home/cart',
  '/home/checkout',
  '/home/profile/edit',
  '/home/profile/saved-addresses',
];

/// Creates the application router with route guard.
/// 
/// The route guard checks authentication status before allowing navigation
/// to protected routes. If unauthenticated, redirects to auth gateway and
/// stores the intended destination.
/// 
/// Requirements: 27.8, 34.1, 34.2, 34.3, 34.4, 34.5, 34.6
GoRouter createAppRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (BuildContext context, GoRouterState state) {
      final intendedRoute = state.matchedLocation;
      
      // Skip redirect for auth-related routes
      if (intendedRoute == AppRoutes.splash ||
          intendedRoute == AppRoutes.authGateway ||
          intendedRoute == AppRoutes.phoneLogin ||
          intendedRoute == AppRoutes.otpVerification ||
          intendedRoute == AppRoutes.login) {
        return null;
      }

      // Check if route is protected
      final isProtectedRoute = _protectedRoutes.any(
        (route) => intendedRoute.startsWith(route),
      );

      if (isProtectedRoute) {
        // Get auth state
        final authState = ref.read(authProvider);
        
        return authState.when(
          data: (state) {
            // If not authenticated, redirect to auth gateway
            if (!state.isAuthenticated) {
              // Store intended route for post-auth redirect
              ref.read(authRedirectProvider.notifier).setIntendedRoute(intendedRoute);
              return AppRoutes.authGateway;
            }
            // Allow navigation if authenticated
            return null;
          },
          loading: () => null, // Allow navigation while loading
          error: (_, __) => null, // Allow navigation on error
        );
      }

      return null; // Allow navigation for non-protected routes
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.authGateway,
        name: AppRoutes.authGatewayName,
        builder: (context, state) => const AuthGatewayScreen(),
      ),
      GoRoute(
        path: AppRoutes.phoneLogin,
        name: AppRoutes.phoneLoginName,
        builder: (context, state) => const PhoneLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        name: AppRoutes.otpVerificationName,
        builder: (context, state) {
          final phoneNumber = state.extra as String;
          return OtpVerificationScreen(phoneNumber: phoneNumber);
        },
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
          GoRoute(
            path: 'cart',
            name: AppRoutes.cartDetailName,
            builder: (context, state) => const AllCartsScreen(),
          ),
          GoRoute(
            path: 'checkout',
            name: AppRoutes.checkoutName,
            builder: (context, state) => const CheckoutScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}

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
