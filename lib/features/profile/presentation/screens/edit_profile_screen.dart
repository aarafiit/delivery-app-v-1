import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/profile_provider.dart';

/// Edit Profile screen — allows the user to update their name.
///
/// Avatar shows initials with a "Change Photo" label (no picker logic yet).
/// The save button is a stub — no persistence in this phase.
/// (Requirements 18.3)
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: ref.read(dummyUserNameProvider),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Returns up to two uppercase initials from [name].
  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  void _onSavePressed() {
    // Stub — persistence will be wired when the profile API is integrated.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved (stub)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(dummyUserNameProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Avatar placeholder ──────────────────────────────────────
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    _initials(name),
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

            const SizedBox(height: 40),

            // ── Name field ──────────────────────────────────────────────
            AppTextField(
              label: 'Full Name',
              hint: 'Enter your full name',
              controller: _nameController,
            ),

            const SizedBox(height: 32),

            // ── Save button (stub) ──────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Save Changes',
                onPressed: _onSavePressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
