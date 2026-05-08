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
import '../../../../core/widgets/shimmer_loader_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/setting_tile_widget.dart';

/// Profile / Account screen with real backend integration.
/// 
/// Supports multiple states:
/// - Guest mode: Shows login CTA
/// - Loading: Shows skeleton loaders
/// - Error: Shows error message with retry
/// - Data: Shows real profile data
/// 
/// Requirements: 18.1 – 18.11, Profile Integration
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  static const String _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check authentication state
    final authState = ref.watch(authProvider);
    final isGuest = authState.value?.isGuest ?? false;
    final isAuthenticated = authState.value?.isAuthenticated ?? false;
    
    // Show guest profile if user is in guest mode
    if (isGuest || !isAuthenticated) {
      return _buildGuestProfile(context, ref);
    }
    
    // Watch profile state for authenticated users
    final profileState = ref.watch(profileProvider);
    
    return profileState.when(
      data: (profile) {
        if (profile == null) {
          // Profile not loaded yet - show loading
          return _buildLoadingProfile(context, ref);
        }
        // Show authenticated profile with real data
        return _buildAuthenticatedProfile(context, ref, profile);
      },
      loading: () => _buildLoadingProfile(context, ref),
      error: (error, stack) => _buildErrorProfile(context, ref, error),
    );
  }

  /// Builds the authenticated profile view with real data.
  Widget _buildAuthenticatedProfile(
    BuildContext context,
    WidgetRef ref,
    dynamic profile,
  ) {
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
            name: profile.displayName,
            phone: profile.phoneNumber,
            profileImage: profile.profileImage,
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

  /// Builds the loading state with skeleton loaders.
  Widget _buildLoadingProfile(BuildContext context, WidgetRef ref) {
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
          // ── Profile Header Skeleton ─────────────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.lgAll,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xxl,
                horizontal: AppSpacing.xl,
              ),
              child: Column(
                children: [
                  // Avatar skeleton
                  ShimmerLoaderWidget(
                    width: 86,
                    height: 86,
                    borderRadius: BorderRadius.circular(43),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Name skeleton
                  ShimmerLoaderWidget(
                    width: 150,
                    height: 24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Phone skeleton
                  ShimmerLoaderWidget(
                    width: 120,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Button skeleton
                  ShimmerLoaderWidget(
                    width: 160,
                    height: 40,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Preferences (still functional during loading) ───────────────
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

          const SizedBox(height: AppSpacing.xxxl),

          // ── Footer ───────────────────────────────────────────────────────
          Center(
            child: Text(
              'Version $_appVersion',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the error state with retry button.
  Widget _buildErrorProfile(BuildContext context, WidgetRef ref, Object error) {
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
          const SizedBox(height: AppSpacing.xxxl),
          
          // ── Error Message ───────────────────────────────────────────────
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Failed to load profile',
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
                  child: Text(
                    error.toString(),
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                
                // Retry Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
                  child: AppButton(
                    label: 'Retry',
                    variant: AppButtonVariant.primary,
                    onPressed: () => _onRetryPressed(ref),
                    icon: Icons.refresh,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),

          // ── Preferences (still functional during error) ─────────────────
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

          const SizedBox(height: AppSpacing.xxxl),

          // ── Footer ───────────────────────────────────────────────────────
          Center(
            child: Text(
              'Version $_appVersion',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the guest profile view.
  /// 
  /// Shows limited functionality with a login CTA.
  /// Requirements: JWT Auth Upgrade Phase 5, Task 13
  Widget _buildGuestProfile(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final isEnglish = locale.languageCode == 'en';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleTextStyle: AppTextStyles.heading2,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
        children: [
          const SizedBox(height: AppSpacing.xxxl),
          
          // ── Guest Avatar & Message ──────────────────────────────────────
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 50,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Welcome, Guest',
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Login for full experience',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                
                // Login Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
                  child: AppButton(
                    label: 'Login',
                    variant: AppButtonVariant.primary,
                    onPressed: () => context.goNamed(AppRoutes.authGatewayName),
                    icon: Icons.login_outlined,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),

          // ── View-Only Preferences ───────────────────────────────────────
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

          // ── View-Only Support ───────────────────────────────────────────
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
              SettingTileWidget(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
                onTap: () {
                  // TODO: Navigate to terms & conditions
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terms & Conditions coming soon'),
                    ),
                  );
                },
              ),
              SettingTileWidget(
                icon: Icons.info_outline,
                title: 'About',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
                onTap: () {
                  // TODO: Navigate to about screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('About screen coming soon'),
                    ),
                  );
                },
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

  /// Handles retry button press.
  void _onRetryPressed(WidgetRef ref) {
    final authState = ref.read(authProvider);
    final userId = authState.value?.user?.userId;
    
    if (userId != null) {
      ref.read(profileProvider.notifier).fetchProfile(userId);
    }
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
