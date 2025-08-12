import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/cubit/stock_selection_cubit.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';

class ConfirmationBs extends StatelessWidget {
  final String contestId;
  final StockSelectionCubit cubit;
  final String price;

  const ConfirmationBs({required this.cubit, required this.price, required this.contestId, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          spacing: 20.h,
          children: [
            SizedBox(),
            Text("Confirmation", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Entry", style: TextStyle(fontSize: 16.sp)),
                Row(
                  children: [
                    Image.asset(AppAssets.stoxplayCoin, height: 18.h, width: 18.w),
                    Text(price, style: TextStyle(fontSize: 16.sp)),
                  ],
                ),
              ],
            ),
            BlocListener<StockSelectionCubit, StockSelectionState>(
              bloc: cubit,
              listener: (context, state) {
                if (state.joinContestApiStatus.isSuccess) {
                  Navigator.pop(context);
                  Future.microtask(() {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.battleGroundScreen,
                      arguments: state.joinContestResponse?.id ?? '',
                    );
                  });
                } else if (state.joinContestApiStatus.isFailed) {
                  Fluttertoast.showToast(msg: state.message ?? "Join contest failed please try again later");
                }
              },
              child: BlocSelector<StockSelectionCubit, StockSelectionState, ApiStatus>(
                bloc: cubit,
                selector: (state) => state.joinContestApiStatus,
                builder: (context, state) {
                  return AppButton(
                    isLoading: state.isLoading,
                    text: "Join Contest",
                    onPressed: () => cubit.joinContest(contestId),
                  );
                },
              ),
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
