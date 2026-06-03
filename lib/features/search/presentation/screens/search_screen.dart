import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../domain/entities/search_result_item_entity.dart';
import '../../domain/entities/search_results_entity.dart';
import '../providers/search_provider.dart';
import '../widgets/search_result_tile.dart';

/// Global search tab — searches products, categories, shops and banners
/// via `GET /api/search`, debounced as the user types. (Requirements 16.x)
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  static const _debounceDuration = Duration(milliseconds: 350);

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      ref.read(searchQueryProvider.notifier).state = value.trim();
    });
    setState(() {}); // refresh the clear button's visibility
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    setState(() {});
  }

  void _openResult(SearchResultItem item) {
    FocusScope.of(context).unfocus();
    if (item.isProduct) {
      context.pushNamed(
        AppRoutes.productDetailsName,
        pathParameters: {'id': item.id},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = ref.watch(searchQueryProvider).trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _SearchField(
              controller: _controller,
              showClear: _controller.text.isNotEmpty,
              onChanged: _onQueryChanged,
              onClear: _clear,
            ),
            Expanded(
              child: hasQuery ? _buildResults(context) : const _IdleState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    final resultsAsync = ref.watch(searchResultsProvider);

    return resultsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (_, __) => EmptyStateWidget(
        icon: Icons.wifi_off_outlined,
        heading: 'Could not search',
        subtext: 'Please check your connection and try again.',
        actionLabel: 'Retry',
        onAction: () => ref.invalidate(searchResultsProvider),
      ),
      data: (results) {
        if (results.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.search_off_rounded,
            heading: 'No results',
            subtext: 'We couldn\'t find anything for "${results.query}".',
          );
        }
        return _ResultsList(results: results, onTapItem: _openResult);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Search input field
// ---------------------------------------------------------------------------

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.showClear,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool showClear;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        autofocus: false,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: 'Search products, categories...',
          hintStyle: AppTextStyles.body.copyWith(color: AppColors.textHint),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
          ),
          suffixIcon: showClear
              ? IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: AppColors.textSecondary),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: AppColors.surfaceVariant,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: const OutlineInputBorder(
            borderRadius: AppRadius.smAll,
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: AppRadius.smAll,
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: AppRadius.smAll,
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Results list — grouped sections
// ---------------------------------------------------------------------------

class _ResultsList extends StatelessWidget {
  const _ResultsList({required this.results, required this.onTapItem});

  final SearchResults results;
  final ValueChanged<SearchResultItem> onTapItem;

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[];

    void addSection(String title, List<SearchResultItem> items) {
      if (items.isEmpty) return;
      sections.add(_SectionHeader(title: title));
      sections.addAll(
        items.map((item) => SearchResultTile(
              item: item,
              onTap: () => onTapItem(item),
            )),
      );
    }

    addSection('Products', results.products);
    addSection('Categories', results.categories);
    addSection('Shops', results.shops);
    addSection('Banners', results.banners);

    return ListView(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xl),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: sections,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(title, style: AppTextStyles.heading3),
    );
  }
}

// ---------------------------------------------------------------------------
// Idle state — shown before the user types
// ---------------------------------------------------------------------------

class _IdleState extends StatelessWidget {
  const _IdleState();

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.search_rounded,
      heading: 'Search anything',
      subtext: 'Find products, categories and more across the app.',
    );
  }
}
