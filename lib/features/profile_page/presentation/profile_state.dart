part of 'profile_cubit.dart';

@immutable
class ProfileState {
  final bool isLoading;
  final ProfileModel? profile;
  final String errorMessage;

  const ProfileState({
    required this.isLoading,
    required this.profile,
    required this.errorMessage,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      isLoading: false,
      profile: null,
      errorMessage: '',
    );
  }

  ProfileState copyWith({
    bool? isLoading,
    ProfileModel? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
