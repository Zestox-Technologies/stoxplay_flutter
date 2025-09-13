part of 'home_cubit.dart';

@immutable
class HomeState extends Equatable {
  final ApiStatus apiStatus;
  final ApiStatus mostPickedStockApiStatus;
  final ApiStatus sectorListApiStatus;
  final ApiStatus learningListApiStatus;
  SectorListResponse? sectorModel;
  List<ContestModel>? contestList;
  List<StockDataModel>? stockList;
  List<LearningModel>? learningList;
  List<AdsModel>? adsList;
  final bool isContestEnabled;
  ContestDetailModel? contestDetailModel;
  ContestLeaderboardModel? contestLeaderboardModel;
  List<MostPickedStock>? mostPickedStock;

  HomeState({
    this.sectorModel,
    this.apiStatus = ApiStatus.initial,
    this.mostPickedStockApiStatus = ApiStatus.initial,
    this.sectorListApiStatus = ApiStatus.initial,
    this.learningListApiStatus = ApiStatus.initial,
    this.isContestEnabled = false,
    this.contestList = const [],
    this.stockList = const [],
    this.learningList = const [],
    this.adsList = const [],
    this.contestDetailModel,
    this.contestLeaderboardModel,
    this.mostPickedStock,
  });

  HomeState copyWith({
    SectorListResponse? sectorModel,
    List<ContestModel>? contestList,
    List<LearningModel>? learningList,
    List<StockDataModel>? stockList,
    ApiStatus? apiStatus,
    ApiStatus? sectorListApiStatus,
    ApiStatus? learningListApiStatus,
    bool? isContestEnabled,
    List<AdsModel>? adsList,
    ContestDetailModel? contestDetailModel,
    ContestLeaderboardModel? contestLeaderboardModel,
    List<MostPickedStock>? mostPickedStock,
    ApiStatus? mostPickedStockApiStatus,
  }) {
    return HomeState(
      sectorModel: sectorModel ?? this.sectorModel,
      apiStatus: apiStatus ?? this.apiStatus,
      sectorListApiStatus: sectorListApiStatus ?? this.sectorListApiStatus,
      learningListApiStatus: learningListApiStatus ?? this.learningListApiStatus,
      isContestEnabled: isContestEnabled ?? this.isContestEnabled,
      contestList: contestList ?? this.contestList,
      stockList: stockList ?? this.stockList,
      learningList: learningList ?? this.learningList,
      adsList: adsList ?? this.adsList,
      contestDetailModel: contestDetailModel ?? this.contestDetailModel,
      contestLeaderboardModel: contestLeaderboardModel ?? this.contestLeaderboardModel,
      mostPickedStock: mostPickedStock ?? this.mostPickedStock,
      mostPickedStockApiStatus: mostPickedStockApiStatus ?? this.mostPickedStockApiStatus,
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
    mostPickedStock,
    mostPickedStockApiStatus,
    sectorListApiStatus,
    learningListApiStatus,
  ];
}
