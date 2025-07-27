import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressBarWidget extends StatelessWidget {
  final double value; // Current value (e.g., spots filled)
  final double total; // Total value (e.g., total spots)
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final double borderRadius;

  const ProgressBarWidget({
    super.key,
    required this.value,
    required this.total,
    this.height = 5.0,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = const Color(0xFF6A1B9A),
    this.borderRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (total == 0) ? 0 : (value / total).clamp(0.0, 1.0);

    return Stack(
      children: [
        Container(
          height: height.h,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        ),
        FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            height: height.h,
            decoration: BoxDecoration(
              color: progressColor,
              borderRadius: BorderRadius.circular(borderRadius.r),
            ),
          ),
        ),
      ],
    );
  }
}
