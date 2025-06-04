import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stoxplay/utils/common/widgets/primary_container.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class WinnersItemWidget extends StatelessWidget {
  const WinnersItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        PrimaryContainer(
          width: MediaQuery.of(context).size.width / 4.w,
          borderColor: AppColors.blue7E.withOpacity(0.5),
          borderWidth: 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(30.h),
              TextView(
                text: "Rahul Kumar",
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("30k", style: TextStyle(fontWeight: FontWeight.w800)),
                  Image.asset(
                    AppAssets.stoxplayCoin,
                    height: 16.h,
                    width: 16.w,
                  ),
                ],
              ),
              Divider(),
              TextView(text: "View Team", fontWeight: FontWeight.w700),
            ],
          ),
        ),
        Positioned(
          top: -20,
          child: Container(
            padding: EdgeInsets.all(2), // thickness of the border
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.blue7E.withOpacity(0.5),
                // border color
                width: 0.5, // border width
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue7E.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 0.0,
                  offset: Offset(0, 0), // Shadow direction: bottom right
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: Image.asset(
                  AppAssets.stoxplayCoin,
                  fit: BoxFit.cover,
                  width: 40.r,
                  height: 40.r,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
