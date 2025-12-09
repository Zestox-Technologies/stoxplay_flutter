import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/features/home_page/data/models/live_stock_model.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

/// Widget that displays the stats bar showing points, rank, and live status.
class BattlegroundStatsBar extends StatelessWidget {
  final ScoreUpdatePayload? data;

  const BattlegroundStatsBar({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.white.withOpacity(0.15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextView(
            text: "Points - ${data?.totalPoints ?? 'NA'}",
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            fontColor: AppColors.white,
          ),
          TextView(
            text: "Rank - ${data?.rank ?? 'NA'}",
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            fontColor: AppColors.white,
          ),
          if (data?.isLive == true)
            Row(
              children: [
                const _BlinkingDot(),
                const SizedBox(width: 6),
                Text(
                  "LIVE",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// A blinking red dot indicator for live status
class _BlinkingDot extends StatefulWidget {
  const _BlinkingDot();

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Icon(Icons.circle, color: Colors.red, size: 14),
    );
  }
}
