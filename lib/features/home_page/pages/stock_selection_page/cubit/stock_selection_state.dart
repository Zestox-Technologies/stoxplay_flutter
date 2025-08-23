part of 'stock_selection_cubit.dart';

@immutable
class StockSelectionState extends Equatable {
  List<Stock> stockList = [];
  List<Stock> selectedStockList = [];
  ApiStatus apiStatus;
  String? message;
  ApiStatus joinContestApiStatus;
  JoinContestResponseModel? joinContestResponse;
  TimeLeft? timeLeftToStartModel;
  bool isEdit;

  StockSelectionState({
    this.stockList = const [],
    this.selectedStockList = const [],
    this.joinContestApiStatus = ApiStatus.initial,
    this.apiStatus = ApiStatus.initial,
    this.message,
    this.joinContestResponse,
    this.timeLeftToStartModel,
    this.isEdit = false,
  });

  StockSelectionState copyWith({
    List<Stock>? stockList,
    ApiStatus? apiStatus,
    ApiStatus? joinContestApiStatus,
    List<Stock>? selectedStockList,
    String? message,
    JoinContestResponseModel? joinContestResponse,
    TimeLeft? timeLeftToStartModel,
    bool? isEdit,
  }) {
    return StockSelectionState(
      stockList: stockList ?? this.stockList,
      apiStatus: apiStatus ?? this.apiStatus,
      joinContestApiStatus: joinContestApiStatus ?? this.joinContestApiStatus,
      selectedStockList: selectedStockList ?? this.selectedStockList,
      message: message ?? this.message,
      joinContestResponse: joinContestResponse ?? this.joinContestResponse,
      timeLeftToStartModel: timeLeftToStartModel ?? this.timeLeftToStartModel,
      isEdit: isEdit ?? this.isEdit,
    );
  }

  @override
  List<Object?> get props => [
    stockList,
    joinContestApiStatus,
    selectedStockList,
    apiStatus,
    message,
    joinContestResponse,
    timeLeftToStartModel,
    isEdit
  ];
}
