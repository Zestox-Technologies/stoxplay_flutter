part of 'profile_cubit.dart';

@immutable
class ProfileState {
  final ApiStatus apiStatus;
  final String errorMessage;
  final DateTime? dob;
  final ProfileModel? profileModel;

  const ProfileState({this.apiStatus = ApiStatus.initial, this.errorMessage = '', this.dob, this.profileModel});

  ProfileState copyWith({ApiStatus? apiStatus, String? errorMessage, DateTime? dob, ProfileModel? profileModel}) {
    return ProfileState(
      apiStatus: apiStatus ?? this.apiStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      dob: dob ?? this.dob,
      profileModel: profileModel ?? this.profileModel,
    );
  }
}
