import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/profile_repository.dart';
import 'auth_viewmodel.dart';

// Profile state
class ProfileState {
  final UserProfile? profile;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProfileViewModel extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;
  final String? _userId;

  ProfileViewModel(this._repository, this._userId) : super(const ProfileState()) {
    if (_userId != null) {
      loadProfile();
    }
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profile = await _repository.getProfile(_userId!);
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateName(String name) async {
    if (_userId == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateName(_userId, name);
      await loadProfile();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
  final user = ref.watch(currentUserProvider);
  return ProfileViewModel(
    ref.watch(profileRepositoryProvider),
    user?.uid,
  );
});