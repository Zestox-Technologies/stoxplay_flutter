import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';

class CommonButton extends StatelessWidget {
  final String? title;
  void Function()? onTap;
  final double? height;
  final double? width;
  final double? borderRadius;

  CommonButton({
    super.key,
    this.borderRadius,
    this.height,
    this.width,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 45.h,
        width: width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xFF661FB1), // Background color as specified
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 15.r)),
          boxShadow: [
            BoxShadow(
              color: Color(0x40000000), // Shadow color with 25% opacity
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(0, 0), // Centered shadow (inset)
            ),
          ],
        ),
        child: Center(
          child: TextView(
            text: title ?? '',
            fontColor: Colors.white, // Adjust text color as needed
          ),
        ),
      ),
    );
  }
}
