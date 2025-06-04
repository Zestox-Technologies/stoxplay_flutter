import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/features/home_page/widgets/contest_details_widget.dart';
import 'package:stoxplay/models/contest_model.dart';
import 'package:stoxplay/utils/common/widgets/common_appbar_title.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class WinningsScreen extends StatelessWidget {
  const WinningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ContestPrice data =
        ModalRoute.of(context)!.settings.arguments as ContestPrice;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: AppColors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: CommonAppbarTitle(),
        centerTitle: true,
        backgroundColor: AppColors.white,
        actions: [
          SizedBox(
            width: kToolbarHeight, // Match the space of the leading icon
          ),
        ],
      ),
      body: Column(
        children: [
          Container(height: 0.5.h, color: AppColors.black6666),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  Gap(10.h),
                  ContestDetailsWidget(data: data),
                  Gap(20.h),
                  Container(
                    width: double.infinity,
                    height: 30.h,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: AppColors.black9A9A.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextView(text: 'Rank'),
                        TextView(
                          text: "Winnings",
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 18.sp,
                        ),
                      ],
                    ),
                  ),
                  Gap(10.h),
                  Expanded(
                    child: ListView.separated(
                      itemCount: 18,
                      separatorBuilder: (context, index) => Gap(10.h),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextView(text: '${index + 1}'),
                              Row(
                                children: [
                                  TextView(
                                    text: "1000",
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 18.sp,
                                  ),
                                  Image.asset(
                                    AppAssets.stoxplayCoin,
                                    height: 15.h,
                                    width: 15.w,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
