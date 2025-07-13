part of 'home_cubit.dart';

@immutable
class HomeState extends Equatable {
  final ApiStatus apiStatus;
  SectorListResponse? sectorModel;
  List<ContestModel>? contestList;
  List<StockDataModel>? stockList;
  final bool isContestEnabled;

  HomeState({
    this.sectorModel,
    this.apiStatus = ApiStatus.initial,
    this.isContestEnabled = false,
    this.contestList = const [],
    this.stockList = const [],
  });

  HomeState copyWith({
    SectorListResponse? sectorModel,
    List<ContestModel>? contestList,
    List<StockDataModel>? stockList,
    ApiStatus? apiStatus,
    bool? isContestEnabled,
  }) {
    return HomeState(
      sectorModel: sectorModel ?? this.sectorModel,
      apiStatus: apiStatus ?? this.apiStatus,
      isContestEnabled: isContestEnabled ?? this.isContestEnabled,
      contestList: contestList ?? this.contestList,
      stockList: stockList ?? this.stockList,
    );
  }

  @override
  List<Object?> get props => [sectorModel, apiStatus, stockList, isContestEnabled, contestList];
}
