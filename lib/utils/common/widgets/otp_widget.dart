import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

/// Widget for OTP field
class OtpWidget extends StatelessWidget {
  const OtpWidget({Key? key, required this.onchange, this.otpController, this.length, this.height, this.width, this.padding})
      : super(key: key);

  final TextEditingController? otpController;
  final void Function(String) onchange;
  final int? length;
  final double? height;
  final double? width;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      length: length ?? 4,
      autoFocus: false,
      obscureText: true,
      hapticFeedbackTypes:
      HapticFeedbackTypes.light /*HapticFeedbackTypes.vibrate*/,
      useHapticFeedback: true,
      autovalidateMode: AutovalidateMode.disabled,
      textStyle: const TextStyle(fontSize: 20, color: AppColors.black),
      validator: (value) {
        final RegExp regExp = RegExp(r'(?<!\d)\d{6}(?!\d)');
        if (value!.isEmpty) {
          return "Please enter otp";
        } else if (!regExp.hasMatch(otpController!.text)) {
          return "OTP not verified";
        }
        return null;
      },
      errorTextSpace: 25.h,
      mainAxisAlignment: MainAxisAlignment.center,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: height,
        fieldOuterPadding: EdgeInsets.symmetric(horizontal: padding ?? 8.w),
        fieldWidth: width ?? 48.w,
        borderWidth: 1,
        activeColor: AppColors.whiteDFE0,
        activeFillColor: AppColors.whiteDFE0,
        selectedFillColor: AppColors.whiteDFE0,
        disabledColor: AppColors.white,
        errorBorderColor: AppColors.white70,
        selectedColor: AppColors.black /*AppColors.black.withOpacity(0.5)*/,
        inactiveFillColor: AppColors.whiteDFE0,
        inactiveColor: AppColors.whiteF9F9,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      // backgroundColor: AppColors.bgColorMain,
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      enablePinAutofill: true,
      showCursor: false,
      controller: otpController,
      onCompleted: (v) {},
      onChanged: onchange,
      beforeTextPaste: (text) {
        return true;
      },
      appContext: context,
    );
  }
}