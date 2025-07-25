import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:stoxplay/features/profile_page/data/profile_model.dart';
import 'package:stoxplay/features/profile_page/domain/profile_usecase.dart';
import 'package:flutter/material.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  // Controllers for profile fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  ProfileCubit(this.getProfileUseCase, this.updateProfileUseCase) : super(ProfileState());

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
    emit(state.copyWith(isLoading: true, errorMessage: ''));
    try {
      final profile = await getProfileUseCase();
      // Set controllers
      firstNameController.text = profile.firstName;
      lastNameController.text = profile.lastName;
      usernameController.text = profile.username;
      emailController.text = profile.email ?? '';
      phoneController.text = profile.phoneNumber;
      emit(state.copyWith(isLoading: false, profileModel: profile));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void updateDOB(DateTime dob) {
    emit(state.copyWith(dob: dob));
  }

  Future<void> updateProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));
    try {
      final updatedProfile = {
        "firstName": firstNameController.text,
        "username": usernameController.text,
        "profilePictureUrl": "https://i.pravatar.cc/300",
        "dateOfBirth": state.dob?.toUtc().toIso8601String(),
      };
      final profile = await updateProfileUseCase(updatedProfile);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
