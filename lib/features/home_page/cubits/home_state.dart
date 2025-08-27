part of 'home_cubit.dart';

@immutable
class HomeState extends Equatable {
  final ApiStatus apiStatus;
  SectorListResponse? sectorModel;
  List<ContestModel>? contestList;
  List<StockDataModel>? stockList;
  List<LearningModel>? learningList;
  List<AdsModel>? adsList;
  final bool isContestEnabled;
  ContestDetailModel? contestDetailModel;
  ContestLeaderboardModel? contestLeaderboardModel;

  HomeState({
    this.sectorModel,
    this.apiStatus = ApiStatus.initial,
    this.isContestEnabled = false,
    this.contestList = const [],
    this.stockList = const [],
    this.learningList = const [],
    this.adsList = const [],
    this.contestDetailModel,
    this.contestLeaderboardModel,
  });

  HomeState copyWith({
    SectorListResponse? sectorModel,
    List<ContestModel>? contestList,
    List<LearningModel>? learningList,
    List<StockDataModel>? stockList,
    ApiStatus? apiStatus,
    bool? isContestEnabled,
    List<AdsModel>? adsList,
    ContestDetailModel? contestDetailModel,
    ContestLeaderboardModel? contestLeaderboardModel,
  }) {
    return HomeState(
      sectorModel: sectorModel ?? this.sectorModel,
      apiStatus: apiStatus ?? this.apiStatus,
      isContestEnabled: isContestEnabled ?? this.isContestEnabled,
      contestList: contestList ?? this.contestList,
      stockList: stockList ?? this.stockList,
      learningList: learningList ?? this.learningList,
      adsList: adsList ?? this.adsList,
      contestDetailModel: contestDetailModel ?? this.contestDetailModel,
      contestLeaderboardModel: contestLeaderboardModel ?? this.contestLeaderboardModel,
    );
  }

  @override
  List<Object?> get props => [
    sectorModel,
    learningList,
    adsList,
    apiStatus,
    stockList,
    isContestEnabled,
    contestList,
    contestDetailModel,
    contestLeaderboardModel,
  ];
}
