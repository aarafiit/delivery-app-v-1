import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../cart/presentation/screens/all_carts_screen.dart';
import '../../../categories/presentation/screens/categories_screen.dart';
import '../../../products/presentation/screens/products_screen.dart';
import '../../../profile/presentation/screens/account_screen.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../providers/bottom_nav_provider.dart';
import '../widgets/bottom_nav_widget.dart';

/// Home shell screen.
/// Cart tab (index 3) shows [AllCartsScreen].
/// The FAB pushes the cart detail screen as a named route.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static final _tabs = <Widget>[
    const ProductsScreen(),
    const CategoriesScreen(),
    const SearchScreen(),
    const AllCartsScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _tabs),
      bottomNavigationBar: const BottomNavWidget(),
      floatingActionButton: _CartFab(
        itemCount: ref.watch(cartItemCountProvider),
        onTap: () => context.pushNamed(AppRoutes.cartDetailName),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _CartFab extends StatelessWidget {
  const _CartFab({required this.itemCount, required this.onTap});
  final int itemCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        FloatingActionButton(
          onPressed: onTap,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 4,
          child: const Icon(Icons.shopping_cart_outlined, size: 26),
        ),
        if (itemCount > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              child: Text(
                itemCount > 99 ? '99+' : '$itemCount',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textOnPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
