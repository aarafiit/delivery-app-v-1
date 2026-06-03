import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/shimmer_loader_widget.dart';
import '../../domain/entities/search_result_item_entity.dart';

/// A single search result row: thumbnail, title/subtitle, and (for products)
/// a trailing price.
class SearchResultTile extends StatelessWidget {
  const SearchResultTile({super.key, required this.item, this.onTap});

  final SearchResultItem item;
  final VoidCallback? onTap;

  double get _effectivePrice =>
      item.hasDiscount ? item.discountPrice! : (item.price ?? 0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: AppRadius.smAll,
              child: SizedBox(
                width: 52,
                height: 52,
                child: item.imageUrl.isEmpty
                    ? const _ThumbPlaceholder()
                    : Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const ShimmerLoaderWidget(
                            width: 52,
                            height: 52,
                            borderRadius: BorderRadius.zero,
                          );
                        },
                        errorBuilder: (_, __, ___) => const _ThumbPlaceholder(),
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label,
                  ),
                  if (item.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing price (products only)
            if (item.isProduct && item.price != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '৳${_effectivePrice.toStringAsFixed(0)}',
                    style: AppTextStyles.price.copyWith(fontSize: 15),
                  ),
                  if (item.hasDiscount)
                    Text(
                      '৳${item.price!.toStringAsFixed(0)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textHint,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
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
      child: const Center(
        child: Icon(Icons.image_outlined, size: 22, color: AppColors.textHint),
      ),
    );
  }
}
