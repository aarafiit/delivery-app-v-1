import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_shadows.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/shimmer_loader_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_details_provider.dart';

/// Product Details Screen.
///
/// Fetches product data via [productDetailsProvider] using the [productId]
/// passed from the product list. Quantity is managed locally via
/// [productQuantityProvider] — never fetched from the API.
class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(productDetailsProvider(productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: detailsAsync.when(
        loading: () => const _LoadingSkeleton(),
        error: (error, _) => Scaffold(
          appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
          body: EmptyStateWidget(
            icon: Icons.wifi_off_outlined,
            heading: 'Could not load product',
            subtext: error is Exception
                ? error.toString().replaceFirst('Exception: ', '')
                : 'Something went wrong.',
            actionLabel: 'Retry',
            onAction: () => ref.invalidate(productDetailsProvider(productId)),
          ),
        ),
        data: (product) => _ProductDetailsBody(product: product),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main body — shown when data is loaded
// ---------------------------------------------------------------------------

class _ProductDetailsBody extends ConsumerWidget {
  const _ProductDetailsBody({required this.product});

  final ProductEntity product;

  bool get _hasDiscount =>
      product.discountPrice > 0 && product.discountPrice < product.price;

  double get _effectivePrice =>
      _hasDiscount ? product.discountPrice : product.price;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(productQuantityProvider(product.id));

    return Stack(
      children: [
        // ── Scrollable content ─────────────────────────────────────────
        CustomScrollView(
          slivers: [
            // Hero image carousel with back button overlay
            _ProductImageSliver(images: product.galleryImages),

            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.xl),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.lg,
                    // Extra bottom padding so content clears the fixed action bar
                    100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chips row
                      _ChipsRow(isAvailable: product.isAvailable),
                      const SizedBox(height: AppSpacing.md),

                      // Product name
                      Text(product.name, style: AppTextStyles.heading1),
                      const SizedBox(height: AppSpacing.sm),

                      // Price row
                      _PriceRow(
                        effectivePrice: _effectivePrice,
                        originalPrice: product.price,
                        hasDiscount: _hasDiscount,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Mock rating
                      const _RatingRow(),
                      const SizedBox(height: AppSpacing.xl),

                      // Description
                      Text(
                        'Description',
                        style: AppTextStyles.heading3,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        product.description.isNotEmpty
                            ? product.description
                            : 'No description available.',
                        style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // ── Fixed bottom action bar ────────────────────────────────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _BottomActionBar(
            productId: product.id,
            quantity: quantity,
            isAvailable: product.isAvailable,
            onDecrement: () {
              if (quantity > 1) {
                ref.read(productQuantityProvider(product.id).notifier).state =
                    quantity - 1;
              }
            },
            onIncrement: () {
              ref.read(productQuantityProvider(product.id).notifier).state =
                  quantity + 1;
            },
            onAddToCart: () async {
              // Guests add to the local cart; authenticated users also sync to
              // the server (handled inside the cart provider). Sign-in is only
              // forced later, at checkout.
              await ref.read(cartProvider.notifier).addItem(
                    productId: product.id,
                    name: product.name,
                    imageUrl: product.imageUrl,
                    price: product.price,
                    discountPrice: product.discountPrice,
                    quantity: quantity,
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added $quantity × ${product.name} to cart'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.smAll,
                    ),
                    action: SnackBarAction(
                      label: 'View Cart',
                      textColor: AppColors.textOnPrimary,
                      onPressed: () =>
                          context.pushNamed(AppRoutes.cartDetailName),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Hero image carousel sliver with back button overlay
// ---------------------------------------------------------------------------

class _ProductImageSliver extends StatefulWidget {
  const _ProductImageSliver({required this.images});

  /// Up to 3 product images. Falls back to a placeholder when empty.
  final List<String> images;

  @override
  State<_ProductImageSliver> createState() => _ProductImageSliverState();
}

class _ProductImageSliverState extends State<_ProductImageSliver> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    final hasMultiple = images.length > 1;

    return SliverAppBar(
      expandedHeight: 300,
      pinned: false,
      floating: false,
      backgroundColor: AppColors.surfaceVariant,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Swipeable image carousel
            if (images.isEmpty)
              const _ImagePlaceholder()
            else
              PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, index) => Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const ShimmerLoaderWidget(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: BorderRadius.zero,
                    );
                  },
                  errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                ),
              ),
            // Gradient at top for back button legibility
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.45),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Page indicator dots (only when there is more than one image)
            if (hasMultiple)
              Positioned(
                bottom: AppSpacing.lg,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                    (i) => _PageDot(active: i == _currentPage),
                  ),
                ),
              ),
            // Back button
            Positioned(
              top: MediaQuery.of(context).padding.top + AppSpacing.sm,
              left: AppSpacing.md,
              child: _CircleIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            // Favourite button
            Positioned(
              top: MediaQuery.of(context).padding.top + AppSpacing.sm,
              right: AppSpacing.md,
              child: _CircleIconButton(
                icon: Icons.favorite_border_rounded,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated dot used by the image carousel page indicator.
class _PageDot extends StatelessWidget {
  const _PageDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: active ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(4),
        boxShadow: AppShadows.low,
      ),
    );
  }
}

/// Fallback shown when an image is missing or fails to load.
class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 64,
          color: AppColors.textHint,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: AppShadows.low,
        ),
        child: Icon(icon, size: 18, color: AppColors.textPrimary),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info chips row
// ---------------------------------------------------------------------------

class _ChipsRow extends StatelessWidget {
  const _ChipsRow({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        _InfoChip(
          label: isAvailable ? 'In Stock' : 'Out of Stock',
          icon: isAvailable
              ? Icons.check_circle_outline_rounded
              : Icons.cancel_outlined,
          color: isAvailable ? AppColors.success : AppColors.error,
          bgColor: isAvailable ? AppColors.successLight : AppColors.errorLight,
        ),
        const _InfoChip(
          label: '25 mins',
          icon: Icons.delivery_dining_rounded,
          color: AppColors.secondary,
          bgColor: AppColors.secondaryLight,
        ),
        const _InfoChip(
          label: 'Free Delivery',
          icon: Icons.local_shipping_outlined,
          color: AppColors.warning,
          bgColor: AppColors.warningLight,
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Price row
// ---------------------------------------------------------------------------

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.effectivePrice,
    required this.originalPrice,
    required this.hasDiscount,
  });

  final double effectivePrice;
  final double originalPrice;
  final bool hasDiscount;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '৳${effectivePrice.toStringAsFixed(0)}',
          style: AppTextStyles.price.copyWith(fontSize: 26),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            '৳${originalPrice.toStringAsFixed(0)}',
            style: AppTextStyles.priceStrike,
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: AppRadius.smAll,
            ),
            child: Text(
              '${(((originalPrice - effectivePrice) / originalPrice) * 100).round()}% OFF',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Mock rating row
// ---------------------------------------------------------------------------

class _RatingRow extends StatelessWidget {
  const _RatingRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          5,
          (i) => Icon(
            i < 4 ? Icons.star_rounded : Icons.star_half_rounded,
            size: 18,
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '4.5',
          style: AppTextStyles.label.copyWith(color: AppColors.warning),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text('(128 reviews)', style: AppTextStyles.caption),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Fixed bottom action bar
// ---------------------------------------------------------------------------

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.productId,
    required this.quantity,
    required this.isAvailable,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
  });

  final int productId;
  final int quantity;
  final bool isAvailable;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.medium,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Row(
        children: [
          // Quantity selector
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: AppRadius.smAll,
            ),
            child: Row(
              children: [
                _QtyButton(
                  icon: Icons.remove,
                  onTap: onDecrement,
                  enabled: quantity > 1,
                ),
                SizedBox(
                  width: 36,
                  child: Text(
                    '$quantity',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.label,
                  ),
                ),
                _QtyButton(
                  icon: Icons.add,
                  onTap: onIncrement,
                  enabled: isAvailable,
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Add to cart button
          Expanded(
            child: AnimatedOpacity(
              opacity: isAvailable ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton.icon(
                onPressed: isAvailable ? onAddToCart : null,
                icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                label: const Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.smAll,
                  ),
                  textStyle: AppTextStyles.button,
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 44,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.primary : AppColors.disabled,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading skeleton
// ---------------------------------------------------------------------------

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerLoaderWidget(
          width: double.infinity,
          height: 300,
          borderRadius: BorderRadius.zero,
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoaderWidget(width: 200, height: 16),
              const SizedBox(height: AppSpacing.sm),
              ShimmerLoaderWidget(width: double.infinity, height: 28),
              const SizedBox(height: AppSpacing.sm),
              ShimmerLoaderWidget(width: 120, height: 22),
              const SizedBox(height: AppSpacing.xl),
              ShimmerLoaderWidget(width: double.infinity, height: 80),
            ],
          ),
        ),
      ],
    );
  }
}
