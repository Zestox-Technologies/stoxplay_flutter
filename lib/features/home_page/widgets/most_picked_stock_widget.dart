import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/features/home_page/data/models/most_picked_stock_model.dart';
import 'package:stoxplay/utils/common/widgets/cached_image_widget.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class MostPickedStockWidget extends StatelessWidget {
  final MostPickedStock data;

  const MostPickedStockWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color:
                ((data.upPredictionCount?.toInt() ?? 0) > (data.downPredictionCount?.toInt() ?? 0))
                    ? AppColors.green38EE
                    : AppColors.red,
            offset: const Offset(0, 0),
            blurRadius: 1,
            spreadRadius: 0.5,
          ),
        ],
        border: Border.all(color: AppColors.green9FFF, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.black6767, width: 0.5),
                ),
                child: ClipOval(child: SVGImageWidget(imageUrl: data.logoUrl ?? '', height: 35.h, width: 35.w)),
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextView(text: data.name ?? '', fontWeight: FontWeight.w500, fontSize: 16.sp),
                  TextView(
                    text: '₹${data.currentPrice ?? 0} (${data.percentageChange ?? 0}%) ',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ],
              ),
            ],
          ),
          TextView(
            text: data.sectorName ?? '',
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            fontColor: AppColors.primaryPurple,
          ),
        ],
      ),
    );
  }
}
