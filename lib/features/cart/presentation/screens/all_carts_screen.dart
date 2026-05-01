import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_shadows.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/shimmer_loader_widget.dart';
import '../providers/cart_provider.dart';

/// "All Carts" tab screen — shown when user taps the Cart icon in bottom nav.
/// Displays a summary card for the active cart with a "View your cart" button.
class AllCartsScreen extends ConsumerWidget {
  const AllCartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final itemCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('All Carts'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleTextStyle: AppTextStyles.heading2,
      ),
      body: items.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.shopping_cart_outlined,
              heading: 'No active carts',
              subtext: 'Add items to your cart to see them here.',
            )
          : Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _CartSummaryCard(
                itemCount: itemCount,
                subtotal: subtotal,
                items: items,
                onViewCart: () => context.pushNamed(AppRoutes.cartDetailName),
              ),
            ),
    );
  }
}

class _CartSummaryCard extends StatelessWidget {
  const _CartSummaryCard({
    required this.itemCount,
    required this.subtotal,
    required this.items,
    required this.onViewCart,
  });

  final int itemCount;
  final double subtotal;
  final List items;
  final VoidCallback onViewCart;

  // Mock original total for savings display
  double get _originalTotal => items.fold(
      0.0,
      (sum, item) =>
          sum + (item.price * item.quantity));

  double get _savings => _originalTotal - subtotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.low,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: AppRadius.smAll,
                  ),
                  child: const Icon(Icons.storefront_outlined,
                      color: AppColors.textSecondary, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delivery App', style: AppTextStyles.label),
                      Row(
                        children: [
                          Text('30–45 mins · ',
                              style: AppTextStyles.caption),
                          const Icon(Icons.delivery_dining_rounded,
                              size: 14, color: AppColors.success),
                          Text(' Free',
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.success)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz,
                    color: AppColors.textSecondary),
              ],
            ),
          ),

          // ── Item thumbnails ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                // Show first item thumbnail
                ClipRRect(
                  borderRadius: AppRadius.smAll,
                  child: Image.network(
                    (items.first).imageUrl,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 52,
                      height: 52,
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.fastfood_rounded,
                          color: AppColors.textHint, size: 24),
                    ),
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : ShimmerLoaderWidget(
                            width: 52,
                            height: 52,
                            borderRadius: AppRadius.smAll,
                          ),
                  ),
                ),
                if (itemCount > 1) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: AppRadius.smAll,
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Center(
                      child: Icon(Icons.add,
                          color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Savings + price row ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                if (_savings > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: AppRadius.fullAll,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_offer_outlined,
                            size: 12, color: AppColors.primary),
                        const SizedBox(width: 3),
                        Text(
                          'Saving ৳${_savings.toStringAsFixed(0)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
                if (_savings <= 0) const Spacer(),
                if (_originalTotal > subtotal)
                  Text(
                    '৳${_originalTotal.toStringAsFixed(0)}',
                    style: AppTextStyles.caption.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: AppColors.textHint,
                    ),
                  ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '৳${subtotal.toStringAsFixed(0)}',
                  style: AppTextStyles.label
                      .copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),

          // ── View cart button ─────────────────────────────────────────
          InkWell(
            onTap: onViewCart,
            borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.lg)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(
                child: Text(
                  'View your cart',
                  style: AppTextStyles.label
                      .copyWith(color: AppColors.textPrimary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
