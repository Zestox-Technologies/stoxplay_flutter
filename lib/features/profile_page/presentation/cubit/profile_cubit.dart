import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/profile_page/data/models/profile_model.dart';
import 'package:stoxplay/features/profile_page/domain/profile_usecase.dart';
import 'package:stoxplay/features/profile_page/data/models/playing_history_model.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final FileUploadUseCase fileUploadUseCase;
  final GetPlayingHistoryUseCase getPlayingHistoryUseCase;

  // Controllers for profile fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  ProfileCubit(this.getProfileUseCase, this.updateProfileUseCase, this.fileUploadUseCase, this.getPlayingHistoryUseCase)
    : super(ProfileState());

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    return super.close();
  }

  Future<void> fetchProfile() async {
    emit(state.copyWith(apiStatus: ApiStatus.loading, errorMessage: ''));
    try {
      final profile = await getProfileUseCase();
      // Set controllers
      firstNameController.text = profile.firstName ?? '';
      usernameController.text = profile.username ?? '';
      emailController.text = profile.email ?? '';
      phoneController.text = profile.phoneNumber ?? '';
      StorageService().write(DBKeys.user, profile.toJson());

      emit(
        state.copyWith(
          apiStatus: ApiStatus.success,
          gender: profile.gender ?? "SELECT",
          profileModel: profile,
          dob: profile.dateOfBirth,
        ),
      );
    } catch (e) {
      emit(state.copyWith(apiStatus: ApiStatus.failed, errorMessage: e.toString()));
    }
  }

  void updateDOB(DateTime dob) {
    emit(state.copyWith(dob: dob));
  }

  void updateGender(String gender) {
    emit(state.copyWith(gender: gender));
  }

  Future<void> updateProfile() async {
    emit(state.copyWith(apiStatus: ApiStatus.loading, errorMessage: ''));
    try {
      final updatedProfile = {
        "firstName": firstNameController.text,
        "username": usernameController.text,
        "profilePictureUrl": state.profileUrl,
        "dateOfBirth": state.dob?.toUtc().toIso8601String(),
        "email": emailController.text,
        "gender": state.gender ?? 'SELECT',
      };
      final profile = await updateProfileUseCase(updatedProfile);
      emit(state.copyWith(apiStatus: ApiStatus.success));
    } catch (e) {
      emit(state.copyWith(apiStatus: ApiStatus.failed, errorMessage: e.toString()));
    }
  }

  Future<void> uploadProfilePicture(String imagePath) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading, errorMessage: ''));
    try {
      final profile = await fileUploadUseCase.call({"type": "profiles", "file": imagePath});
      emit(state.copyWith(apiStatus: ApiStatus.success, profileUrl: profile));
    } catch (e) {
      emit(state.copyWith(apiStatus: ApiStatus.failed, errorMessage: e.toString()));
    }
  }

  Future<void> getPlayingHistory({required int page, required int limit}) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading, errorMessage: ''));
    try {
      final result = await getPlayingHistoryUseCase({'page': page, 'limit': limit});
      emit(state.copyWith(apiStatus: ApiStatus.success, playingHistory: result));
    } catch (e) {
      emit(state.copyWith(apiStatus: ApiStatus.failed, errorMessage: e.toString()));
    }
  }
}
