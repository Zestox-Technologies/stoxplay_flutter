import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/features/home_page/data/models/live_stock_model.dart';
import 'package:stoxplay/features/home_page/pages/battleground_page/widgets/battleground_item_widget.dart';

/// Widget that displays the stock grid layout for the battleground page.
///
/// This widget handles the positioning and layout of all stock items
/// based on their roles (CAPTAIN, VICE_CAPTAIN, FLEX, NORMAL).
class BattlegroundStockGrid extends StatelessWidget {
  final ScoreUpdatePayload? data;

  const BattlegroundStockGrid({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fallbackStock = LiveStock(
      stockId: '0',
      percentageChange: 0,
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

    final normalList = data?.liveStocks.where((element) => element.role.toUpperCase() == "NORMAL").toList();

    return Column(
      children: [
        // Top row - 3 normal stocks
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BattlegroundItemWidget(
              data: (normalList != null && normalList.isNotEmpty) ? normalList[0] : fallbackStock,
            ),
            BattlegroundItemWidget(
              data: (normalList != null && normalList.length > 1) ? normalList[1] : fallbackStock,
            ),
            BattlegroundItemWidget(
              data: (normalList != null && normalList.length > 2) ? normalList[2] : fallbackStock,
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // Second row - FLEX and 1 normal stock
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(width: 20.w),
            BattlegroundItemWidget(data: findByRole("FLEX") ?? fallbackStock),
            BattlegroundItemWidget(
              data: (normalList != null && normalList.length > 3) ? normalList[3] : fallbackStock,
            ),
            SizedBox(width: 20.w),
          ],
        ),
        SizedBox(height: 20.h),

        // Center - CAPTAIN
        BattlegroundItemWidget(data: findByRole("CAPTAIN") ?? fallbackStock),
        SizedBox(height: 20.h),

        // Fourth row - 1 normal stock and VICE_CAPTAIN
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(width: 20.w),
            BattlegroundItemWidget(
              data: (normalList != null && normalList.length > 4) ? normalList[4] : fallbackStock,
            ),
            BattlegroundItemWidget(data: findByRole("VICE_CAPTAIN") ?? fallbackStock),
            SizedBox(width: 20.w),
          ],
        ),
        SizedBox(height: 20.h),

        // Bottom row - 3 normal stocks
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BattlegroundItemWidget(
              data: (normalList != null && normalList.length > 5) ? normalList[5] : fallbackStock,
            ),
            BattlegroundItemWidget(
              data: (normalList != null && normalList.length > 6) ? normalList[6] : fallbackStock,
            ),
            BattlegroundItemWidget(
              data: (normalList != null && normalList.length > 7) ? normalList[7] : fallbackStock,
            ),
          ],
        ),
      ],
    );
  }
}
