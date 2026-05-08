import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../providers/profile_provider.dart';

/// Edit Profile screen with real backend integration.
/// 
/// Features:
/// - Pre-fills form with current profile data
/// - Validates email format
/// - Saves changes to backend
/// - Updates UI immediately on success
/// - Shows loading state during save
/// - Handles errors gracefully
/// 
/// Requirements: 18.3, Profile Integration
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _profileImageController;
  
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _profileImageController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _profileImageController.dispose();
    super.dispose();
  }

  /// Pre-fills form with current profile data.
  void _initializeForm(UserProfileEntity profile) {
    if (_isInitialized) return;
    
    _firstNameController.text = profile.firstName ?? '';
    _lastNameController.text = profile.lastName ?? '';
    _emailController.text = profile.email ?? '';
    _profileImageController.text = profile.profileImage ?? '';
    
    _isInitialized = true;
  }

  /// Returns up to two uppercase initials from profile.
  String _getInitials(UserProfileEntity? profile) {
    if (profile == null) return '?';
    return profile.initials;
  }

  /// Validates email format.
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Email is optional
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Handles save button press.
  Future<void> _onSavePressed() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get current profile and userId
    final profileState = ref.read(profileProvider);
    final currentProfile = profileState.value;
    
    if (currentProfile == null) {
      _showErrorSnackbar('Profile data not available');
      return;
    }

    final authState = ref.read(authProvider);
    final userId = authState.value?.user?.userId;
    
    if (userId == null) {
      _showErrorSnackbar('User not authenticated');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create updated profile entity
      // IMPORTANT: Preserve all existing fields, only update edited ones
      final updatedProfile = currentProfile.copyWith(
        firstName: _firstNameController.text.trim().isEmpty 
            ? null 
            : _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim().isEmpty 
            ? null 
            : _lastNameController.text.trim(),
        email: _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
        profileImage: _profileImageController.text.trim().isEmpty 
            ? null 
            : _profileImageController.text.trim(),
      );

      // Call update profile use case
      final success = await ref.read(profileProvider.notifier).updateProfile(
        userId,
        updatedProfile,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate back to profile screen
          context.pop();
        } else {
          _showErrorSnackbar('Failed to update profile. Please try again.');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackbar('An error occurred: ${e.toString()}');
      }
    }
  }

  /// Shows error snackbar.
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch profile state
    final profileState = ref.watch(profileProvider);

    return profileState.when(
      data: (profile) {
        if (profile == null) {
          return _buildErrorState('Profile not loaded');
        }

        // Initialize form with profile data
        _initializeForm(profile);

        return _buildEditForm(profile);
      },
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  /// Builds the main edit form.
  Widget _buildEditForm(UserProfileEntity profile) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xxl,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Avatar ──────────────────────────────────────────────────
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      _getInitials(profile),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: open image picker when photo upload is implemented
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Photo upload coming soon'),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Text(
                          'Change Photo',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // ── First Name field ────────────────────────────────────────
              AppTextField(
                label: 'First Name',
                hint: 'Enter your first name',
                controller: _firstNameController,
                enabled: !_isLoading,
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Last Name field ─────────────────────────────────────────
              AppTextField(
                label: 'Last Name',
                hint: 'Enter your last name',
                controller: _lastNameController,
                enabled: !_isLoading,
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Email field (with validation) ───────────────────────────
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
                validator: _validateEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  filled: true,
                  fillColor: _isLoading 
                      ? AppColors.disabled.withOpacity(0.3)
                      : AppColors.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.smAll,
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.smAll,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.smAll,
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: AppRadius.smAll,
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: AppRadius.smAll,
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.smAll,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Phone Number (read-only) ────────────────────────────────
              AppTextField(
                label: 'Phone Number',
                hint: profile.phoneNumber,
                enabled: false,
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Profile Image URL field ─────────────────────────────────
              AppTextField(
                label: 'Profile Image URL',
                hint: 'Enter image URL',
                controller: _profileImageController,
                keyboardType: TextInputType.url,
                enabled: !_isLoading,
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // ── Save button ─────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: _isLoading ? 'Saving...' : 'Save Changes',
                  onPressed: _isLoading ? null : _onSavePressed,
                  icon: _isLoading ? null : Icons.save_outlined,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds loading state.
  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Builds error state.
  Widget _buildErrorState(String error) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Text(
                error,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Go Back',
                variant: AppButtonVariant.secondary,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
