import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class ProgressBarWidget extends StatelessWidget {
  final double value; // Current value (e.g., spots filled)
  final double total; // Total value (e.g., total spots)
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final double borderRadius;
  final double markPosition; // 0.0 to 1.0 (e.g., 0.7 for 70%)
  final double markWidth;
  final Color markColor;

  const ProgressBarWidget({
    super.key,
    required this.value,
    required this.total,
    this.height = 5.0,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = const Color(0xFF6A1B9A),
    this.borderRadius = 20.0,
    this.markPosition = 0.7, // 70%
    this.markWidth = 3.0,
    this.markColor = AppColors.primaryPurple,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (total == 0) ? 0 : (value / total).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;
        final markLeft = (markPosition.clamp(0.0, 1.0)) * barWidth;

        return Stack(
          children: [
            // Background bar
            Container(
              height: height.h,
              decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(borderRadius.r)),
            ),
            // Progress bar
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                height: height.h,
                decoration: BoxDecoration(color: progressColor, borderRadius: BorderRadius.circular(borderRadius.r)),
              ),
            ),
            // Vertical mark at 70%
            Positioned(
              left: markLeft - (markWidth / 2), // Center the mark
              top: 0,
              bottom: 0,
              child: Container(width: markWidth.w, color: markColor),
            ),
          ],
        );
      },
    );
  }
}
