import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/cubit/stock_selection_cubit.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/stock_selection_screen.dart';
import 'package:stoxplay/utils/common/widgets/cached_image_widget.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/models/contest_model.dart';

class StockSelectionWidget extends StatelessWidget {
  VoidCallback onUpPressed;
  VoidCallback onDownPressed;
  StockSelectionCubit cubit;
  Stock stock;
  ValueNotifier<int> stepper;
  int index;

  StockSelectionWidget({
    required this.onUpPressed,
    required this.stepper,
    required this.onDownPressed,
    required this.stock,
    required this.cubit,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockSelectionCubit, StockSelectionState>(
      bloc: cubit,
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: stepper,
          builder: (context, steps, _) {
            bool isDown = (stock.downPredictionPercentage?.toInt() ?? 0) > (stock.upPredictionPercentage?.toInt() ?? 0);
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color:
                            stepper.value == 1
                                ? (state.selectedStockList[index].stockPrediction == StockPrediction.up)
                                    ? AppColors.green0CAE
                                    : AppColors.red
                                : (state.stockList[index].stockPrediction == StockPrediction.up)
                                ? AppColors.green0CAE
                                : (state.stockList[index].stockPrediction == StockPrediction.down)
                                ? AppColors.red
                                : AppColors.blue7E.withOpacity(0.5),
                        offset: const Offset(0, 0),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                    border: Border.all(
                      color:
                          stepper.value == 1
                              ? (state.selectedStockList[index].stockPrediction == StockPrediction.up)
                                  ? AppColors.green0CAE
                                  : AppColors.red
                              : (state.stockList[index].stockPrediction == StockPrediction.up)
                              ? AppColors.green0CAE
                              : (state.stockList[index].stockPrediction == StockPrediction.down)
                              ? AppColors.red
                              : AppColors.blue7E.withOpacity(0.5),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      10.w,
                      MediaQuery.of(context).size.width >= 600
                          ? 5
                              .h // Tablet
                          : (MediaQuery.of(context).size.width > 400 && MediaQuery.of(context).size.height < 900)

                          ? 10
                              .h // Foldable / medium screens
                          : 5.h, // Normal phones
                      10.w,
                      3.h,
                    ),
                    margin: EdgeInsets.all(
                      MediaQuery.of(context).size.width >= 600
                          ? 3
                              .h // Tablet
                          : (MediaQuery.of(context).size.width > 400 && MediaQuery.of(context).size.height < 900)

                          ? 10
                              .h // Foldable / mid-size
                          : 3.h, // Normal phone
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.black.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 35.h,
                              width: 35.w,
                              child: SVGImageWidget(
                                imageUrl: stock.image ?? '',
                                errorWidget: Image.network(stock.image.toString()),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(height: 25.h),
                                TextView(
                                  text: '₹${stock.stockPrice} (${stock.netChange.toString()}%) ',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  fontColor: (stock.netChange ?? 0.0) < 0 ? AppColors.red : AppColors.green0CAE,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Gap(20.w),
                        if (stepper.value == 0)
                          Padding(
                            padding: EdgeInsets.only(top: 22.h),
                            child: Row(
                              children: [
                                Icon(
                                  isDown ? Icons.arrow_downward : Icons.arrow_upward,
                                  size: 13.sp,
                                  color: isDown ? AppColors.red : AppColors.green0CAE,
                                ),
                                TextView(
                                  text: '${(stock.selectionPercentage ?? 0).toString()}%',
                                  fontSize: 13.sp,
                                  fontColor: isDown ? AppColors.red : AppColors.green0CAE,
                                ),
                              ],
                            ),
                          ),
                        stepper.value == 1
                            ? Row(
                              spacing: 7.w,
                              children: [
                                CircularIconWidget(
                                  onPressed: () {
                                    final oldStock = state.selectedStockList[index];
                                    final isSelected = state.selectedStockList.any(
                                      (stock) =>
                                          (stock.stockPosition == StockPosition.leader &&
                                              stock == state.selectedStockList[index]),
                                    );
                                    final updatedStock = Stock(
                                      stockName: oldStock.stockName,
                                      id: oldStock.id,
                                      stockPrice: oldStock.stockPrice,
                                      percentage: oldStock.percentage,
                                      image: oldStock.image,
                                      netChange: oldStock.netChange,
                                      currentPrice: oldStock.currentPrice,
                                      stockPrediction: oldStock.stockPrediction,
                                      stockPosition: isSelected ? StockPosition.none : StockPosition.leader,
                                      selectionPercentage: stock.selectionPercentage,
                                      captainSelectionPercentage: stock.captainSelectionPercentage,
                                      viceCaptainSelectionPercentage: stock.viceCaptainSelectionPercentage,
                                      flexSelectionPercentage: stock.flexSelectionPercentage,
                                      upPredictionPercentage: stock.upPredictionPercentage,
                                      downPredictionPercentage: stock.downPredictionPercentage,
                                      lastUpdated: stock.lastUpdated,
                                      livePoints: stock.livePoints,
                                      isLiveData: stock.isLiveData,
                                    );
                                    cubit.updateSelectedStock(
                                      stock: updatedStock,
                                      index: index,
                                      stockPosition: StockPosition.leader,
                                    );
                                  },
                                  shadowBlurRadius: 3,
                                  borderColor: AppColors.black9A9A,
                                  backgroundColor:
                                      state.selectedStockList[index].stockPosition == StockPosition.leader
                                          ? AppColors.purple5A2F
                                          : AppColors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextView(
                                        text: "L",
                                        fontSize: 14.sp,
                                        fontColor:
                                            state.selectedStockList[index].stockPosition == StockPosition.leader
                                                ? AppColors.white
                                                : AppColors.black9A9A,
                                        lineHeight: 0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      Transform.translate(
                                        offset: const Offset(0, -3),
                                        child: TextView(
                                          text: "${state.selectedStockList[index].captainSelectionPercentage ?? ''}%",
                                          fontColor:
                                              state.selectedStockList[index].stockPosition == StockPosition.leader
                                                  ? AppColors.white
                                                  : AppColors.black9A9A,
                                          fontSize: 5.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CircularIconWidget(
                                  onPressed: () {
                                    final oldStock = state.selectedStockList[index];
                                    final isSelected = state.selectedStockList.any(
                                      (stock) =>
                                          (stock.stockPosition == StockPosition.coLeader &&
                                              stock == state.selectedStockList[index]),
                                    );
                                    final updatedStock = Stock(
                                      stockName: oldStock.stockName,
                                      id: oldStock.id,
                                      stockPrice: oldStock.stockPrice,
                                      percentage: oldStock.percentage,
                                      image: oldStock.image,
                                      netChange: oldStock.netChange,
                                      currentPrice: oldStock.currentPrice,
                                      stockPrediction: oldStock.stockPrediction,
                                      stockPosition: isSelected ? StockPosition.none : StockPosition.coLeader,
                                      selectionPercentage: stock.selectionPercentage,
                                      captainSelectionPercentage: stock.captainSelectionPercentage,
                                      viceCaptainSelectionPercentage: stock.viceCaptainSelectionPercentage,
                                      flexSelectionPercentage: stock.flexSelectionPercentage,
                                      upPredictionPercentage: stock.upPredictionPercentage,
                                      downPredictionPercentage: stock.downPredictionPercentage,
                                      lastUpdated: stock.lastUpdated,
                                      livePoints: stock.livePoints,
                                      isLiveData: stock.isLiveData,
                                    );
                                    cubit.updateSelectedStock(
                                      stock: updatedStock,
                                      index: index,
                                      stockPosition: StockPosition.coLeader,
                                    );
                                  },
                                  shadowBlurRadius: 3,
                                  borderColor: AppColors.black9A9A,
                                  backgroundColor:
                                      state.selectedStockList[index].stockPosition == StockPosition.coLeader
                                          ? AppColors.purple5A2F
                                          : AppColors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextView(
                                        text: "CL",
                                        fontSize: 14.sp,
                                        fontColor:
                                            state.selectedStockList[index].stockPosition == StockPosition.coLeader
                                                ? AppColors.white
                                                : AppColors.black9A9A,
                                        lineHeight: 0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      Transform.translate(
                                        offset: const Offset(0, -3),
                                        child: TextView(
                                          text: "${state.selectedStockList[index].flexSelectionPercentage ?? ''}%",
                                          fontColor:
                                              state.selectedStockList[index].stockPosition == StockPosition.coLeader
                                                  ? AppColors.white
                                                  : AppColors.black9A9A,
                                          fontSize: 6.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CircularIconWidget(
                                  onPressed: () {
                                    final oldStock = state.selectedStockList[index];
                                    final isSelected = state.selectedStockList.any(
                                      (stock) =>
                                          (stock.stockPosition == StockPosition.viceLeader &&
                                              stock == state.selectedStockList[index]),
                                    );
                                    final updatedStock = Stock(
                                      stockName: oldStock.stockName,
                                      id: oldStock.id,
                                      stockPrice: oldStock.stockPrice,
                                      percentage: oldStock.percentage,
                                      image: oldStock.image,
                                      netChange: oldStock.netChange,
                                      currentPrice: oldStock.currentPrice,
                                      stockPrediction: oldStock.stockPrediction,
                                      stockPosition: isSelected ? StockPosition.none : StockPosition.viceLeader,
                                      selectionPercentage: stock.selectionPercentage,
                                      captainSelectionPercentage: stock.captainSelectionPercentage,
                                      viceCaptainSelectionPercentage: stock.viceCaptainSelectionPercentage,
                                      flexSelectionPercentage: stock.flexSelectionPercentage,
                                      upPredictionPercentage: stock.upPredictionPercentage,
                                      downPredictionPercentage: stock.downPredictionPercentage,
                                      lastUpdated: stock.lastUpdated,
                                      livePoints: stock.livePoints,
                                      isLiveData: stock.isLiveData,
                                    );
                                    cubit.updateSelectedStock(
                                      stock: updatedStock,
                                      index: index,
                                      stockPosition: StockPosition.viceLeader,
                                    );
                                  },
                                  borderColor: AppColors.black9A9A,
                                  backgroundColor:
                                      state.selectedStockList[index].stockPosition == StockPosition.viceLeader
                                          ? AppColors.purple5A2F
                                          : AppColors.white,
                                  shadowBlurRadius: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextView(
                                        text: "VL",
                                        fontSize: 14.sp,
                                        fontColor:
                                            state.selectedStockList[index].stockPosition == StockPosition.viceLeader
                                                ? AppColors.white
                                                : AppColors.black9A9A,
                                        lineHeight: 0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      Transform.translate(
                                        offset: const Offset(0, -3),
                                        child: TextView(
                                          text:
                                              "${state.selectedStockList[index].viceCaptainSelectionPercentage ?? ''}%",
                                          fontColor:
                                              state.selectedStockList[index].stockPosition == StockPosition.viceLeader
                                                  ? AppColors.white
                                                  : AppColors.black9A9A,
                                          fontSize: 6.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                            : Row(
                              spacing: 7.w,
                              children: [
                                CircularIconWidget(
                                  onPressed: onUpPressed,
                                  icon: Icons.arrow_upward,
                                  iconSize: 18.sp,
                                  borderColor:
                                      (state.stockList[index].stockPrediction == StockPrediction.up)
                                          ? AppColors.white
                                          : AppColors.green0CAE,
                                  boxShadowColor: AppColors.green0CAE,
                                  shadowBlurRadius: 2,
                                  backgroundColor:
                                      (state.stockList[index].stockPrediction == StockPrediction.up)
                                          ? AppColors.green0CAE
                                          : AppColors.white,
                                  iconColor:
                                      (state.stockList[index].stockPrediction == StockPrediction.up)
                                          ? AppColors.white
                                          : AppColors.green0CAE,
                                ),
                                SizedBox(),
                                CircularIconWidget(
                                  onPressed: onDownPressed,
                                  icon: Icons.arrow_downward_rounded,
                                  iconSize: 18.sp,
                                  borderColor:
                                      (state.stockList[index].stockPrediction == StockPrediction.down)
                                          ? AppColors.white
                                          : AppColors.red,
                                  boxShadowColor: AppColors.red,
                                  shadowBlurRadius: 2,
                                  backgroundColor:
                                      (state.stockList[index].stockPrediction == StockPrediction.down)
                                          ? AppColors.red
                                          : AppColors.white,
                                  iconColor:
                                      (state.stockList[index].stockPrediction == StockPrediction.down)
                                          ? AppColors.white
                                          : AppColors.red,
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 60.w,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 75.w, maxWidth: 155.w),
                    child: Container(
                      padding: EdgeInsets.only(top: 8.h, left: 6.w, right: 6.w, bottom: 5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(6.r),
                          bottomRight: Radius.circular(6.r),
                        ),
                        boxShadow: [BoxShadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 7.1)],
                      ),
                      child: TextView(
                        text: stock.stockName ?? '',
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class CircularIconWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? boxShadowColor;
  final Color? borderColor;
  final Color? iconColor;
  final double? borderWidth;
  final double? shadowBlurRadius;
  final IconData? icon;
  final VoidCallback onPressed;
  final double? iconSize;
  final Widget? child;

  const CircularIconWidget({
    super.key,
    this.height,
    this.width,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1.0,
    this.shadowBlurRadius = 1.0,
    this.icon,
    this.boxShadowColor,
    this.iconColor,
    this.child,
    this.iconSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? 30.h,
        width: width ?? 30.w,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor!, width: borderWidth!),
          boxShadow: [
            BoxShadow(
              color: boxShadowColor ?? AppColors.white,
              offset: const Offset(0, 0),
              blurRadius: shadowBlurRadius!,
            ),
          ],
        ),
        child: child ?? Icon(icon ?? Icons.circle, color: iconColor, size: iconSize, opticalSize: 48),
      ),
    );
  }
}
