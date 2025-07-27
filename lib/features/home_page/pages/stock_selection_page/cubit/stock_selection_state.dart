part of 'stock_selection_cubit.dart';

@immutable
class StockSelectionState extends Equatable {
  List<Stock> stockList = [];
  List<Stock> selectedStockList = [];
  ApiStatus apiStatus;
  String? message;
  ApiStatus joinContestApiStatus;
  JoinContestResponseModel? joinContestResponse;

  StockSelectionState({
    this.stockList = const [],
    this.selectedStockList = const [],
    this.joinContestApiStatus = ApiStatus.initial,
    this.apiStatus = ApiStatus.initial,
    this.message,
    this.joinContestResponse,
  });

  StockSelectionState copyWith({
    List<Stock>? stockList,
    ApiStatus? apiStatus,
    ApiStatus? joinContestApiStatus,
    List<Stock>? selectedStockList,
    String? message,
    JoinContestResponseModel? joinContestResponse,
  }) {
    return StockSelectionState(
      stockList: stockList ?? this.stockList,
      apiStatus: apiStatus ?? this.apiStatus,
      joinContestApiStatus: joinContestApiStatus ?? this.joinContestApiStatus,
      selectedStockList: selectedStockList ?? this.selectedStockList,
      message: message ?? this.message,
      joinContestResponse: joinContestResponse ?? this.joinContestResponse,
    );
  }

  @override
  List<Object?> get props => [stockList, joinContestApiStatus, selectedStockList, apiStatus, message, joinContestResponse];
}
