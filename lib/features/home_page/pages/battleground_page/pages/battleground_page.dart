import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/core/network/api_urls.dart';
import 'package:stoxplay/core/network/ws_service.dart';
import 'package:stoxplay/features/home_page/data/models/live_stock_model.dart';
import 'package:stoxplay/features/home_page/pages/battleground_page/widgets/battleground_item_widget.dart';
import 'package:stoxplay/features/profile_page/data/profile_model.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';
import 'package:web_socket/web_socket.dart';

class BattlegroundPage extends StatefulWidget {
  const BattlegroundPage({super.key});

  @override
  State<BattlegroundPage> createState() => _BattlegroundPageState();
}

class _BattlegroundPageState extends State<BattlegroundPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  late ProfileModel userData;
  late String teamId;
  WebSocketService ws = WebSocketService();
  late ValueNotifier<ScoreUpdatePayload?> liveStocksNotifier = ValueNotifier(null);

  void getUserData() {
    final raw = StorageService().read(DBKeys.user);
    if (raw == null) {
      throw Exception('User not logged in');
    } else if (raw is String) {
      userData = ProfileModel.fromJson(jsonDecode(raw));
    } else if (raw is Map<String, dynamic>) {
      userData = ProfileModel.fromJson(raw);
    } else {
      throw Exception('Invalid user data in storage: $raw');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData(); // Safe here — doesn't depend on context
  }

  @override
  void dispose() {
    ws.close();
    super.dispose();
  }

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) return;
    _isInitialized = true;

    final data = ModalRoute.of(context)?.settings.arguments as String;
    teamId = data;
    final token = StorageService().read<String>(DBKeys.userTokenKey);

    ws
        .connect(ApiUrls.wsUrl)
        .then((_) {
          ws.sendJson({"type": "SUBSCRIBE_TEAM", "token": token, "userTeamId": teamId});
          ws.events.listen((event) {
            switch (event) {
              case TextDataReceived(:final text):
                final decoded = jsonDecode(text);
                if (decoded['type'] == 'SCORE_UPDATE') {
                  final payload = ScoreUpdatePayload.fromJson(decoded['payload']);
                  if (payload.liveStocks.isNotEmpty) {
                    liveStocksNotifier.value = payload;
                  }
                }
                break;
              case CloseReceived(:final code, :final reason):
                break;
              case BinaryDataReceived(:final data):
                break;
            }
          });
        })
        .onError((error, stackTrace) {
          if (kDebugMode) {
            print(error.toString());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
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
                ValueListenableBuilder<ScoreUpdatePayload?>(
                  valueListenable: liveStocksNotifier,
                  builder: (context, data, _) {
                    final fallbackStock = LiveStock(
                      stockId: '0',
                      symbol: '',
                      currentPrice: 0,
                      netChange: 0,
                      points: 0,
                      role: 'NORMAL',
                      isPredictionCorrect: false,
                      logoUrl: '',
                      prediction: 'DOWN',
                    );

                    LiveStock? findByRole(String role) =>
                        data?.liveStocks.firstWhere((s) => s.role == role, orElse: () => fallbackStock);

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
                              userData.username ?? 'Stoxplay',
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
                                text: "Points - ${data?.totalPoints}",
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                fontColor: AppColors.white,
                              ),
                              TextView(
                                text: "Rank - ${data?.rank}",
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                fontColor: AppColors.white,
                              ),
                              // Row(
                              //   children: [
                              //     GestureDetector(
                              //       onTap: () {},
                              //       child: Icon(Icons.refresh, color: AppColors.white, size: 22.sp),
                              //     ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.popUntil(
                              //       context,
                              //       (route) => route.settings.name == AppRoutes.stockSelectionScreen,
                              //     );
                              //   },
                              //   child: Image.asset(AppAssets.editIcon, height: 18.h, width: 18.w),
                              // ),
                              // ],
                              // ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BattlegroundItemWidget(
                              data:
                                  (data?.liveStocks != null && data!.liveStocks.isNotEmpty)
                                      ? data.liveStocks[0]
                                      : fallbackStock,
                            ),
                            BattlegroundItemWidget(
                              data:
                                  (data?.liveStocks != null && data!.liveStocks.length > 1)
                                      ? data.liveStocks[1]
                                      : fallbackStock,
                            ),
                            BattlegroundItemWidget(
                              data:
                                  (data?.liveStocks != null && data!.liveStocks.length > 2)
                                      ? data.liveStocks[2]
                                      : fallbackStock,
                            ),
                          ],
                        ),

                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 20.w),
                            BattlegroundItemWidget(data: findByRole("FLEX") ?? fallbackStock),
                            BattlegroundItemWidget(
                              data:
                                  (data?.liveStocks != null && data!.liveStocks.length > 3)
                                      ? data.liveStocks[3]
                                      : fallbackStock,
                            ),
                            SizedBox(width: 20.w),
                          ],
                        ),
                        Spacer(),
                        BattlegroundItemWidget(data: findByRole("CAPTAIN") ?? fallbackStock),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 20.w),
                            BattlegroundItemWidget(
                              data:
                                  (data?.liveStocks != null && data!.liveStocks.length > 4)
                                      ? data.liveStocks[4]
                                      : fallbackStock,
                            ),
                            BattlegroundItemWidget(data: findByRole("VICE_CAPTAIN") ?? fallbackStock),
                            SizedBox(width: 20.w),
                          ],
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BattlegroundItemWidget(
                              data:
                                  (data?.liveStocks != null && data!.liveStocks.length > 5)
                                      ? data.liveStocks[5]
                                      : fallbackStock,
                            ),
                            BattlegroundItemWidget(
                              data:
                                  (data?.liveStocks != null && data!.liveStocks.length > 6)
                                      ? data.liveStocks[6]
                                      : fallbackStock,
                            ),
                            BattlegroundItemWidget(
                              data:
                                  (data?.liveStocks != null && data!.liveStocks.length > 7)
                                      ? data.liveStocks[7]
                                      : fallbackStock,
                            ),
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
