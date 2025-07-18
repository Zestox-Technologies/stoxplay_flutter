part of 'stock_selection_cubit.dart';

@immutable
class StockSelectionState extends Equatable {
  List<Stock> stockList = [];
  List<Stock> selectedStockList = [];
  ApiStatus apiStatus;
  ApiStatus joinContestApiStatus;

  StockSelectionState({
    this.stockList = const [],
    this.selectedStockList = const [],
    this.joinContestApiStatus = ApiStatus.initial,
    this.apiStatus = ApiStatus.initial,
  });

  StockSelectionState copyWith({
    List<Stock>? stockList,
    ApiStatus? apiStatus,
    ApiStatus? joinContestApiStatus,
    List<Stock>? selectedStockList,
  }) {
    return StockSelectionState(
      stockList: stockList ?? this.stockList,
      apiStatus: apiStatus ?? this.apiStatus,
      joinContestApiStatus: joinContestApiStatus ?? this.joinContestApiStatus,
      selectedStockList: selectedStockList ?? this.selectedStockList,
    );
  }

  @override
  List<Object?> get props => [stockList, joinContestApiStatus, selectedStockList, apiStatus];
}
