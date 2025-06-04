part of 'stock_selection_cubit.dart';

@immutable
class StockSelectionState extends Equatable {
  List<Stock> stockList = [];
  List<Stock> selectedStockList = [];

  StockSelectionState({
    this.stockList = const [],
    this.selectedStockList = const [],
  });

  StockSelectionState copyWith({
    List<Stock>? stockList,
    List<Stock>? selectedStockList,
  }) {
    return StockSelectionState(
      stockList: stockList ?? this.stockList,
      selectedStockList: selectedStockList ?? this.selectedStockList,
    );
  }

  @override
  List<Object?> get props => [stockList, selectedStockList];
}
