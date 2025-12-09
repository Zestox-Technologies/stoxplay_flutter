import 'package:flutter/material.dart';
import 'package:stoxplay/main.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  Color backgroundColor = AppColors.redFF00, // Default background color
  int durationInSeconds = 3, // Default duration
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Align(
        alignment: Alignment.centerLeft,
        child: TextView(
          text: message,
          fontColor: AppColors.white,
        ),
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationInSeconds),
    ),
  );
}

void showSnackBarUsingKey({
  required String message,
  Color backgroundColor = AppColors.redFF00, // Default background color
  int durationInSeconds = 3, // Default duration
}) {
  snackBarKey.currentState!.removeCurrentSnackBar();
  snackBarKey.currentState!.showSnackBar(
    SnackBar(
      content: Align(
        alignment: Alignment.centerLeft,
        child: TextView(
          text: message,
        ),
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationInSeconds),
    ),
  );
}
