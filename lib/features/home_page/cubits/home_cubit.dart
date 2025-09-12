import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
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
import 'package:stoxplay/utils/constants/db_keys.dart';

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

  Future<void> getSectorList({bool forceRefresh = false}) async {
    // Check if we already have valid cached data
    if (!forceRefresh && state.sectorModel != null) {
      return; // Data already loaded
    }

    // Try to load from cache first
    if (!forceRefresh) {
      final cachedData = StorageService().getCachedData<Map<String, dynamic>>(
        DBKeys.homeDataCacheKey,
        maxAge: const Duration(minutes: 15), // Home data cache valid for 15 minutes
      );

      if (cachedData != null) {
        final sectorModel = SectorListResponse.fromJson(cachedData);
        emit(state.copyWith(sectorModel: sectorModel, sectorListApiStatus: ApiStatus.success));
        return;
      }
    }

    emit(state.copyWith(sectorListApiStatus: ApiStatus.loading));
    final sectorList = await sectorListUseCase.call('');
    sectorList.fold((l) => emit(state.copyWith(sectorListApiStatus: ApiStatus.failed)), (r) {
      // Cache the data
      StorageService().setCachedData(DBKeys.homeDataCacheKey, r.toJson());
      emit(state.copyWith(sectorModel: r, sectorListApiStatus: ApiStatus.success));
    });
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

  Future<void> getAdsList({bool forceRefresh = false}) async {
    // Check if we already have valid cached data
    if (!forceRefresh && state.adsList != null && state.adsList!.isNotEmpty) {
      return; // Data already loaded
    }

    // Try to load from cache first
    if (!forceRefresh) {
      final cachedData = StorageService().getCachedData<List<dynamic>>(
        DBKeys.adsCacheKey,
        maxAge: const Duration(hours: 1), // Ads cache valid for 1 hour
      );

      if (cachedData != null) {
        final adsList = cachedData.map((json) => AdsModel.fromJson(json)).toList();
        emit(state.copyWith(adsList: adsList, apiStatus: ApiStatus.success));
        return;
      }
    }

    emit(state.copyWith(apiStatus: ApiStatus.loading));
    final adsList = await getAdsUseCase.call('');
    adsList.fold((l) => emit(state.copyWith(apiStatus: ApiStatus.failed)), (r) {
      // Cache the data
      StorageService().setCachedData(DBKeys.adsCacheKey, r.map((e) => e.toJson()).toList());
      emit(state.copyWith(adsList: r, apiStatus: ApiStatus.success));
    });
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

  Future<void> getMostPickedStock({bool forceRefresh = false}) async {
    // Check if we already have valid cached data
    if (!forceRefresh && state.mostPickedStock != null && state.mostPickedStock!.isNotEmpty) {
      return; // Data already loaded
    }

    // Try to load from cache first
    if (!forceRefresh) {
      final cachedData = StorageService().getCachedData<List<dynamic>>(
        DBKeys.mostPickedStockCacheKey,
        maxAge: const Duration(minutes: 30), // Most picked stocks cache valid for 30 minutes
      );

      if (cachedData != null) {
        final mostPickedStock = cachedData.map((json) => MostPickedStock.fromJson(json)).toList();
        emit(state.copyWith(mostPickedStock: mostPickedStock, mostPickedStockApiStatus: ApiStatus.success));
        return;
      }
    }

    emit(state.copyWith(mostPickedStockApiStatus: ApiStatus.loading));
    final mostPickedStock = await getMostPickedStockUseCase.call('');
    mostPickedStock.fold((l) => emit(state.copyWith(mostPickedStockApiStatus: ApiStatus.failed)), (r) {
      // Cache the data
      StorageService().setCachedData(DBKeys.mostPickedStockCacheKey, r.map((e) => e.toJson()).toList());
      emit(state.copyWith(mostPickedStock: r, mostPickedStockApiStatus: ApiStatus.success));
    });
  }
}
