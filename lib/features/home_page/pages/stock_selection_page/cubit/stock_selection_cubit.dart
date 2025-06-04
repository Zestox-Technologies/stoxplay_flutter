import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/stock_selection_screen.dart';
import 'package:stoxplay/models/contest_model.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';

part 'stock_selection_state.dart';

class StockSelectionCubit extends Cubit<StockSelectionState> {
  StockSelectionCubit()
    : super(StockSelectionState(stockList: contests.first.stocks));

  void updateStock({required Stock stock, required int index}) {
    List<Stock> list = List.from(state.stockList);
    list[index] = stock;
    emit(state.copyWith(stockList: [...list]));
  }

  void updateSelectedStock({
    required Stock stock,
    required int index,
    required StockPosition stockPosition,
  }) {
    List<Stock> list = List<Stock>.from(state.selectedStockList);

    for (int i = 0; i < list.length; i++) {
      if (list[i].stockPosition == stockPosition && i != index) {
        list[i] = list[i].copyWith(stockPosition: StockPosition.none);
      }
    }
    list[index] = stock;
    emit(
      state.copyWith(
        selectedStockList: list, // For processing
      ),
    );
  }

  getReorderedStockList(List<Stock> selectedList) {
    List<Stock> normal = [];
    Stock? leader, coLeader, viceLeader;

    for (final s in selectedList) {
      switch (s.stockPosition) {
        case StockPosition.leader:
          leader = s;
          break;
        case StockPosition.coLeader:
          coLeader = s;
          break;
        case StockPosition.viceLeader:
          viceLeader = s;
          break;
        case StockPosition.none:
          normal.add(s);
          break;
      }
    }
    emit(
      state.copyWith(
        selectedStockList: [
          ...normal,
          if (viceLeader != null) viceLeader,
          if (coLeader != null) coLeader,
          if (leader != null) leader,
        ], // For processing
      ),
    );
  }

  void updateSelectedStockPrediction({
    required Stock stock,
    required StockPrediction stockPrediction,
  }) {
    final list = List<Stock>.from(state.selectedStockList);

    // Find the index of the selected stock
    final selectedIndex = list.indexWhere((s) => s.id == stock.id);

    if (selectedIndex == -1) {
      return; // Stock not in selected list, prevent crash
    }

    // Step 2: Update the selected stock with new prediction
    list[selectedIndex] = stock.copyWith(stockPrediction: stockPrediction);

    // Step 3: Emit updated list
    emit(state.copyWith(selectedStockList: list));
  }

  void addSelectedStock({required Stock stock}) {
    final updatedList = [...state.selectedStockList, stock];
    emit(state.copyWith(selectedStockList: updatedList));
  }

  void removeSelectedStock({required Stock stock}) {
    final updatedList =
        state.selectedStockList.where((s) => s.id != stock.id).toList();
    emit(state.copyWith(selectedStockList: updatedList));
  }
}
