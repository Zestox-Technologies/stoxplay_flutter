import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/home_page/data/models/stock_data_model.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/cubit/stock_selection_cubit.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/stock_selection_screen.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/widgets/stock_table_header.dart';
import 'package:stoxplay/features/home_page/widgets/stock_selection_widget.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';

class PositionSelectionStep extends StatelessWidget {
  final StockSelectionCubit cubit;
  final StockSelectionState state;
  final ValueNotifier<int> stepper;

  const PositionSelectionStep({
    required this.cubit,
    required this.state,
    required this.stepper,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => stepper.value--,
                child: const Icon(Icons.arrow_back_ios_new),
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
        _buildPositionInfo(),
        Gap(8.h),
        StockTableHeader(isFirstStep: false),
        Gap(5.h),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              separatorBuilder: (context, index) => Gap(8.h),
              itemCount: state.selectedStockList.length,
              itemBuilder: (context, index) => StockSelectionWidget(
                key: ValueKey(state.selectedStockList[index].id),
                cubit: cubit,
                stock: state.selectedStockList[index],
                stepper: stepper,
                index: index,
                onUpPressed: () => _handleUpPressed(index),
                onDownPressed: () => _handleDownPressed(index),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPositionInfo() {
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildPositionColumn("Leader", "Get 10X Points"),
            const VerticalDivider(width: 2),
            _buildPositionColumn("Co-Leader", "Get 7.5X Points"),
            const VerticalDivider(width: 2),
            _buildPositionColumn("Vice-Leader", "Get 5X Points"),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionColumn(String title, String subtitle) {
    return Column(
      children: [
        TextView(
          text: title,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          fontColor: AppColors.purple661F,
        ),
        TextView(
          text: subtitle,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  void _handleUpPressed(int index) {
    // Handle up button press for position selection
    // This would typically assign leader position
    final stock = state.selectedStockList[index];
    cubit.updateSelectedStock(
      stock: stock,
      index: index,
      stockPosition: StockPosition.leader,
    );
  }

  void _handleDownPressed(int index) {
    // Handle down button press for position selection
    // This would typically assign co-leader position
    final stock = state.selectedStockList[index];
    cubit.updateSelectedStock(
      stock: stock,
      index: index,
      stockPosition: StockPosition.coLeader,
    );
  }
} 