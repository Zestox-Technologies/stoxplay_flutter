part of 'profile_cubit.dart';

@immutable
class ProfileState {
  final bool isLoading;
  final String errorMessage;
  final DateTime? dob;
  final ProfileModel? profileModel;

  const ProfileState({this.isLoading = false, this.errorMessage = '', this.dob, this.profileModel});

  ProfileState copyWith({bool? isLoading, String? errorMessage, DateTime? dob, ProfileModel? profileModel}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      dob: dob ?? this.dob,
      profileModel: profileModel ?? this.profileModel,
    );
  }
}
