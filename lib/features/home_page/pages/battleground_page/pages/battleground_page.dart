import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/features/auth/data/models/user_model.dart';
import 'package:stoxplay/features/home_page/pages/battleground_page/widgets/battleground_item_widget.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/cubit/stock_selection_cubit.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/stock_selection_screen.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';
import 'package:stoxplay/utils/models/contest_model.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class BattlegroundPage extends StatefulWidget {
  BattlegroundPage({super.key});

  @override
  State<BattlegroundPage> createState() => _BattlegroundPageState();
}

class _BattlegroundPageState extends State<BattlegroundPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  late UserModel userData;

  void getUserData() {
    dynamic data = StorageService().read(DBKeys.user);
    userData = UserModel.fromJson(data);
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StockSelectionCubit cubit = ModalRoute.of(context)!.settings.arguments as StockSelectionCubit;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.popUntil(context, (route) => route.settings.name == AppRoutes.mainPage);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // transparent background
          statusBarIconBrightness: Brightness.light, // white icons
          statusBarBrightness: Brightness.dark, // for iOS
        ),
        child: Screenshot(
          controller: screenshotController,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Positioned.fill(child: Image.asset(AppAssets.battleground, fit: BoxFit.cover)),
                BlocBuilder<StockSelectionCubit, StockSelectionState>(
                  bloc: cubit,
                  builder: (context, state) {
                    final fallbackStock = Stock(
                      id: '0',
                      stockName: '',
                      stockPrice: '0',
                      percentage: '0',
                      image: '',
                      stockPrediction: StockPrediction.none,
                      stockPosition: StockPosition.none,
                    );

                    final leaderStock = state.selectedStockList.firstWhere(
                      (s) => s.stockPosition == StockPosition.leader,
                      orElse: () => fallbackStock, // Provide a fallback if not found
                    );

                    final coLeaderStock = state.selectedStockList.firstWhere(
                      (s) => s.stockPosition == StockPosition.coLeader,
                      orElse: () => fallbackStock,
                    );

                    final viceLeaderStock = state.selectedStockList.firstWhere(
                      (s) => s.stockPosition == StockPosition.viceLeader,
                      orElse: () => fallbackStock,
                    );

                    return Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top + 5),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.popUntil(context, (route) => route.settings.name == AppRoutes.mainPage);
                              },
                              icon: Icon(Icons.arrow_back_ios_new, color: AppColors.white),
                            ),
                            Text(
                              userData.user?.firstName ?? 'Stoxplay',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 26,
                                height: 1.1,
                                letterSpacing: 1.17,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () async {
                                final image = await screenshotController.capture();
                                if (image == null) return;

                                final directory = await getTemporaryDirectory();
                                final imagePath = await File('${directory.path}/screenshot.png').create();
                                await imagePath.writeAsBytes(image);

                                final share = SharePlus.instance;
                                await share.share(
                                  ShareParams(
                                    text: "This is my stoxplay battleground Team",
                                    files: [XFile(imagePath.path)],
                                  ),
                                );
                              },
                              icon: Icon(Icons.share, color: AppColors.white),
                            ),
                          ],
                        ),
                        Container(
                          color: AppColors.white.withOpacity(0.2),
                          width: MediaQuery.of(context).size.width,
                          height: 1.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: Divider(color: AppColors.white, thickness: 2),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: TextView(
                                text: Strings.bankWars,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                fontColor: AppColors.white,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: Divider(color: AppColors.white, thickness: 2),
                            ),
                          ],
                        ),
                        Container(
                          height: 32.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.white.withOpacity(0.15),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextView(
                                text: "Points - 0.0",
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                fontColor: AppColors.white,
                              ),
                              TextView(
                                text: "Rank - 00",
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                fontColor: AppColors.white,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Icon(Icons.refresh, color: AppColors.white, size: 22.sp),
                                  ),
                                  SizedBox(width: 10.w),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.popUntil(
                                        context,
                                        (route) => route.settings.name == AppRoutes.stockSelectionScreen,
                                      );
                                    },
                                    child: Image.asset(AppAssets.editIcon, height: 18.h, width: 18.w),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BattlegroundItemWidget(data: state.selectedStockList.first),
                            BattlegroundItemWidget(data: state.selectedStockList[1]),
                            BattlegroundItemWidget(data: state.selectedStockList[2]),
                          ],
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 20.w),
                            BattlegroundItemWidget(data: coLeaderStock),
                            BattlegroundItemWidget(data: state.selectedStockList[3]),
                            SizedBox(width: 20.w),
                          ],
                        ),
                        Spacer(),
                        BattlegroundItemWidget(data: leaderStock),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 20.w),
                            BattlegroundItemWidget(data: state.selectedStockList[4]),
                            BattlegroundItemWidget(data: viceLeaderStock),
                            SizedBox(width: 20.w),
                          ],
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BattlegroundItemWidget(data: state.selectedStockList[5]),
                            BattlegroundItemWidget(data: state.selectedStockList[6]),
                            BattlegroundItemWidget(data: state.selectedStockList[7]),
                          ],
                        ),
                        Spacer(),
                        Text(
                          'STOXPLAY GROUND',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 28.sp,
                            height: 1.0,
                            letterSpacing: 0.0,
                            color: Colors.white.withOpacity(0.3),
                            shadows: [
                              Shadow(offset: Offset(1, 7), blurRadius: 4, color: AppColors.black.withOpacity(0.3)),
                            ],
                          ),
                        ),
                        Gap(5.h),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum TriangleDirection { up, down }

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final TriangleDirection direction;

  TrianglePainter({
    this.strokeColor = Colors.green,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.fill,
    this.direction = TriangleDirection.up,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = strokeColor.withOpacity(1.0)
          ..strokeWidth = strokeWidth
          ..style = paintingStyle;

    final path =
        (direction == TriangleDirection.up)
            ? getUpTrianglePath(size.width, size.height)
            : getDownTrianglePath(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  Path getUpTrianglePath(double width, double height) {
    return Path()
      ..moveTo(0, height)
      ..lineTo(width / 2, 0)
      ..lineTo(width, height)
      ..close();
  }

  Path getDownTrianglePath(double width, double height) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(width / 2, height)
      ..lineTo(width, 0)
      ..close();
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.direction != direction;
  }
}
