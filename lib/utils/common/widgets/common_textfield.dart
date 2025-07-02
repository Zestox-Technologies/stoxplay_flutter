import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class CommonTextfield extends StatelessWidget {
  const CommonTextfield({
    Key? key,
    required this.controller,
    this.icon,
    required this.title,
    this.keyboardType,
    this.horizontalPadding,
    this.maxlines = 1,
    this.height = 50,
    this.secondIcon,
    this.onIconTap,
    this.onSecondIconTap,
    this.obscureText = false,
    this.textInputAction,
    this.onSubmitted,
    this.maxLength,
    this.hintText,
    this.focusColor,
    this.enableInteractiveSelection,
    this.onChanged,
    this.prefixText,
    this.focusNode,
    this.textColor,
    this.textCapitalization,
    this.readOnly,
    this.onTap,
    this.suffix,
    this.isCompulsory = false,
    this.inputFormatters,
  }) : super(key: key);

  final TextEditingController controller;
  final dynamic icon;
  final IconData? secondIcon;
  final String title;
  final String? hintText;
  final TextCapitalization? textCapitalization;
  final bool? isCompulsory;
  final String? prefixText;
  final bool? enableInteractiveSelection;
  final double? horizontalPadding;
  final VoidCallback? onIconTap;
  final Widget? suffix;
  final void Function()? onTap;
  final VoidCallback? onSecondIconTap;
  final TextInputType? keyboardType;
  final int? maxlines;
  final double? height;
  final FocusNode? focusNode;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  final void Function(String value)? onSubmitted;
  final void Function(String value)? onChanged;
  final int? maxLength;
  final bool? readOnly;
  final Color? focusColor;
  final Color? textColor;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextView(text: '$title${isCompulsory ?? false ? '*' : ''}', fontColor: AppColors.black),
        SizedBox(height: 5.h),
        Container(
          height: 45.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: AppColors.whiteF9F9,
            boxShadow: [
              BoxShadow(color: AppColors.blue7E.withOpacity(0.2), blurRadius: 1, spreadRadius: 0),
              BoxShadow(color: AppColors.black40, blurRadius: 4.0, spreadRadius: 0.0, offset: const Offset(0, 0)),
            ],
          ),
          child: Row(
            children: [
              prefixText != null ? TextView(text: prefixText!, fontSize: 17.sp) : SizedBox.shrink(),
              Expanded(
                child: TextField(
                  onTap: onTap,
                  focusNode: focusNode,
                  cursorColor: AppColors.blue7E,
                  controller: controller,
                  onChanged: onChanged,
                  textCapitalization: textCapitalization ?? TextCapitalization.none,
                  readOnly: readOnly ?? false,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: keyboardType,
                  cursorHeight: 18.h,
                  maxLength: maxLength,
                  inputFormatters: inputFormatters,
                  buildCounter:
                      (context, {required currentLength, required isFocused, required maxLength}) => SizedBox.shrink(),
                  decoration: InputDecoration.collapsed(
                    hintText: hintText ?? title,
                    hintStyle: TextStyle(color: AppColors.black40),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (suffix != null) ...[SizedBox(width: 8.w), GestureDetector(onTap: onSecondIconTap, child: suffix!)],
            ],
          ),
        ),
      ],
    );
  }
}
