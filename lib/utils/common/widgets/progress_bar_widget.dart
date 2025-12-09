import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class ProgressBarWidget extends StatefulWidget {
  final double value;
  final double total;
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final double borderRadius;
  final double markPosition; // 0.0 to 1.0
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
    this.markPosition = 0.7,
    this.markWidth = 3.0,
    this.markColor = AppColors.primaryPurple,
  });

  @override
  State<ProgressBarWidget> createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget> {
  @override
  Widget build(BuildContext context) {
    final double progress = (widget.total == 0) ? 0 : (widget.value / widget.total).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;
        final markLeft = (widget.markPosition.clamp(0.0, 1.0)) * barWidth;

        return Stack(
          children: [
            // Background bar
            Container(
              height: widget.height.h,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
              ),
            ),
            // Progress bar
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                height: widget.height.h,
                decoration: BoxDecoration(
                  color: widget.progressColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius.r),
                ),
              ),
            ),
            // Mark with tap
            Positioned(
              left: markLeft - (widget.markWidth / 2),
              top: 0,
              bottom: 0,
              child: Container(width: widget.markWidth.w, color: widget.markColor),
            ),
          ],
        );
      },
    );
  }
}
