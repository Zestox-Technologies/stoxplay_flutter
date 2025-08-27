import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/core/di/service_locator.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/cubit/stock_selection_cubit.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/widgets/confirmation_bottom_sheet.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/widgets/stock_selection_shimmer.dart';
import 'package:stoxplay/features/home_page/widgets/stock_selection_widget.dart';
import 'package:stoxplay/utils/common/cubits/timer_cubit.dart';
import 'package:stoxplay/utils/common/widgets/common_bottom_navbar.dart';
import 'package:stoxplay/utils/common/widgets/primary_container.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/models/contest_model.dart';

class StockSelectionScreen extends StatefulWidget {
  const StockSelectionScreen({super.key});

  @override
  State<StockSelectionScreen> createState() => _StockSelectionScreenState();
}

class _StockSelectionScreenState extends State<StockSelectionScreen> {
  StockSelectionCubit cubit = StockSelectionCubit(
    stockListUseCase: sl(),
    joinContestUseCase: sl(),
    clientTeamsUseCase: sl(),
  );
  ValueNotifier<int> stepper = ValueNotifier<int>(0);
  String? contestId;
  String? price;
  String? teamId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final map = ModalRoute.of(context)!.settings.arguments as Map<String?, String?>;
      contestId = map['contestId'];
      cubit.getStockList(contestId!);

      price = map['price'];
      Future.delayed(Duration(seconds: 1), () {
        if (map['teamId'] != null) {
          cubit.clientTeams(teamId: map['teamId'] ?? '',isPostApi: false);
        }
      });
    });
  }

  @override
  void dispose() {
    cubit.timerCubit.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context)!.settings.arguments as Map<String?, String?>;

    return ValueListenableBuilder(
      valueListenable: stepper,
      builder: (context, steps, _) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              return;
            }
            if (stepper.value == 0) {
              Navigator.pop(context);
            } else {
              stepper.value--;
            }
          },
          child: MultiBlocProvider(
            providers: [BlocProvider.value(value: cubit), BlocProvider.value(value: cubit.timerCubit)],
            child: BlocBuilder<StockSelectionCubit, StockSelectionState>(
              bloc: cubit,
              builder: (context, state) {
                final isFirstStep = stepper.value == 0;
                final isStockSelectionComplete = state.selectedStockList.length == 11;
                final hasLeader = state.selectedStockList.any((e) => e.stockPosition.isLeader);
                final hasCoLeader = state.selectedStockList.any((e) => e.stockPosition.isCoLeader);
                final hasViceLeader = state.selectedStockList.any((e) => e.stockPosition.isViceLeader);

                final isPositionSelectionComplete = hasLeader && hasCoLeader && hasViceLeader;
                final buttonColor =
                    isFirstStep
                        ? (isStockSelectionComplete ? AppColors.primaryPurple : AppColors.black9A9A)
                        : (isPositionSelectionComplete ? AppColors.primaryPurple : AppColors.black9A9A);
                return Scaffold(
                  backgroundColor: Colors.white,
                  bottomNavigationBar: CommonBottomNavbar(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                      child: GestureDetector(
                        onTap: () async {
                          if (stepper.value == 0) {
                            if (state.selectedStockList.length == 11) {
                              stepper.value++;
                            }
                          } else {
                            if (isPositionSelectionComplete && map['teamId'] == null) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ConfirmationBs(
                                    cubit: cubit,
                                    stepper: stepper,
                                    contestId: contestId ?? '',
                                    price: price ?? '',
                                  );
                                },
                              );
                            } else {
                              if (map['teamId'] != null) {
                                await cubit.clientTeams(isPostApi: true, teamId: map['teamId'] ?? '');
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                        child: PrimaryContainer(
                          color: buttonColor,
                          child: Padding(
                            padding: EdgeInsets.all(3.h),
                            child: TextView(
                              textAlign: TextAlign.center,
                              text:
                                  (stepper.value == 1 && map['teamId'] != null)
                                      ? Strings.update
                                      : Strings.next.toUpperCase(),
                              fontColor: buttonColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  body:
                      state.apiStatus.isLoading
                          ? StockSelectionShimmer()
                          : Stack(
                            children: [
                              Positioned(top: 0.0, child: Image.asset(AppAssets.lightSplashStrokes, height: 250.h)),
                              SafeArea(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: stepper.value == 0 ? 10.h : 0,
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                      ),
                                      child:
                                          stepper.value == 0
                                              ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(Icons.arrow_back_ios_new),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      Strings.selectStocks,
                                                      style: selectStocksStyle,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Gap(10.h),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          Strings.pick11StocksFrom30,
                                                          style: TextStyle(
                                                            fontSize: 13.sp,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                        BlocBuilder<TimerCubit, TimerState>(
                                                          builder: (context, timerState) {
                                                            if (timerState.isRunning) {
                                                              final duration = Duration(
                                                                seconds: timerState.secondsRemaining,
                                                              );
                                                              final hours = duration.inHours
                                                                  .remainder(24)
                                                                  .toString()
                                                                  .padLeft(2, '0');
                                                              final minutes = duration.inMinutes
                                                                  .remainder(60)
                                                                  .toString()
                                                                  .padLeft(2, '0');
                                                              final seconds = duration.inSeconds
                                                                  .remainder(60)
                                                                  .toString()
                                                                  .padLeft(2, '0');

                                                              return Text('Time Left: $hours:$minutes:$seconds');
                                                            } else {
                                                              return const Text('');
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Gap(5.h),
                                                  Center(
                                                    child: SizedBox(
                                                      height: 12.h,
                                                      child: ListView.builder(
                                                        itemCount: 11,
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis.horizontal,
                                                        itemBuilder: (context, index) {
                                                          return Container(
                                                            width: 23.w,
                                                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  index >= state.selectedStockList.length
                                                                      ? AppColors.black9A9A.withOpacity(0.5)
                                                                      : AppColors.primaryPurple,
                                                              borderRadius: BorderRadius.circular(4.r),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                '${index + 1}',
                                                                style: TextStyle(
                                                                  fontSize: 10.sp,
                                                                  fontWeight: FontWeight.bold,
                                                                  color:
                                                                      index >= state.selectedStockList.length
                                                                          ? AppColors.black
                                                                          : AppColors.white,
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Gap(18.h),
                                                ],
                                              )
                                              : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 10.w),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            stepper.value--;
                                                          },
                                                          child: Icon(Icons.arrow_back_ios_new),
                                                        ),
                                                        Gap(5.w),
                                                        TextView(
                                                          text: "Select",
                                                          fontSize: 20.sp,
                                                          textAlign: TextAlign.center,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                        Gap(2.w),
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 3.h),
                                                          child: TextView(
                                                            text: "(Pick your 3 dominating stocks)",
                                                            textAlign: TextAlign.center,
                                                            fontSize: 10.sp,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IntrinsicHeight(
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              TextView(
                                                                text: "Leader",
                                                                fontSize: 18.sp,
                                                                fontWeight: FontWeight.w600,
                                                                fontColor: AppColors.primaryPurple,
                                                              ),
                                                              TextView(
                                                                text: "Get 10X Points",
                                                                fontSize: 12.sp,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ],
                                                          ),
                                                          VerticalDivider(width: 2),
                                                          Column(
                                                            children: [
                                                              TextView(
                                                                text: "Co-Leader",
                                                                fontSize: 18.sp,
                                                                fontWeight: FontWeight.w600,
                                                                fontColor: AppColors.primaryPurple,
                                                              ),
                                                              TextView(
                                                                text: "Get 7.5X Points",
                                                                fontSize: 12.sp,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ],
                                                          ),
                                                          VerticalDivider(width: 2),
                                                          Column(
                                                            children: [
                                                              TextView(
                                                                text: "Vice-Leader",
                                                                fontSize: 18.sp,
                                                                fontWeight: FontWeight.w600,
                                                                fontColor: AppColors.primaryPurple,
                                                              ),
                                                              TextView(
                                                                text: "Get 5X Points",
                                                                fontSize: 12.sp,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                    ),
                                    if (stepper.value == 1) Gap(8.h),
                                    if (stepper.value == 0)
                                      Container(
                                        width: double.infinity,
                                        height: 15.h,
                                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.black9A9A.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(5.r),
                                        ),
                                        child: Table(
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          columnWidths: {
                                            0: FixedColumnWidth(60.w), // ID or Icon space
                                            1: FixedColumnWidth(150.w), // Stock name
                                            2: FixedColumnWidth(60.w), // Sel %
                                            3: FixedColumnWidth(100.w), // Analysis
                                          },
                                          children: [
                                            TableRow(
                                              children: [
                                                TextView(text: "", fontSize: 11.sp),
                                                TextView(text: "Stock", fontSize: 11.sp),
                                                TextView(text: "Sel %", fontSize: 11.sp),
                                                TextView(text: "Analysis", fontSize: 11.sp),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Container(
                                        width: double.infinity,
                                        height: 15.h,
                                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.black9A9A.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(5.r),
                                        ),
                                        child: Table(
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          columnWidths: {
                                            0: FixedColumnWidth(50.w),
                                            1: FixedColumnWidth(160.w),
                                            2: FixedColumnWidth(20.w),
                                            3: FixedColumnWidth(20.w),
                                            4: FixedColumnWidth(20.w),
                                          },
                                          children: [
                                            TableRow(
                                              children: [
                                                TextView(text: "", fontSize: 11.sp),
                                                TextView(text: "Stock", fontSize: 11.sp),
                                                TextView(text: "L%", fontSize: 11.sp),
                                                TextView(text: "CL%", fontSize: 11.sp),
                                                TextView(text: "VL%", fontSize: 11.sp),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    Gap(5.h),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0.w),
                                        child: ListView.separated(
                                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                                          separatorBuilder: (context, index) => Gap(8.h),
                                          itemCount:
                                              stepper.value == 0
                                                  ? state.stockList.length
                                                  : state.selectedStockList.length,
                                          itemBuilder:
                                              (context, index) => StockSelectionWidget(
                                                cubit: cubit,
                                                stock:
                                                    stepper.value == 0
                                                        ? state.stockList[index]
                                                        : state.selectedStockList[index],
                                                stepper: stepper,
                                                index: index,
                                                onUpPressed: () {
                                                  final oldStock = state.stockList[index];
                                                  final isSelected = state.selectedStockList.any(
                                                    (stock) => stock.id == oldStock.id,
                                                  );
                                                  if (state.selectedStockList.length >= 11 && !isSelected) {
                                                    return;
                                                  }
                                                  final currentPrediction = oldStock.stockPrediction;
                                                  if (isSelected) {
                                                    if (currentPrediction == StockPrediction.up) {
                                                      cubit.removeSelectedStock(stock: oldStock);
                                                      final updatedStock = oldStock.copyWith(
                                                        stockPrediction: StockPrediction.none,
                                                      );
                                                      cubit.updateStock(stock: updatedStock, index: index);
                                                    } else if (currentPrediction == StockPrediction.down) {
                                                      cubit.updateSelectedStockPrediction(
                                                        stockPrediction: StockPrediction.up,
                                                        stock: oldStock,
                                                      );
                                                      final updatedStock = oldStock.copyWith(
                                                        stockPrediction: StockPrediction.up,
                                                      );
                                                      cubit.updateStock(stock: updatedStock, index: index);
                                                    }
                                                  } else {
                                                    if (!isSelected) {
                                                      final updatedStock = oldStock.copyWith(
                                                        stockPrediction: StockPrediction.up,
                                                      );
                                                      cubit.addSelectedStock(stock: updatedStock);
                                                    }
                                                    final updatedStock = oldStock.copyWith(
                                                      stockPrediction: StockPrediction.up,
                                                    );
                                                    cubit.updateStock(stock: updatedStock, index: index);
                                                  }
                                                },
                                                onDownPressed: () {
                                                  final oldStock = state.stockList[index];

                                                  final isSelected = state.selectedStockList.any(
                                                    (stock) => stock.id == oldStock.id,
                                                  );

                                                  final currentPrediction = oldStock.stockPrediction;

                                                  if (state.selectedStockList.length >= 11 && !isSelected) {
                                                    return;
                                                  }

                                                  if (isSelected) {
                                                    if (currentPrediction == StockPrediction.down) {
                                                      cubit.removeSelectedStock(stock: oldStock);

                                                      final updatedStock = oldStock.copyWith(
                                                        stockPrediction: StockPrediction.none,
                                                      );
                                                      cubit.updateStock(stock: updatedStock, index: index);
                                                    } else if (currentPrediction == StockPrediction.up) {
                                                      cubit.updateSelectedStockPrediction(
                                                        stockPrediction: StockPrediction.down,
                                                        stock: oldStock,
                                                      );
                                                      final updatedStock = oldStock.copyWith(
                                                        stockPrediction: StockPrediction.down,
                                                      );
                                                      cubit.updateStock(stock: updatedStock, index: index);
                                                    }
                                                  } else {
                                                    final updatedStock = oldStock.copyWith(
                                                      stockPrediction: StockPrediction.down,
                                                    );
                                                    cubit.addSelectedStock(stock: updatedStock);
                                                    cubit.updateStock(stock: updatedStock, index: index);
                                                  }
                                                },
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

enum StockPrediction {
  up,
  down,
  none;

  bool get isUp => this == StockPrediction.up;

  bool get isDown => this == StockPrediction.down;

  bool get isNone => this == StockPrediction.none;

  String get toName => toString().split('.').last.toUpperCase();
}

enum StockPosition {
  leader,
  coLeader,
  viceLeader,
  none;

  bool get isLeader => this == StockPosition.leader;

  bool get isCoLeader => this == StockPosition.coLeader;

  bool get isViceLeader => this == StockPosition.viceLeader;
}
