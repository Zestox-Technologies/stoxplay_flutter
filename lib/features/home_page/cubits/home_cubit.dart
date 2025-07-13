import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/data/models/contest_model.dart';
import 'package:stoxplay/features/home_page/data/models/sector_model.dart';
import 'package:stoxplay/features/home_page/data/models/stock_data_model.dart';
import 'package:stoxplay/features/home_page/domain/home_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  SectorListUseCase sectorListUseCase;
  ContestStatusUseCase contestStatusUseCase;
  GetContestListUseCase getContestListUseCase;
  GetStockListUseCase stockListUseCase;

  HomeCubit({
    required this.sectorListUseCase,
    required this.stockListUseCase,
    required this.getContestListUseCase,
    required this.contestStatusUseCase,
  }) : super(HomeState());

  void getSectorList() async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    final sectorList = await sectorListUseCase.call('');
    sectorList.fold(
      (l) => emit(state.copyWith(apiStatus: ApiStatus.failed)),
      (r) => emit(state.copyWith(sectorModel: r, apiStatus: ApiStatus.success)),
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

  Future<void> getContestList(String sectorId) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    final contestList = await getContestListUseCase.call(sectorId);
    contestList.fold(
      (l) => emit(state.copyWith(apiStatus: ApiStatus.failed)),
      (r) => emit(state.copyWith(contestList: r, apiStatus: ApiStatus.success)),
    );
  }

  Future<List<StockDataModel>?> getStockList(String contestId) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    final sectorList = await stockListUseCase.call(contestId);
    sectorList.fold(
      (l) => emit(state.copyWith(apiStatus: ApiStatus.failed)),
      (r) => emit(state.copyWith(stockList: r, apiStatus: ApiStatus.success)),
    );
    return state.stockList;
  }
}
