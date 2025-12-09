import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/features/home_page/data/models/live_stock_model.dart';
import 'package:stoxplay/features/home_page/pages/battleground_page/managers/battleground_websocket_manager.dart';
import 'package:stoxplay/features/home_page/pages/battleground_page/models/battleground_arguments.dart';
import 'package:stoxplay/features/home_page/pages/battleground_page/widgets/battleground_app_bar.dart';
import 'package:stoxplay/features/home_page/pages/battleground_page/widgets/battleground_stats_bar.dart';
import 'package:stoxplay/features/home_page/pages/battleground_page/widgets/battleground_stock_grid.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';

class BattlegroundPage extends StatefulWidget {
  const BattlegroundPage({super.key});

  @override
  State<BattlegroundPage> createState() => _BattlegroundPageState();
}

class _BattlegroundPageState extends State<BattlegroundPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  BattlegroundWebSocketManager? _wsManager;
  late HomeCubit _homeCubit;

  late BattlegroundArguments _arguments;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) return;
    _isInitialized = true;

    // Get cubit from context
    _homeCubit = BlocProvider.of<HomeCubit>(context);

    // Get arguments from route
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is BattlegroundArguments) {
      _arguments = args;
    } else {
      // Fallback for backward compatibility with tuple format
      final tuple = args as (String, String);
      _arguments = BattlegroundArguments(teamId: tuple.$1, teamName: tuple.$2);
    }

    // Conditional logic: Use WebSocket for live, API for non-live
    if (_arguments.isFromLive) {
      // Use WebSocket for live contests
      _wsManager = BattlegroundWebSocketManager();
      _wsManager!.connect(_arguments.teamId);
    } else {
      // Use API for non-live contests
      _homeCubit.getBattlegroundData(_arguments.teamId);
    }
  }

  @override
  void dispose() {
    _wsManager?.dispose();
    super.dispose();
  }

  void _handleBackNavigation() {
    Navigator.popUntil(context, (route) {
      if (route.settings.name == AppRoutes.completedDetailsScreen) {
        return true;
      }
      return route.settings.name == AppRoutes.mainPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Screenshot(
          controller: _screenshotController,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // Background image
                Positioned.fill(child: Image.asset(AppAssets.battleground, fit: BoxFit.cover)),

                // Content - Conditional rendering based on data source
                _arguments.isFromLive ? _buildWebSocketContent() : _buildApiContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build content using WebSocket data (for live contests)
  Widget _buildWebSocketContent() {
    return ValueListenableBuilder<ScoreUpdatePayload?>(
      valueListenable: _wsManager!.scoreNotifier,
      builder: (context, data, _) {
        return _buildBattlegroundContent(data);
      },
    );
  }

  /// Build content using API data (for non-live contests)
  Widget _buildApiContent() {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: _homeCubit,
      builder: (context, state) {
        if (state.battlegroundApiStatus.isLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.white));
        }

        if (state.battlegroundApiStatus.isFailed) {
          return Center(child: Text('Failed to load battleground data', style: TextStyle(color: AppColors.white)));
        }

        return _buildBattlegroundContent(state.battlegroundData);
      },
    );
  }

  /// Common UI builder for battleground content
  Widget _buildBattlegroundContent(ScoreUpdatePayload? data) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: IntrinsicHeight(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 5),

              // App Bar
              BattlegroundAppBar(
                teamName: _arguments.teamName,
                data: data,
                screenshotController: _screenshotController,
                onBack: _handleBackNavigation,
              ),

              // Divider
              Container(color: AppColors.white.withOpacity(0.2), width: MediaQuery.of(context).size.width, height: 1.h),
              SizedBox(height: 20.h),

              // Contest name section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: SizedBox(child: Divider(color: AppColors.white, thickness: 2))),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: TextView(
                        text: data?.contestName ?? 'BattleGround',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        fontColor: AppColors.white,
                      ),
                    ),
                    Expanded(child: SizedBox(child: Divider(color: AppColors.white, thickness: 2))),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Stats bar
              BattlegroundStatsBar(data: data),
              SizedBox(height: 30.h),

              // Stock grid
              BattlegroundStockGrid(data: data),
              SizedBox(height: 30.h),

              // Footer text
              Text(
                'STOXPLAY GROUND',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 28.sp,
                  height: 1.0,
                  letterSpacing: 0.0,
                  color: Colors.white.withOpacity(0.3),
                  shadows: [Shadow(offset: Offset(1, 7), blurRadius: 4, color: AppColors.black.withOpacity(0.3))],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

// Triangle painter kept for backward compatibility
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
