part of 'profile_cubit.dart';

@immutable
class ProfileState {
  final ApiStatus apiStatus;
  final String errorMessage;
  final DateTime? dob;
  final String? gender;
  final ProfileModel? profileModel;
  final String profileUrl;
  final PlayingHistoryModel? playingHistory;

  const ProfileState({
    this.apiStatus = ApiStatus.initial,
    this.gender = "Select",
    this.errorMessage = '',
    this.dob,
    this.profileUrl = "",
    this.profileModel,
    this.playingHistory,
  });

  ProfileState copyWith({
    ApiStatus? apiStatus,
    String? profileUrl,
    String? errorMessage,
    DateTime? dob,
    ProfileModel? profileModel,
    String? gender,
    PlayingHistoryModel? playingHistory,
  }) {
    return ProfileState(
      apiStatus: apiStatus ?? this.apiStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      dob: dob ?? this.dob,
      profileModel: profileModel ?? this.profileModel,
      gender: gender ?? this.gender,
      profileUrl: profileUrl ?? this.profileUrl,
      playingHistory: playingHistory ?? this.playingHistory,
    );
  }
}
