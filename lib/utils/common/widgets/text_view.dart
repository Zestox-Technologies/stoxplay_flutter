import 'package:flutter/material.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class TextView extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double? letterSpacing;
  final double? lineHeight;
  final int? maxLines;
  final Color? fontColor;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextDecoration? textDecoration;

  const TextView({
    super.key,
    required this.text,
    this.overflow,
    this.lineHeight,
    this.fontWeight,
    this.textDecoration,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.fontSize,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines ?? 1,
      textAlign: textAlign ?? TextAlign.left,
      style: TextStyle(
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: fontWeight,
        overflow: overflow,
        letterSpacing: letterSpacing,
        color: fontColor ?? AppColors.black,
        fontFamily: 'Sofia Sans',
        decoration: textDecoration
      ),
    );
  }
}
