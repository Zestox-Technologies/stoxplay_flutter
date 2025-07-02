import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/data/models/sector_model.dart';
import 'package:stoxplay/features/home_page/domain/home_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  SectorListUseCase sectorListUseCase;
  ContestStatusUseCase contestStatusUseCase;

  HomeCubit({required this.sectorListUseCase, required this.contestStatusUseCase}) : super(HomeState());

  void getSectorList() async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    final sectorList = await sectorListUseCase.call('');
    sectorList.fold(
      (l) => emit(state.copyWith(apiStatus: ApiStatus.failed)),
      (r) => emit(state.copyWith(sectorList: r, apiStatus: ApiStatus.success)),
    );
  }

  Future<bool> getContestStatus() async {
    final response = await contestStatusUseCase.call('');
    response.fold(
      (l) => emit(state.copyWith(apiStatus: ApiStatus.failed)),
      (r) => emit(state.copyWith(isContestEnabled: r, apiStatus: ApiStatus.success)),
    );
    return state.isContestEnabled;
  }
}
