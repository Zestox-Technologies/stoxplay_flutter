import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';


class CommonReverseButton extends StatelessWidget {
  final String? title;
  void Function()? onTap;
  CommonReverseButton({super.key, required this.title,required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.colorPrimary),
            borderRadius: BorderRadius.all(Radius.circular(15.r))),
        child: Center(child: TextView(text: title ?? '',fontColor: AppColors.black,)),
      ),
    );
  }
}
