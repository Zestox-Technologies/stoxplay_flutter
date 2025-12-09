import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class StockTableHeader extends StatelessWidget {
  final bool isFirstStep;

  const StockTableHeader({
    required this.isFirstStep,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 15.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: AppColors.black9A9A.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: isFirstStep ? _firstStepColumnWidths : _secondStepColumnWidths,
        children: [
          TableRow(
            children: isFirstStep ? _firstStepHeaders : _secondStepHeaders,
          ),
        ],
      ),
    );
  }

  Map<int, TableColumnWidth> get _firstStepColumnWidths => {
    0: FixedColumnWidth(60.w), // ID or Icon space
    1: FixedColumnWidth(150.w), // Stock name
    2: FixedColumnWidth(60.w), // Sel %
    3: FixedColumnWidth(100.w), // Analysis
  };

  Map<int, TableColumnWidth> get _secondStepColumnWidths => {
    0: FixedColumnWidth(50.w),
    1: FixedColumnWidth(160.w),
    2: FixedColumnWidth(20.w),
    3: FixedColumnWidth(20.w),
    4: FixedColumnWidth(20.w),
  };

  List<Widget> get _firstStepHeaders => [
    TextView(text: "", fontSize: 11.sp),
    TextView(text: "Stock", fontSize: 11.sp),
    TextView(text: "Sel %", fontSize: 11.sp),
    TextView(text: "Analysis", fontSize: 11.sp),
  ];

  List<Widget> get _secondStepHeaders => [
    TextView(text: "", fontSize: 11.sp),
    TextView(text: "Stock", fontSize: 11.sp),
    TextView(text: "L%", fontSize: 11.sp),
    TextView(text: "CL%", fontSize: 11.sp),
    TextView(text: "VL%", fontSize: 11.sp),
  ];
} 