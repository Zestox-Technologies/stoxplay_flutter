import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/core/services/fcm_service.dart';
import 'package:stoxplay/features/auth/domain/auth_usecase.dart';
import 'package:stoxplay/features/profile_page/data/models/playing_history_model.dart';
import 'package:stoxplay/features/profile_page/data/models/profile_model.dart';
import 'package:stoxplay/features/profile_page/domain/profile_usecase.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final FileUploadUseCase fileUploadUseCase;
  final GetPlayingHistoryUseCase getPlayingHistoryUseCase;
  final LogoutUseCase logoutUseCase;

  // Controllers for profile fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  ProfileCubit(
    this.getProfileUseCase,
    this.updateProfileUseCase,
    this.logoutUseCase,
    this.fileUploadUseCase,
    this.getPlayingHistoryUseCase,
  ) : super(ProfileState());

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    return super.close();
  }

  Future<void> fetchProfile({bool forceRefresh = false}) async {
    // Check if we already have valid cached data
    if (!forceRefresh && state.profileModel != null) {
      return; // Profile already loaded, no need to fetch again
    }

    // Try to load from cache first
    if (!forceRefresh) {
      final cachedProfile = StorageService().getCachedData<Map<String, dynamic>>(
        DBKeys.profileCacheKey,
        maxAge: const Duration(minutes: 10), // Profile cache valid for 10 minutes
      );

      if (cachedProfile != null) {
        final profile = ProfileModel.fromJson(cachedProfile);
        _updateControllers(profile);
        emit(
          state.copyWith(
            apiStatus: ApiStatus.success,
            gender: profile.gender ?? "SELECT",
            profileModel: profile,
            profileUrl: profile.profilePictureUrl ?? "",
            dob: profile.dateOfBirth,
          ),
        );
        return;
      }
    }

    emit(state.copyWith(apiStatus: ApiStatus.loading, errorMessage: ''));
    try {
      final profile = await getProfileUseCase();
      _updateControllers(profile);

      // Cache the profile data
      await StorageService().setCachedData(DBKeys.profileCacheKey, profile.toJson());
      StorageService().write(DBKeys.user, profile.toJson());

      emit(
        state.copyWith(
          apiStatus: ApiStatus.success,
          gender: profile.gender ?? "SELECT",
          profileModel: profile,
          profileUrl: profile.profilePictureUrl ?? "",
          dob: profile.dateOfBirth,
        ),
      );
    } catch (e) {
      emit(state.copyWith(apiStatus: ApiStatus.failed, errorMessage: e.toString()));
    }
  }

  void _updateControllers(ProfileModel profile) {
    firstNameController.text = profile.firstName ?? '';
    usernameController.text = profile.username ?? '';
    emailController.text = profile.email ?? '';
    phoneController.text = profile.phoneNumber ?? '';
  }

  // Load profile from cache only (for app bar display)
  void loadCachedProfile() {
    final cachedProfile = StorageService().getCachedData<Map<String, dynamic>>(
      DBKeys.profileCacheKey,
      maxAge: const Duration(hours: 1), // More lenient for cached profile display
    );

    if (cachedProfile != null) {
      final profile = ProfileModel.fromJson(cachedProfile);
      _updateControllers(profile); // Update controllers with cached data
      emit(
        state.copyWith(
          apiStatus: ApiStatus.success,
          gender: profile.gender ?? "SELECT",
          profileModel: profile,
          profileUrl: profile.profilePictureUrl ?? "",
          dob: profile.dateOfBirth,
        ),
      );
    }
  }

  void updateDOB(DateTime dob) {
    emit(state.copyWith(dob: dob));
  }

  void updateGender(String gender) {
    emit(state.copyWith(gender: gender));
  }

  // Initialize controllers with current profile data
  void initializeControllers() {
    if (state.profileModel != null) {
      _updateControllers(state.profileModel!);
    }
  }

  Future<void> updateProfile() async {
    emit(state.copyWith(apiStatus: ApiStatus.loading, errorMessage: ''));
    try {
      // Use the profile picture URL from state.profileUrl (if user uploaded new image)
      // or fall back to existing profile picture URL
      final profilePictureUrl =
          state.profileUrl.isNotEmpty ? state.profileUrl : state.profileModel?.profilePictureUrl ?? '';

      final updatedProfile = {
        "firstName": firstNameController.text,
        "username": usernameController.text,
        "profilePictureUrl": profilePictureUrl,
        "dateOfBirth": state.dob?.toUtc().toIso8601String(),
        "email": emailController.text,
        "gender": state.gender ?? 'SELECT',
      };

      print('📝 Profile Update Data: $updatedProfile');

      final profile = await updateProfileUseCase(updatedProfile);

      // Update the controllers with the updated profile data
      _updateControllers(profile);

      // Cache the updated profile data
      await StorageService().setCachedData(DBKeys.profileCacheKey, profile.toJson());
      StorageService().write(DBKeys.user, profile.toJson());

      // Update the state with the new profile data
      emit(
        state.copyWith(
          apiStatus: ApiStatus.success,
          gender: profile.gender ?? "SELECT",
          profileModel: profile,
          profileUrl: profile.profilePictureUrl ?? "",
          dob: profile.dateOfBirth,
        ),
      );
    } catch (e) {
      emit(state.copyWith(apiStatus: ApiStatus.failed, errorMessage: e.toString()));
    }
  }

  Future<void> uploadProfilePicture(String imagePath) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading, errorMessage: ''));
    try {
      print('📸 Uploading profile picture: $imagePath');
      final profilePictureUrl = await fileUploadUseCase.call({"type": "profiles", "file": imagePath});
      print('✅ Profile picture uploaded successfully: $profilePictureUrl');
      emit(state.copyWith(apiStatus: ApiStatus.success, profileUrl: profilePictureUrl));
    } catch (e) {
      print('❌ Profile picture upload failed: $e');
      emit(state.copyWith(apiStatus: ApiStatus.failed, errorMessage: e.toString()));
    }
  }

  Future<void> logout() async {
    final token = await FCMService().getStoredFCMToken();
    await logoutUseCase.call(token ?? '');
  }

  Future<void> getPlayingHistory({required int page, required int limit}) async {
    // For first page, show loading. For subsequent pages, keep existing data
    if (page == 1) {
      emit(state.copyWith(apiStatus: ApiStatus.loading, errorMessage: ''));
    }

    try {
      final result = await getPlayingHistoryUseCase({'page': page, 'limit': limit});

      if (page == 1) {
        // First page - replace data
        emit(state.copyWith(apiStatus: ApiStatus.success, playingHistory: result));
      } else {
        // Subsequent pages - append data
        final existingData = state.playingHistory?.data ?? [];
        final newData = result.data ?? [];
        final combinedData = [...existingData, ...newData];

        final updatedHistory = PlayingHistoryModel(
          data: combinedData,
          meta: result.meta, // Use the latest meta from the new request
        );

        emit(state.copyWith(apiStatus: ApiStatus.success, playingHistory: updatedHistory));
      }
    } catch (e) {
      emit(state.copyWith(apiStatus: ApiStatus.failed, errorMessage: e.toString()));
    }
  }
}
