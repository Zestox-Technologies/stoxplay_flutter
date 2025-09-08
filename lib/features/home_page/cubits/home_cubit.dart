import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/data/models/ads_model.dart';
import 'package:stoxplay/features/home_page/data/models/contest_detail_model.dart';
import 'package:stoxplay/features/home_page/data/models/contest_leaderboard_model.dart';
import 'package:stoxplay/features/home_page/data/models/contest_model.dart';
import 'package:stoxplay/features/home_page/data/models/learning_model.dart';
import 'package:stoxplay/features/home_page/data/models/most_picked_stock_model.dart';
import 'package:stoxplay/features/home_page/data/models/sector_model.dart';
import 'package:stoxplay/features/home_page/data/models/stock_data_model.dart';
import 'package:stoxplay/features/home_page/domain/home_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  SectorListUseCase sectorListUseCase;
  ContestStatusUseCase contestStatusUseCase;
  GetContestListUseCase getContestListUseCase;
  LearningListUseCase learningListUseCase;
  GetAdsUseCase getAdsUseCase;
  ContestLeaderboardUseCase contestLeaderboardUseCase;
  ContestDetailsUseCase contestDetailsUseCase;
  GetMostPickedStockUseCase getMostPickedStockUseCase;

  HomeCubit({
    required this.sectorListUseCase,
    required this.getContestListUseCase,
    required this.contestStatusUseCase,
    required this.learningListUseCase,
    required this.getAdsUseCase,
    required this.contestLeaderboardUseCase,
    required this.contestDetailsUseCase,
    required this.getMostPickedStockUseCase,
  }) : super(HomeState());

  void getSectorList() async {
    emit(state.copyWith(sectorListApiStatus: ApiStatus.loading));
    final sectorList = await sectorListUseCase.call('');
    sectorList.fold(
      (l) => emit(state.copyWith(sectorListApiStatus: ApiStatus.failed)),
      (r) => emit(state.copyWith(sectorModel: r, sectorListApiStatus: ApiStatus.success)),
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

  Future<void> getLearningList(String type) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    final learningList = await learningListUseCase.call(type);
    learningList.fold(
      (l) => emit(state.copyWith(apiStatus: ApiStatus.failed)),
      (r) => emit(state.copyWith(learningList: r, apiStatus: ApiStatus.success)),
    );
  }

  Future<void> getAdsList() async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    final learningList = await getAdsUseCase.call('');
    learningList.fold(
      (l) => emit(state.copyWith(apiStatus: ApiStatus.failed)),
      (r) => emit(state.copyWith(adsList: r, apiStatus: ApiStatus.success)),
    );
  }

  Future<void> getContestDetails(String contestId) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    final contestDetails = await contestDetailsUseCase.call(contestId);
    contestDetails.fold(
      (l) => emit(state.copyWith(apiStatus: ApiStatus.failed)),
      (r) => emit(state.copyWith(contestDetailModel: r, apiStatus: ApiStatus.success)),
    );
  }

  Future<void> getContestLeaderboard(String contestId) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    final contestDetails = await contestLeaderboardUseCase.call(contestId);
    contestDetails.fold(
      (l) => emit(state.copyWith(apiStatus: ApiStatus.failed)),
      (r) => emit(state.copyWith(contestLeaderboardModel: r, apiStatus: ApiStatus.success)),
    );
  }

  Future<void> getMostPickedStock() async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    final mostPickedStock = await getMostPickedStockUseCase.call('');
    mostPickedStock.fold(
      (l) => emit(state.copyWith(apiStatus: ApiStatus.failed)),
      (r) => emit(state.copyWith(mostPickedStock: r, apiStatus: ApiStatus.success)),
    );
  }
}
