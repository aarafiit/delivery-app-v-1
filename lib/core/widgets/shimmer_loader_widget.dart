import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_radius.dart';
import '../../config/theme/app_spacing.dart';

/// Base shimmer loader — a single animated placeholder rectangle.
///
/// Use [ShimmerListLoader] or [ShimmerCardLoader] for common patterns.
/// (Requirements 22.4, 23.3)
class ShimmerLoaderWidget extends StatelessWidget {
  const ShimmerLoaderWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  static const Color _base = Color(0xFFE0E0E0);
  static const Color _highlight = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _base,
      highlightColor: _highlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: _base,
          borderRadius: borderRadius ?? AppRadius.mdAll,
        ),
      ),
    );
  }
}

/// A shimmer placeholder that mimics a list of rows.
class ShimmerListLoader extends StatelessWidget {
  const ShimmerListLoader({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 72,
  });

  final int itemCount;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, __) => _ShimmerListItem(height: itemHeight),
    );
  }
}

class _ShimmerListItem extends StatelessWidget {
  const _ShimmerListItem({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: AppRadius.mdAll,
        ),
      ),
    );
  }
}

/// A shimmer placeholder that mimics a 2-column product grid.
class ShimmerCardLoader extends StatelessWidget {
  const ShimmerCardLoader({
    super.key,
    this.itemCount = 6,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.75,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: AppRadius.mdAll,
          ),
        ),
      ),
    );
  }
}

/// A shimmer placeholder for the banner carousel.
class ShimmerBannerLoader extends StatelessWidget {
  const ShimmerBannerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: ShimmerLoaderWidget(
        width: double.infinity,
        height: 160,
        borderRadius: AppRadius.lgAll,
      ),
    );
  }
}

/// A shimmer placeholder for a horizontal category row.
class ShimmerCategoryLoader extends StatelessWidget {
  const ShimmerCategoryLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: 5,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: Shimmer.fromColors(
            baseColor: const Color(0xFFE0E0E0),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: AppRadius.mdAll,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
