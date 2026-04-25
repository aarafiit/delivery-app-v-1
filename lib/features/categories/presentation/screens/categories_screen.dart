import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_shadows.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/category_icon_mapper.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/shimmer_loader_widget.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../../domain/entities/category_entity.dart';
import '../providers/categories_provider.dart';

/// Full Categories screen.
///
/// Shows a sticky horizontal chip row of all active categories.
/// Selecting a chip fetches and displays that category's products.
/// Reuses [ProductCard] for consistent product presentation.
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key, this.initialCategoryId});

  /// When navigated from "See All" on the home screen, pre-select a category.
  final int? initialCategoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading2,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            color: AppColors.textSecondary,
            onPressed: () {},
          ),
        ],
      ),
      body: categoriesAsync.when(
        loading: () => const _CategoriesLoadingSkeleton(),
        error: (error, _) => EmptyStateWidget(
          icon: Icons.wifi_off_outlined,
          heading: 'Could not load categories',
          subtext: error is Exception
              ? error.toString().replaceFirst('Exception: ', '')
              : 'Something went wrong.',
          actionLabel: 'Retry',
          onAction: () => ref.invalidate(categoriesProvider),
        ),
        data: (categories) {
          if (categories.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.category_outlined,
              heading: 'No categories',
              subtext: 'Categories will appear here once available.',
            );
          }
          return _CategoriesBody(
            categories: categories,
            initialCategoryId: initialCategoryId,
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body — chip row + product grid
// ---------------------------------------------------------------------------

class _CategoriesBody extends ConsumerStatefulWidget {
  const _CategoriesBody({
    required this.categories,
    this.initialCategoryId,
  });

  final List<CategoryEntity> categories;
  final int? initialCategoryId;

  @override
  ConsumerState<_CategoriesBody> createState() => _CategoriesBodyState();
}

class _CategoriesBodyState extends ConsumerState<_CategoriesBody> {
  late final ScrollController _chipScrollController;

  @override
  void initState() {
    super.initState();
    _chipScrollController = ScrollController();

    // Auto-select: prefer initialCategoryId, otherwise first category
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current = ref.read(selectedCategoryProvider);
      if (current == null) {
        final target = widget.initialCategoryId != null
            ? widget.categories.firstWhere(
                (c) => c.id == widget.initialCategoryId,
                orElse: () => widget.categories.first,
              )
            : widget.categories.first;
        ref.read(selectedCategoryProvider.notifier).state = target;
      }
    });
  }

  @override
  void dispose() {
    _chipScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedCategoryProvider);

    return Column(
      children: [
        // ── Sticky chip row ──────────────────────────────────────────────
        Container(
          color: AppColors.surface,
          child: Column(
            children: [
              SizedBox(
                height: 52,
                child: ListView.builder(
                  controller: _chipScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: widget.categories.length,
                  itemBuilder: (context, index) {
                    final category = widget.categories[index];
                    final isSelected = selected?.id == category.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: _CategoryChip(
                        category: category,
                        isSelected: isSelected,
                        onTap: () {
                          ref.read(selectedCategoryProvider.notifier).state =
                              category;
                        },
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1, thickness: 1),
            ],
          ),
        ),

        // ── Product grid ─────────────────────────────────────────────────
        Expanded(
          child: selected == null
              ? const SizedBox.shrink()
              : _ProductGrid(categoryId: selected.id),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Category chip
// ---------------------------------------------------------------------------

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = CategoryIconMapper.iconFor(category.iconKey);
    final color = CategoryIconMapper.colorFor(category.iconKey);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
            borderRadius: AppRadius.fullAll,
            boxShadow: isSelected ? AppShadows.low : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? AppColors.textOnPrimary
                    : HSLColor.fromColor(color)
                        .withLightness(0.35)
                        .withSaturation(0.7)
                        .toColor(),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                category.name,
                style: AppTextStyles.label.copyWith(
                  color: isSelected
                      ? AppColors.textOnPrimary
                      : AppColors.textPrimary,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Product grid for selected category
// ---------------------------------------------------------------------------

class _ProductGrid extends ConsumerWidget {
  const _ProductGrid({required this.categoryId});

  final int categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByCategoryProvider(categoryId));

    return productsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: AppSpacing.md),
        child: ShimmerCardLoader(itemCount: 6),
      ),
      error: (error, _) => EmptyStateWidget(
        icon: Icons.wifi_off_outlined,
        heading: 'Could not load products',
        subtext: error is Exception
            ? error.toString().replaceFirst('Exception: ', '')
            : 'Something went wrong.',
        actionLabel: 'Retry',
        onAction: () =>
            ref.invalidate(productsByCategoryProvider(categoryId)),
      ),
      data: (products) {
        if (products.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.storefront_outlined,
            heading: 'No products',
            subtext: 'This category has no available products yet.',
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xxxl,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final p = products[index];
            return ProductCard(
              name: p.name,
              price: p.price,
              discountPrice: p.discountPrice,
              imageUrl: p.imageUrl,
              productId: p.id,
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Loading skeleton
// ---------------------------------------------------------------------------

class _CategoriesLoadingSkeleton extends StatelessWidget {
  const _CategoriesLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chip row skeleton
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: List.generate(
              4,
              (i) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ShimmerLoaderWidget(
                  width: 80,
                  height: 36,
                  borderRadius: AppRadius.fullAll,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Expanded(child: ShimmerCardLoader(itemCount: 6)),
      ],
    );
  }
}
