import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';

/// Cart tab screen — shows empty state when cart has no items.
/// (Requirements 16.1, 22.3, 23.4)
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleTextStyle: AppTextStyles.heading2,
      ),
      body: const EmptyStateWidget(
        icon: Icons.shopping_cart_outlined,
        heading: 'Your cart is empty',
        subtext: 'Add items from the Products tab to get started.',
        actionLabel: 'Browse Products',
      ),
    );
  }
}
