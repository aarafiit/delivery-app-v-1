import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_shadows.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer_loader_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_redirect_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../cart/presentation/providers/pending_cart_item_provider.dart';
import '../../domain/entities/product_entity.dart';

/// Card widget displaying a product's image, name, price, and optional discount.
/// Uses NetworkImage with shimmer loading placeholder and error fallback.
/// (Requirements 15.4, 24.8, 40.1, 40.2, 40.3, 40.6)
class ProductCard extends ConsumerWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.discountPrice,
    this.productId,
    this.product,
  });

  final String name;
  final double price;
  final String imageUrl;
  final double? discountPrice;
  final int? productId;
  final ProductEntity? product;

  bool get _hasDiscount =>
      discountPrice != null && discountPrice! < price;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (productId != null) {
            context.pushNamed(
              AppRoutes.productDetailsName,
              pathParameters: {'id': '$productId'},
            );
          }
        },
        borderRadius: AppRadius.mdAll,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.mdAll,
            boxShadow: AppShadows.low,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image with shimmer loading placeholder
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.md),
                  ),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return ShimmerLoaderWidget(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: BorderRadius.zero,
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Product info
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_hasDiscount)
                              Text(
                                '৳${price.toStringAsFixed(0)}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textHint,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              '৳${(_hasDiscount ? discountPrice! : price).toStringAsFixed(0)}',
                              style: AppTextStyles.price.copyWith(fontSize: 15),
                            ),
                          ],
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: () => _handleAddToCart(context, ref),
                            customBorder: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.add,
                                color: AppColors.textOnPrimary,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handles add to cart action with authentication check.
  /// 
  /// If user is not authenticated, stores the product and redirects to auth.
  /// If user is authenticated, adds the product to cart immediately.
  /// 
  /// Requirements: 40.1, 40.2, 40.3, 40.6
  Future<void> _handleAddToCart(BuildContext context, WidgetRef ref) async {
    // Check authentication state
    final authState = ref.read(authProvider);
    final isAuthenticated = authState.when(
      data: (state) => state.isAuthenticated,
      loading: () => false,
      error: (_, __) => false,
    );

    if (!isAuthenticated) {
      // Need product entity for pending cart item
      if (product != null) {
        // Store product for post-authentication addition
        ref.read(pendingCartItemProvider.notifier).state = product;
        
        // Store intended route
        ref.read(authRedirectProvider.notifier)
            .setIntendedRoute('/products/${product!.id}');
        
        // Navigate to auth gateway
        if (context.mounted) {
          context.goNamed(AppRoutes.authGatewayName);
        }
      }
      return;
    }

    // User is authenticated - add to cart normally
    if (productId != null) {
      await ref.read(cartProvider.notifier).addItem(
            productId: productId!,
            name: name,
            imageUrl: imageUrl,
            price: price,
            discountPrice: discountPrice ?? 0,
            quantity: 1,
          );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added $name to cart'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.smAll,
            ),
          ),
        );
      }
    }
  }
}
