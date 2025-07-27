import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/core/di/service_locator.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/cubit/stock_selection_cubit.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/widgets/stock_selection_shimmer.dart';
import 'package:stoxplay/features/home_page/widgets/stock_selection_widget.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/utils/models/contest_model.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/common/widgets/common_bottom_navbar.dart';
import 'package:stoxplay/utils/common/widgets/primary_container.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_constants.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class StockSelectionScreen extends StatefulWidget {
  const StockSelectionScreen({super.key});

  @override
  State<StockSelectionScreen> createState() => _StockSelectionScreenState();
}

class _StockSelectionScreenState extends State<StockSelectionScreen> {
  StockSelectionCubit cubit = StockSelectionCubit(stockListUseCase: sl(), joinContestUseCase: sl());
  ValueNotifier<int> stepper = ValueNotifier<int>(0);
  late HomeCubit homeCubit;
  String? contestId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      contestId = ModalRoute.of(context)!.settings.arguments as String;
      cubit.getStockList(contestId!);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: BlocProvider.value(
            value: cubit,
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
                        onTap: () {
                          if (stepper.value == 0) {
                            if (state.selectedStockList.length == 11) {
                              stepper.value++;
                            }
                          } else {
                            if (isPositionSelectionComplete) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ConfirmationBs(cubit: cubit, contestId: contestId ?? '');
                                },
                              );
                            } else {
                              return;
                            }
                          }
                        },
                        child: PrimaryContainer(
                          color: buttonColor,
                          child: Padding(
                            padding: EdgeInsets.all(3.h),
                            child: TextView(
                              textAlign: TextAlign.center,
                              text: Strings.next.toUpperCase(),
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
                                                        Text(
                                                          'Time Left (09:10:59)',
                                                          style: TextStyle(
                                                            fontSize: 13.sp,
                                                            fontWeight: FontWeight.w500,
                                                          ),
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

class ConfirmationBs extends StatelessWidget {
  final String contestId;
  final StockSelectionCubit cubit;

  const ConfirmationBs({required this.cubit, required this.contestId, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          spacing: 20.h,
          children: [
            SizedBox(),
            Text("Confirmation", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Entry", style: TextStyle(fontSize: 16.sp)),
                Row(
                  children: [
                    Image.asset(AppAssets.stoxplayCoin, height: 18.h, width: 18.w),
                    Text("500", style: TextStyle(fontSize: 16.sp)),
                  ],
                ),
              ],
            ),
            BlocListener<StockSelectionCubit, StockSelectionState>(
              bloc: cubit,
              listener: (context, state) {
                if (state.joinContestApiStatus.isSuccess) {
                  Navigator.pop(context);
                  Future.microtask(() {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.battleGroundScreen,
                      arguments: (cubit, state.joinContestResponse),
                    );
                  });
                } else if (state.joinContestApiStatus.isFailed) {
                  Fluttertoast.showToast(msg: state.message ?? "Join contest failed please try again later");
                }
              },
              child: BlocSelector<StockSelectionCubit, StockSelectionState, ApiStatus>(
                bloc: cubit,
                selector: (state) => state.joinContestApiStatus,
                builder: (context, state) {
                  return AppButton(
                    isLoading: state.isLoading,
                    text: "Join Contest",
                    onPressed: () => cubit.joinContest(contestId),
                  );
                },
              ),
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
