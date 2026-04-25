import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_shadows.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer_loader_widget.dart';

/// Card widget displaying a product's image, name, price, and optional discount.
/// Uses NetworkImage with shimmer loading placeholder and error fallback.
/// (Requirements 15.4, 24.8)
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.discountPrice,
    this.productId,
  });

  final String name;
  final double price;
  final String imageUrl;
  final double? discountPrice;
  final int? productId;

  bool get _hasDiscount =>
      discountPrice != null && discountPrice! < price;

  @override
  Widget build(BuildContext context) {
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
                          child: const Icon(
                            Icons.add,
                            color: AppColors.textOnPrimary,
                            size: 18,
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
}
