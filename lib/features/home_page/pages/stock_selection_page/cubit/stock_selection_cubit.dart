import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/core/network/api_urls.dart';
import 'package:stoxplay/core/network/ws_service.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_params_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_response_model.dart';
import 'package:stoxplay/features/home_page/data/models/live_stock_model.dart';
import 'package:stoxplay/features/home_page/domain/home_usecase.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/stock_selection_screen.dart';
import 'package:stoxplay/features/home_page/data/models/stock_data_model.dart';
import 'package:stoxplay/utils/common/cubits/timer_cubit.dart';
import 'package:stoxplay/utils/common/functions/get_current_time.dart';
import 'package:stoxplay/utils/models/contest_model.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/models/contest_model.dart';

part 'stock_selection_state.dart';

class StockSelectionCubit extends Cubit<StockSelectionState> {
  GetStockListUseCase stockListUseCase;
  JoinContestUseCase joinContestUseCase;
  WebSocketService ws = WebSocketService();
  TimerCubit timerCubit = TimerCubit();
  String? currentContestId;

  StockSelectionCubit({required this.stockListUseCase, required this.joinContestUseCase})
    : super(StockSelectionState());

  ///APIs
  Future<List<Stock>?> getStockList(String contestId) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));

    final sectorList = await stockListUseCase.call(contestId);

    return sectorList.fold(
      (l) {
        emit(state.copyWith(apiStatus: ApiStatus.failed));
        return null;
      },
      (r) {
        final stockList = r.stocks.map(_convertToStockModel).toList();
        final totalSeconds = getTotalSecondsFromTimeLeft(r.timeLeftToStart);
        timerCubit.startTimer(seconds: totalSeconds);
        emit(
          state.copyWith(stockList: stockList, apiStatus: ApiStatus.success, timeLeftToStartModel: r.timeLeftToStart),
        );
        return stockList;
      },
    );
  }

  Future<JoinContestResponseModel?> joinContest(String contestId) async {
    emit(state.copyWith(joinContestApiStatus: ApiStatus.loading));
    await getReorderedStockList(state.selectedStockList);

    final params = JoinContestParamsModel(
      contestId: contestId,
      teamName: "Username-T2",
      selectedStocks:
          state.selectedStockList
              .map((e) => SelectedStock(stockId: e.id.toString(), prediction: e.stockPrediction.toName))
              .toList(),
      captainStockId:
          state.selectedStockList.where((element) => element.stockPosition == StockPosition.leader).first.id.toString(),
      viceCaptainStockId:
          state.selectedStockList
              .where((element) => element.stockPosition == StockPosition.viceLeader)
              .first
              .id
              .toString(),
      flexStockId:
          state.selectedStockList
              .where((element) => element.stockPosition == StockPosition.coLeader)
              .first
              .id
              .toString(),
    );

    final result = await joinContestUseCase.call(params);

    return result.fold(
      (l) {
        // Fluttertoast.showToast(msg: "Join contest failed please try again later");
        emit(state.copyWith(joinContestApiStatus: ApiStatus.failed, message: l.message));
        return null;
      },
      (r) {
        emit(
          state.copyWith(
            joinContestApiStatus: ApiStatus.success,
            message: "Successfully joined contest!",
            joinContestResponse: r,
          ),
        );
        return r; // Return the response model with the id
      },
    );
  }

  ///Functionalities
  // Convert StockDataModel to Stock model
  Stock _convertToStockModel(StockDataModel stockData) {
    return Stock(
      stockName: stockData.name,
      id: stockData.id.toString(),
      stockPrice: stockData.currentPrice?.toString() ?? '0',
      currentPrice: stockData.currentPrice?.toString() ?? '0',
      netChange: stockData.percentageChange,
      image: stockData.logoUrl,
      percentage: stockData.percentageChange?.toString() ?? '0.0',
      stockPrediction: StockPrediction.none,
      stockPosition: StockPosition.none,
      selectionPercentage: stockData.selectionPercentage,
      captainSelectionPercentage: stockData.captainSelectionPercentage,
      downPredictionPercentage: stockData.downPredictionPercentage,
      upPredictionPercentage: stockData.upPredictionPercentage,
      flexSelectionPercentage: stockData.flexSelectionPercentage,
      viceCaptainSelectionPercentage: stockData.viceCaptainSelectionPercentage
    );
  }

  // Set stock list from API data
  void setStockListFromApi(List<StockDataModel> stockDataList) {
    final stockList = stockDataList.map((stockData) => _convertToStockModel(stockData)).toList();
    emit(state.copyWith(stockList: stockList));
  }

  void updateStock({required Stock stock, required int index}) {
    List<Stock> list = List.from(state.stockList);
    list[index] = stock;
    emit(state.copyWith(stockList: [...list]));
  }

  void updateSelectedStock({required Stock stock, required int index, required StockPosition stockPosition}) {
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

  void updateSelectedStockPrediction({required Stock stock, required StockPrediction stockPrediction}) {
    final list = List<Stock>.from(state.selectedStockList);

    final selectedIndex = list.indexWhere((s) => s.id == stock.id);
    if (selectedIndex == -1) {
      return; // Stock not in selected list, prevent crash
    }

    list[selectedIndex] = stock.copyWith(stockPrediction: stockPrediction);
    emit(state.copyWith(selectedStockList: list));
  }

  void addSelectedStock({required Stock stock}) {
    final updatedList = [...state.selectedStockList, stock];
    emit(state.copyWith(selectedStockList: updatedList));
  }

  void removeSelectedStock({required Stock stock}) {
    final updatedList = state.selectedStockList.where((s) => s.id != stock.id).toList();
    emit(state.copyWith(selectedStockList: updatedList));
  }
}
