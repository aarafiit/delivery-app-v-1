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
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_redirect_provider.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../providers/cart_provider.dart';

/// Detailed cart screen — lists cart items with quantity controls and a
/// "Proceed to Payment" action. Guests are forced to sign in before checkout;
/// their local cart is merged into the server cart on sign-in.
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Pull the authoritative server cart when an authenticated user opens it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isAuthenticated =
          ref.read(authProvider).value?.isAuthenticated ?? false;
      if (isAuthenticated) {
        ref.read(cartProvider.notifier).refreshFromServer();
      }
    });
  }

  void _onProceed() {
    final isAuthenticated =
        ref.read(authProvider).value?.isAuthenticated ?? false;

    if (isAuthenticated) {
      context.pushNamed(AppRoutes.checkoutName);
      return;
    }

    // Forced sign-in: remember that we want checkout, then send the guest
    // through the auth gateway. After verification the cart is merged and the
    // user lands on the checkout screen.
    ref.read(authRedirectProvider.notifier).setIntendedRoute('/home/checkout');
    context.goNamed(AppRoutes.authGatewayName);
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final itemCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(cartProvider.notifier).clear(),
              child: Text(
                'Clear',
                style: AppTextStyles.label.copyWith(color: AppColors.error),
              ),
            ),
        ],
      ),
      body: items.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.shopping_cart_outlined,
              heading: 'Your cart is empty',
              subtext: 'Browse products and add items to get started.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = items[index];
                return _CartItemTile(
                  item: item,
                  onIncrement: () =>
                      ref.read(cartProvider.notifier).increment(item.id),
                  onDecrement: () =>
                      ref.read(cartProvider.notifier).decrement(item.id),
                  onRemove: () =>
                      ref.read(cartProvider.notifier).remove(item.id),
                );
              },
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : _CartBottomBar(
              subtotal: subtotal,
              itemCount: itemCount,
              onProceed: _onProceed,
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cart item tile
// ---------------------------------------------------------------------------

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItemEntity item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.low,
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: AppRadius.smAll,
            child: SizedBox(
              width: 64,
              height: 64,
              child: item.imageUrl.isEmpty
                  ? const _ThumbPlaceholder()
                  : Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, progress) => progress == null
                          ? child
                          : const ShimmerLoaderWidget(
                              width: 64,
                              height: 64,
                              borderRadius: BorderRadius.zero,
                            ),
                      errorBuilder: (_, __, ___) => const _ThumbPlaceholder(),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Name + unit price + quantity
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyles.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '৳${item.effectivePrice.toStringAsFixed(0)}',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.primary),
                    ),
                    if (item.hasDiscount) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '৳${item.price.toStringAsFixed(0)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textHint,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _QuantityStepper(
                  quantity: item.quantity,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                ),
              ],
            ),
          ),

          // Line total + remove
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.textHint, size: 20),
                onPressed: onRemove,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '৳${item.lineTotal.toStringAsFixed(0)}',
                style: AppTextStyles.label,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThumbPlaceholder extends StatelessWidget {
  const _ThumbPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Icon(Icons.fastfood_rounded,
          color: AppColors.textHint, size: 24),
    );
  }
}

// ---------------------------------------------------------------------------
// Quantity stepper
// ---------------------------------------------------------------------------

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: AppRadius.smAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(icon: Icons.remove, onTap: onDecrement),
          SizedBox(
            width: 32,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: AppTextStyles.label,
            ),
          ),
          _StepBtn(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom bar with subtotal + proceed button
// ---------------------------------------------------------------------------

class _CartBottomBar extends StatelessWidget {
  const _CartBottomBar({
    required this.subtotal,
    required this.itemCount,
    required this.onProceed,
  });

  final double subtotal;
  final int itemCount;
  final VoidCallback onProceed;

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
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.medium,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal ($itemCount ${itemCount == 1 ? 'item' : 'items'})',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
              Text(
                '৳${subtotal.toStringAsFixed(0)}',
                style: AppTextStyles.price.copyWith(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onProceed,
              icon: const Icon(Icons.lock_outline_rounded, size: 18),
              label: const Text('Proceed to Payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.smAll,
                ),
                textStyle: AppTextStyles.button,
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
