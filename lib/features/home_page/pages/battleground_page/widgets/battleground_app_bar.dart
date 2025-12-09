import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stoxplay/features/home_page/data/models/live_stock_model.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';

/// Custom app bar for the battleground page.
///
/// Includes back button, team name, edit button (conditional), and share button.
class BattlegroundAppBar extends StatelessWidget {
  final String teamName;
  final ScoreUpdatePayload? data;
  final ScreenshotController screenshotController;
  final VoidCallback onBack;

  const BattlegroundAppBar({
    required this.teamName,
    required this.data,
    required this.screenshotController,
    required this.onBack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.white),
        ),
        Text(
          teamName,
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 26,
            height: 1.1,
            letterSpacing: 1.17,
          ),
        ),
        const Spacer(),
        if (data?.isLive == false)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.stockSelectionScreen,
                arguments: {
                  'teamId': data?.userTeamId ?? '',
                  'contestId': data?.contestId ?? '',
                  'price': '${data?.entryFee}',
                },
              );
            },
            child: Image.asset(
              AppAssets.editIcon,
              height: 20.h,
              width: 20.w,
              color: AppColors.white,
            ),
          ),
        IconButton(
          onPressed: () => _handleShare(context),
          icon: Icon(Icons.share, size: 20, color: AppColors.white),
        ),
      ],
    );
  }

  Future<void> _handleShare(BuildContext context) async {
    final image = await screenshotController.capture();
    if (image == null) return;

    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/screenshot.png').create();
    await imagePath.writeAsBytes(image);

    final share = SharePlus.instance;
    await share.share(
      ShareParams(
        text: "This is my stoxplay battleground Team",
        files: [XFile(imagePath.path)],
      ),
    );
  }
}
