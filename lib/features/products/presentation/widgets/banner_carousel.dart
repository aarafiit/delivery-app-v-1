import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer_loader_widget.dart';

/// Horizontally scrollable banner carousel with auto-scroll and dot indicators.
///
/// Accepts [imageUrls] so it can display banners from any source
/// (MinIO, CDN, mock data, etc.) without being coupled to a specific provider.
/// (Requirements 15.2)
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late final PageController _controller;
  int _currentIndex = 0;
  Timer? _timer;

  static const _autoScrollDuration = Duration(seconds: 3);
  static const _animationDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    if (widget.imageUrls.length > 1) _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(_autoScrollDuration, (_) {
      if (!mounted) return;
      final next = (_currentIndex + 1) % widget.imageUrls.length;
      _controller.animateToPage(
        next,
        duration: _animationDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.imageUrls;

    if (banners.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 168,
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: ClipRRect(
                  borderRadius: AppRadius.lgAll,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        banners[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const ShimmerBannerLoader();
                        },
                        errorBuilder: (_, __, ___) => Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryDark],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.local_offer_outlined,
                              size: 48,
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ),
                      ),
                      // Gradient overlay for readability
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.35),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) {
            final isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.divider,
                borderRadius: AppRadius.fullAll,
              ),
            );
          }),
        ),
      ],
    );
  }
}
