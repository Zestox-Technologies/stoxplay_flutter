part of 'home_cubit.dart';

@immutable
class HomeState extends Equatable {
  final ApiStatus apiStatus;
  SectorListResponse? sectorModel;
  List<ContestModel>? contestList;
  List<StockDataModel>? stockList;
  List<LearningModel>? learningList;
  final bool isContestEnabled;

  HomeState({
    this.sectorModel,
    this.apiStatus = ApiStatus.initial,
    this.isContestEnabled = false,
    this.contestList = const [],
    this.stockList = const [],
    this.learningList = const [],
  });

  HomeState copyWith({
    SectorListResponse? sectorModel,
    List<ContestModel>? contestList,
    List<LearningModel>? learningList,
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
      learningList: learningList ?? this.learningList,
    );
  }

  @override
  List<Object?> get props => [sectorModel, learningList, apiStatus, stockList, isContestEnabled, contestList];
}
