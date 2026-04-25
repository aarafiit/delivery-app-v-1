import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../categories/presentation/screens/categories_screen.dart';
import '../../../products/presentation/screens/products_screen.dart';
import '../../../profile/presentation/screens/account_screen.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../providers/bottom_nav_provider.dart';
import '../widgets/bottom_nav_widget.dart';

/// Home shell screen.
///
/// Owns the [BottomNavWidget], an [IndexedStack] of 5 tab screens,
/// and a floating cart button with item count badge. (Requirements 14.2, 14.3, 17.1, 17.3, 23.2)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _tabs = <Widget>[
    ProductsScreen(),
    CategoriesScreen(),
    SearchScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: const BottomNavWidget(),
      floatingActionButton: _CartFab(
        itemCount: 0, // static for now — wired to cart provider later
        onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 3,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// ---------------------------------------------------------------------------
// Private: Floating cart button with badge
// ---------------------------------------------------------------------------

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
