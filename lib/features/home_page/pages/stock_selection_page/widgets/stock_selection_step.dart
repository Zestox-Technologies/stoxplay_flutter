import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/home_page/data/models/stock_data_model.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/cubit/stock_selection_cubit.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/stock_selection_screen.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/widgets/stock_table_header.dart';
import 'package:stoxplay/features/home_page/widgets/stock_selection_widget.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/constants/stock_selection_constants.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/models/contest_model.dart';

class StockSelectionStep extends StatelessWidget {
  final StockSelectionCubit cubit;
  final StockSelectionState state;
  final ValueNotifier<int> stepper;

  const StockSelectionStep({required this.cubit, required this.state, required this.stepper, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          tooltip: 'Go back',
          // semanticLabel: 'Back button',
        ),
        Center(child: Text(Strings.selectStocks, style: _selectStocksStyle, textAlign: TextAlign.center)),
        Gap(10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Strings.pick11StocksFrom30, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              Text(
                StockSelectionConstants.timeLeftText,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Gap(5.h),
        _buildProgressIndicator(),
        Gap(18.h),
        StockTableHeader(isFirstStep: true),
        Gap(5.h),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              separatorBuilder: (context, index) => Gap(8.h),
              itemCount: state.stockList.length,
              itemBuilder:
                  (context, index) => StockSelectionWidget(
                    key: ValueKey(state.stockList[index].id),
                    cubit: cubit,
                    stock: state.stockList[index],
                    stepper: stepper,
                    index: index,
                    onUpPressed: () => _handleUpPressed(index),
                    onDownPressed: () => _handleDownPressed(index),
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: SizedBox(
        height: 12.h,
        child: ListView.builder(
          itemCount: StockSelectionConstants.maxStocks,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final isSelected = index < state.selectedStockList.length;
            return Container(
              width: 23.w,
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.purple661F : AppColors.black9A9A.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.white : AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleUpPressed(int index) {
    final oldStock = state.stockList[index];
    final isSelected = state.selectedStockList.any((stock) => stock.id == oldStock.id);

    if (state.selectedStockList.length >= StockSelectionConstants.maxStocks && !isSelected) {
      return;
    }

    final currentPrediction = oldStock.stockPrediction;

    if (isSelected) {
      if (currentPrediction == StockPrediction.up) {
        cubit.removeSelectedStock(stock: oldStock);
        final updatedStock = oldStock.copyWith(stockPrediction: StockPrediction.none);
        cubit.updateStock(stock: updatedStock, index: index);
      } else if (currentPrediction == StockPrediction.down) {
        cubit.updateSelectedStockPrediction(stockPrediction: StockPrediction.up, stock: oldStock);
        final updatedStock = oldStock.copyWith(stockPrediction: StockPrediction.up);
        cubit.updateStock(stock: updatedStock, index: index);
      }
    } else {
      if (!isSelected) {
        final updatedStock = oldStock.copyWith(stockPrediction: StockPrediction.up);
        cubit.addSelectedStock(stock: updatedStock);
      }
      final updatedStock = oldStock.copyWith(stockPrediction: StockPrediction.up);
      cubit.updateStock(stock: updatedStock, index: index);
    }
  }

  void _handleDownPressed(int index) {
    final oldStock = state.stockList[index];
    final isSelected = state.selectedStockList.any((stock) => stock.id == oldStock.id);
    final currentPrediction = oldStock.stockPrediction;

    if (state.selectedStockList.length >= StockSelectionConstants.maxStocks && !isSelected) {
      return;
    }

    if (isSelected) {
      if (currentPrediction == StockPrediction.down) {
        cubit.removeSelectedStock(stock: oldStock);
        final updatedStock = oldStock.copyWith(stockPrediction: StockPrediction.none);
        cubit.updateStock(stock: updatedStock, index: index);
      } else if (currentPrediction == StockPrediction.up) {
        cubit.updateSelectedStockPrediction(stockPrediction: StockPrediction.down, stock: oldStock);
        final updatedStock = oldStock.copyWith(stockPrediction: StockPrediction.down);
        cubit.updateStock(stock: updatedStock, index: index);
      }
    } else {
      final updatedStock = oldStock.copyWith(stockPrediction: StockPrediction.down);
      cubit.addSelectedStock(stock: updatedStock);
      cubit.updateStock(stock: updatedStock, index: index);
    }
  }

  // Constants
  static const TextStyle _selectStocksStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
}
