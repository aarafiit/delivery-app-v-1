import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/update_user_profile_use_case.dart';
import 'profile_providers.dart';

/// AsyncNotifier that manages user profile state.
/// 
/// Handles:
/// - Fetching profile data from backend
/// - Updating profile data
/// - Clearing profile on logout
/// - Loading, error, and data states
class ProfileNotifier extends AsyncNotifier<UserProfileEntity?> {
  @override
  Future<UserProfileEntity?> build() async {
    // Initially null - profile will be fetched after authentication
    return null;
  }

  /// Fetches user profile from backend.
  /// 
  /// Updates state to loading, then data or error.
  Future<void> fetchProfile(String userId) async {
    state = const AsyncValue.loading();

    final useCase = ref.read(getUserProfileUseCaseProvider);
    final result = await useCase(userId);

    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (profile) => AsyncValue.data(profile),
    );
  }

  /// Updates user profile on backend.
  /// 
  /// Returns true on success, false on failure.
  Future<bool> updateProfile(String userId, UserProfileEntity profile) async {
    // Set loading state
    state = const AsyncValue.loading();

    final useCase = ref.read(updateUserProfileUseCaseProvider);
    final params = UpdateProfileParams(userId: userId, profile: profile);
    final result = await useCase(params);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (updatedProfile) {
        state = AsyncValue.data(updatedProfile);
        return true;
      },
    );
  }

  /// Clears profile data (called on logout).
  void clearProfile() {
    state = const AsyncValue.data(null);
  }
}

/// Provider for profile state management.
final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, UserProfileEntity?>(
  ProfileNotifier.new,
);
