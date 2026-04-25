import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_shadows.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/category_icon_mapper.dart';
import '../../../../core/widgets/shimmer_loader_widget.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/presentation/providers/categories_provider.dart';

/// Horizontal scrollable list of animated category cards.
/// Fetches live data from [categoriesProvider] and maps each category
/// to an icon/color via [CategoryIconMapper].
/// (Requirements 15.3, 25.x)
class CategoryList extends ConsumerWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return SizedBox(
      height: 100,
      child: categoriesAsync.when(
        loading: () => const ShimmerCategoryLoader(),
        error: (_, __) => const SizedBox.shrink(),
        data: (categories) => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _AnimatedCategoryCard(category: categories[index]),
            );
          },
        ),
      ),
    );
  }
}

/// A single category card with press-scale animation and icon bounce.
class _AnimatedCategoryCard extends StatefulWidget {
  const _AnimatedCategoryCard({required this.category});

  final CategoryEntity category;

  @override
  State<_AnimatedCategoryCard> createState() => _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState extends State<_AnimatedCategoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _iconBounce;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _iconBounce = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final icon = CategoryIconMapper.iconFor(widget.category.iconKey);
    final bgColor = CategoryIconMapper.colorFor(widget.category.iconKey);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () {},
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: Container(
          width: 82,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.lgAll,
            boxShadow: AppShadows.low,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated icon container
              AnimatedBuilder(
                animation: _iconBounce,
                builder: (context, child) => Transform.scale(
                  scale: _iconBounce.value,
                  child: child,
                ),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 24, color: _iconColor(bgColor)),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.category.name,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Derives a readable icon color from the card background color.
  Color _iconColor(Color bg) {
    // Darken the background hue for the icon so it pops on the pastel bg
    return HSLColor.fromColor(bg)
        .withLightness(0.35)
        .withSaturation(0.7)
        .toColor();
  }
}
