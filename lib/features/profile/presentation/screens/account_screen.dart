import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/setting_tile_widget.dart';

/// Profile / Account screen — shown when the user taps the Account tab.
/// (Requirements 18.1 – 18.11)
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  static const String _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(dummyUserNameProvider);
    final phone = ref.watch(dummyUserPhoneProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final isEnglish = locale.languageCode == 'en';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleTextStyle: AppTextStyles.heading2,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
        children: [
          // ── Profile Header ──────────────────────────────────────────────
          ProfileHeaderWidget(
            name: name,
            phone: phone,
            onEditPressed: () => context.pushNamed(AppRoutes.editProfileName),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Preferences ─────────────────────────────────────────────────
          SettingSection(
            label: 'Preferences',
            tiles: [
              SettingTileWidget(
                icon: Icons.language_outlined,
                title: 'Language',
                trailing: _LanguageToggle(
                  isEnglish: isEnglish,
                  onToggle: () {
                    ref.read(localeProvider.notifier).state = isEnglish
                        ? const Locale('bn')
                        : const Locale('en');
                  },
                ),
              ),
              SettingTileWidget(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                trailing: Switch(
                  value: isDark,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    ref.read(themeModeProvider.notifier).state =
                        value ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Address ──────────────────────────────────────────────────────
          SettingSection(
            label: 'Address',
            tiles: [
              SettingTileWidget(
                icon: Icons.location_on_outlined,
                title: 'Saved Addresses',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
                onTap: () => context.pushNamed(AppRoutes.savedAddressesName),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Support ──────────────────────────────────────────────────────
          SettingSection(
            label: 'Support',
            tiles: [
              SettingTileWidget(
                icon: Icons.help_outline,
                title: 'Help & Support',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
                onTap: () => context.pushNamed(AppRoutes.helpSupportName),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Account Actions ──────────────────────────────────────────────
          SettingSection(
            label: 'Account',
            tiles: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context);
                    return AppButton(
                      label: l10n.logout,
                      variant: AppButtonVariant.danger,
                      onPressed: () => _onLogOutPressed(context, ref),
                      icon: Icons.logout_outlined,
                    );
                  }
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xxxl),

          // ── Footer ───────────────────────────────────────────────────────
          Center(
            child: Text(
              'Version $_appVersion',
              style: AppTextStyles.caption,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Future<void> _onLogOutPressed(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    
    // Requirement 35.2: Display confirmation dialog
    final confirmed = await AppDialog.showConfirmDialog(
      context: context,
      title: l10n.logoutConfirmTitle,
      message: l10n.logoutConfirmMessage,
      confirmLabel: l10n.logout,
      cancelLabel: l10n.cancel,
    );
    
    // Requirement 35.7: User can cancel logout
    if (!confirmed) return;
    
    if (context.mounted) {
      try {
        // Requirements 35.3, 35.4, 35.5: Call authProvider.logout to clear auth data
        await ref.read(authProvider.notifier).logout();
        
        if (context.mounted) {
          // Requirement 35.6: Navigate to authGateway after successful logout
          context.goNamed(AppRoutes.authGatewayName);
        }
      } catch (e) {
        // Handle logout errors
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to log out: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Private: Language toggle chip pair
// ---------------------------------------------------------------------------

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({required this.isEnglish, required this.onToggle});

  final bool isEnglish;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppRadius.fullAll,
          border: Border.all(color: AppColors.primary, width: 1.2),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Chip(label: 'EN', active: isEnglish),
            const SizedBox(width: 2),
            _Chip(label: 'বাংলা', active: !isEnglish),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.transparent,
        borderRadius: AppRadius.fullAll,
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
          color: active ? AppColors.textOnPrimary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
