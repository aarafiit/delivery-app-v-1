import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/shimmer_loader_widget.dart';
import '../../../banners/presentation/providers/banners_provider.dart';
import '../../../categories/presentation/providers/categories_provider.dart';
import '../../../home/presentation/providers/bottom_nav_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_list.dart';
import '../widgets/product_card.dart';

/// Products tab — main discovery screen.
///
/// Fetches products from the API via [productsProvider] and displays:
/// - Shimmer skeleton while loading (Requirements 24.2)
/// - Product grid on success, filtered to available products (Requirements 24.3)
/// - Error empty state on failure (Requirements 24.4)
class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  Future<void> _onRefresh(WidgetRef ref) async {
    // Invalidate products, categories and banners so newly added content
    // appears on pull-to-refresh, then wait for the new data to arrive.
    ref.invalidate(productsProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(bannersProvider);
    await Future.wait([
      ref.read(productsProvider.future),
      ref.read(categoriesProvider.future),
      ref.read(bannersProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final bannersAsync = ref.watch(bannersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => _onRefresh(ref),
        child: CustomScrollView(
          // Always scrollable so pull-to-refresh works even when content is short
          physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ── Pinned AppBar ──────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: AppColors.surface,
            elevation: 0,
            scrolledUnderElevation: 1,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Dhaka, Bangladesh',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryContainer,
                  child: const Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
            // Sticky search bar — tapping it opens the Search tab.
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: _HomeSearchBar(
                  onTap: () =>
                      ref.read(bottomNavIndexProvider.notifier).state = 2,
                ),
              ),
            ),
          ),

          // ── Banner Carousel ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.lg,
                bottom: AppSpacing.sm,
              ),
              child: bannersAsync.when(
                data: (banners) => BannerCarousel(
                  imageUrls: banners.map((b) => b.imageUrl).toList(),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: SizedBox(height: 168, child: ShimmerBannerLoader()),
                ),
                // Banners are non-critical — hide the section on failure.
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
          ),

          // ── Categories ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Categories',
              actionLabel: 'See All',
              onAction: () =>
                  ref.read(bottomNavIndexProvider.notifier).state = 1,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xs,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: CategoryList()),

          // ── Popular Products header ────────────────────────────────────
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Popular Products',
              actionLabel: 'See All',
              onAction: () {},
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xs,
              ),
            ),
          ),

          // ── Product Grid — switches on AsyncValue ─────────────────────
          productsAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: ShimmerCardLoader(itemCount: 6),
              ),
            ),
            error: (error, _) => SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyStateWidget(
                icon: Icons.wifi_off_outlined,
                heading: 'Could not load products',
                subtext: error is Exception
                    ? error.toString().replaceFirst('Exception: ', '')
                    : 'Something went wrong. Please try again.',
                actionLabel: 'Retry',
                onAction: () => ref.invalidate(productsProvider),
              ),
            ),
            data: (products) => products.isEmpty
                ? const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateWidget(
                      icon: Icons.storefront_outlined,
                      heading: 'No products available',
                      subtext: 'Check back soon for new items.',
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.xxxl,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];
                          return ProductCard(
                            name: product.name,
                            price: product.price,
                            discountPrice: product.discountPrice,
                            imageUrl: product.imageUrl,
                            productId: product.id,
                            product: product,
                          );
                        },
                        childCount: products.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.sm,
                        mainAxisSpacing: AppSpacing.sm,
                        childAspectRatio: 0.75,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sticky home search bar
// ---------------------------------------------------------------------------

/// A read-only search field shown in the pinned app bar. Tapping it opens the
/// dedicated Search tab rather than editing inline.
class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: const BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppRadius.smAll,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Search products, categories...',
              style: AppTextStyles.body.copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}
