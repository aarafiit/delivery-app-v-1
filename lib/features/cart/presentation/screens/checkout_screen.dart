import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_shadows.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../providers/cart_provider.dart';

/// Checkout screen — matches the reference UI with stepper, map preview,
/// delivery options, payment method, and order summary.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _leaveAtDoor = false;
  bool _isPriority = false;

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    const platformFee = 10.0;
    const priorityFee = 26.0;
    final deliveryFee = _isPriority ? priorityFee : 0.0;
    final total = subtotal + platformFee + deliveryFee;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── App bar ────────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.surface,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 18),
                  color: AppColors.textPrimary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Checkout', style: AppTextStyles.heading2),
                    Text('Delivery App · Dhaka',
                        style: AppTextStyles.caption),
                  ],
                ),
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(52),
                  child: _StepperBar(currentStep: 2),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Map preview ──────────────────────────────────────
                    _MapPreviewCard(
                      leaveAtDoor: _leaveAtDoor,
                      onLeaveAtDoorChanged: (v) =>
                          setState(() => _leaveAtDoor = v),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Delivery options ─────────────────────────────────
                    Text('Delivery options', style: AppTextStyles.heading3),
                    const SizedBox(height: AppSpacing.md),
                    _DeliveryOptionCard(
                      label: 'Priority',
                      subtitle: '10 - 25 mins',
                      badge: '+ ৳${priorityFee.toStringAsFixed(0)}',
                      icon: Icons.bolt_rounded,
                      iconColor: AppColors.warning,
                      selected: _isPriority,
                      onTap: () => setState(() => _isPriority = true),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _DeliveryOptionCard(
                      label: 'Standard',
                      subtitle: '15 - 30 mins',
                      selected: !_isPriority,
                      onTap: () => setState(() => _isPriority = false),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Payment method ───────────────────────────────────
                    Text('Payment method', style: AppTextStyles.heading3),
                    const SizedBox(height: AppSpacing.md),
                    _AddPaymentCard(),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Order summary ────────────────────────────────────
                    Text('Order summary', style: AppTextStyles.heading3),
                    const SizedBox(height: AppSpacing.md),
                    ...items.map((item) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppSpacing.xs),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.quantity}x ${item.name}',
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),
                              Text(
                                '৳${item.lineTotal.toStringAsFixed(0)}',
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        )),
                    const Divider(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total (incl. fees and tax)',
                                style: AppTextStyles.label),
                            Text('See summary',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('৳${total.toStringAsFixed(0)}',
                                style: AppTextStyles.price.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 18)),
                            if (subtotal != total)
                              Text(
                                '৳${subtotal.toStringAsFixed(0)}',
                                style: AppTextStyles.caption.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          ),

          // ── Sticky CTA ─────────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _ConfirmButton(onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed! (stub)'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Stepper (reused from cart) ────────────────────────────────────────────────

class _StepperBar extends StatelessWidget {
  const _StepperBar({required this.currentStep});
  final int currentStep;
  static const _labels = ['Menu', 'Cart', 'Checkout'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
      child: Row(
        children: List.generate(3, (i) {
          final active = i <= currentStep;
          return Expanded(
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.textPrimary
                            : AppColors.surfaceVariant,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('${i + 1}',
                            style: AppTextStyles.caption.copyWith(
                              color: active
                                  ? AppColors.textOnPrimary
                                  : AppColors.textHint,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(_labels[i],
                        style: AppTextStyles.caption.copyWith(
                          color: active
                              ? AppColors.textPrimary
                              : AppColors.textHint,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                        )),
                  ],
                ),
                if (i < 2)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 18),
                      color: i < currentStep
                          ? AppColors.textPrimary
                          : AppColors.divider,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Map preview card ──────────────────────────────────────────────────────────

class _MapPreviewCard extends StatelessWidget {
  const _MapPreviewCard({
    required this.leaveAtDoor,
    required this.onLeaveAtDoorChanged,
  });

  final bool leaveAtDoor;
  final ValueChanged<bool> onLeaveAtDoorChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.low,
      ),
      child: Column(
        children: [
          // Map placeholder
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.md)),
            child: Container(
              height: 80,
              color: const Color(0xFFD4E8C2),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.smAll,
                        boxShadow: AppShadows.low,
                      ),
                      child: const Icon(Icons.location_on_rounded,
                          color: AppColors.primary, size: 32),
                    ),
                  ),
                  Expanded(
                    child: Text('Dhaka, Bangladesh',
                        style: AppTextStyles.label),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: AppSpacing.md),
                    child: Icon(Icons.chevron_right,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          // Leave at door toggle
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: Row(
              children: [
                Text('Leave at the door', style: AppTextStyles.body),
                const Spacer(),
                Switch(
                  value: leaveAtDoor,
                  onChanged: onLeaveAtDoorChanged,
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Delivery option card ──────────────────────────────────────────────────────

class _DeliveryOptionCard extends StatelessWidget {
  const _DeliveryOptionCard({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.badge,
    this.icon,
    this.iconColor,
  });

  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mdAll,
          border: Border.all(
            color: selected ? AppColors.textPrimary : AppColors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.divider,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.textPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(label, style: AppTextStyles.label),
                      if (icon != null) ...[
                        const SizedBox(width: 4),
                        Icon(icon, size: 16, color: iconColor),
                      ],
                    ],
                  ),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.divider),
                  borderRadius: AppRadius.smAll,
                ),
                child: Text(badge!, style: AppTextStyles.caption),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Add payment card ──────────────────────────────────────────────────────────

class _AddPaymentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mdAll,
          boxShadow: AppShadows.low,
        ),
        child: Row(
          children: [
            const Icon(Icons.add, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: AppSpacing.sm),
            Text('Add a payment method', style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}

// ── Confirm button ────────────────────────────────────────────────────────────

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md,
          AppSpacing.lg, AppSpacing.md + bottomPadding),
      decoration: BoxDecoration(
          color: AppColors.surface, boxShadow: AppShadows.medium),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.smAll),
          textStyle: AppTextStyles.button,
          elevation: 0,
        ),
        child: const Text('Confirm address'),
      ),
    );
  }
}
