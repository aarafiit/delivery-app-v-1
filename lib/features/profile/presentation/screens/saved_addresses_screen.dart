import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_shadows.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class _DummyAddress {
  const _DummyAddress({
    required this.label,
    required this.address,
    required this.isDefault,
  });

  final String label;
  final String address;
  final bool isDefault;
}

/// Saved Addresses screen — shows a static list of dummy addresses
/// with an add-address FAB. Displays [EmptyStateWidget] when list is empty.
/// (Requirements 18.7, 22.3, 23.4)
class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  static const List<_DummyAddress> _addresses = [
    _DummyAddress(
      label: 'Home',
      address: '12/A, Mirpur Road, Dhaka 1216, Bangladesh',
      isDefault: true,
    ),
    _DummyAddress(
      label: 'Office',
      address: '45, Gulshan Avenue, Gulshan-2, Dhaka 1212, Bangladesh',
      isDefault: false,
    ),
    _DummyAddress(
      label: "Mom's Place",
      address: '8, Uttara Sector 7, Dhaka 1230, Bangladesh',
      isDefault: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Saved Addresses'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading2,
      ),
      body: _addresses.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.location_off_outlined,
              heading: 'No saved addresses',
              subtext: 'Add your home, office, or any delivery address.',
              actionLabel: 'Add Address',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _addresses.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) =>
                  _AddressTile(address: _addresses[index]),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add address — coming soon'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Add Address'),
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({required this.address});

  final _DummyAddress address;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.low,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: AppRadius.smAll,
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.label,
                        style: AppTextStyles.label,
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: AppRadius.fullAll,
                          ),
                          child: Text(
                            'Default',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    address.address,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: () {},
              tooltip: 'Edit address',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
