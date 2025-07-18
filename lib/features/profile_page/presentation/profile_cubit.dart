import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:stoxplay/features/profile_page/data/profile_model.dart';
import 'package:stoxplay/features/profile_page/domain/profile_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileCubit(this.getProfileUseCase) : super(ProfileState.initial());

  Future<void> fetchProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: '', profile: null));
    try {
      final profile = await getProfileUseCase();
      emit(state.copyWith(isLoading: false, profile: profile));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
