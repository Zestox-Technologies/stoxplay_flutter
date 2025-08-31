import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/stock_selection_screen.dart';
import 'package:stoxplay/features/profile_page/presentation/pages/profile_page.dart';
import 'package:stoxplay/utils/common/widgets/glow_icon.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

List<BottomNavigationBarItem> navBarList = [
  BottomNavigationBarItem(
    icon: Image.asset(AppAssets.monitorIcon, height: 24.h, width: 24.w, color: AppColors.black),
    activeIcon: GlowIcon(
      glowColor: AppColors.primaryPurple,
      child: Image.asset(AppAssets.monitorIcon, height: 24.h, width: 24.w, color: AppColors.primaryPurple),
    ),
    label: '',
  ),
  BottomNavigationBarItem(
    icon: Image.asset(AppAssets.monitorIcon, height: 24.h, width: 24.w),
    activeIcon: GlowIcon(
      glowColor: AppColors.primaryPurple,
      child: Image.asset(AppAssets.monitorIcon, height: 24.h, width: 24.w, color: AppColors.primaryPurple),
    ),
    label: '',
  ),
  BottomNavigationBarItem(
    icon: Image.asset(AppAssets.insightIcon, height: 24.h, width: 24.w),
    activeIcon: GlowIcon(
      glowColor: AppColors.primaryPurple,
      child: Image.asset(AppAssets.insightIcon, height: 24.h, width: 24.w, color: AppColors.primaryPurple),
    ),
    label: '',
  ),
  BottomNavigationBarItem(
    icon: Image.asset(AppAssets.profileIcon, height: 24, width: 24),
    activeIcon: GlowIcon(
      glowColor: AppColors.primaryPurple,
      child: Image.asset(AppAssets.profileIcon, height: 24.h, width: 24.w, color: AppColors.primaryPurple),
    ),
    label: '',
  ),
];

/// FontStyles
final selectStocksStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 35.sp,
  color: AppColors.primaryPurple,
  height: 1.0,
  letterSpacing: 0.0,
  shadows: [
    Shadow(
      offset: Offset(0, 4),
      blurRadius: 10,
      color: AppColors.black.withOpacity(0.15), // #00000040 in Flutter ARGB format
    ),
  ],
);

BoxDecoration primaryContainerDecoration = BoxDecoration(
  color: AppColors.white,
  borderRadius: BorderRadius.circular(12.r),
  boxShadow: [
    BoxShadow(color: AppColors.blue7E.withOpacity(0.3), offset: const Offset(0, 0), blurRadius: 12, spreadRadius: 1),
  ],
  border: Border.all(color: AppColors.blue7E.withOpacity(0.5)),
);
BoxDecoration boxDecorationForContestWidget = BoxDecoration(
  color: AppColors.white,
  borderRadius: BorderRadius.circular(12.r),
  boxShadow: [BoxShadow(color: AppColors.black6767.withOpacity(0.2), blurRadius: 12, spreadRadius: 1)],
  border: Border.all(color: AppColors.black6767.withOpacity(0.5)),
);

List<ProfileItemModel> profileItems = [
  ProfileItemModel(icon: AppAssets.playIcon, title: "Playing History"),
  ProfileItemModel(icon: AppAssets.personalInfoIcon, title: "Personal Info"),
  ProfileItemModel(icon: AppAssets.playIcon, title: "How to Play"),
  ProfileItemModel(icon: AppAssets.helpIcon, title: "Contact Us"),
  ProfileItemModel(icon: AppAssets.termsAndConditionsIcon, title: "T&C of Zestox Technologies"),
  ProfileItemModel(icon: AppAssets.userProfileIcon, title: "About StoxPlay"),
  ProfileItemModel(icon: AppAssets.logoutIcon, title: "Logout"),
];

StockPosition getPositionByRole(String role) {
  switch (role) {
    case "NORMAL":
      return StockPosition.none;
    case "CAPTAIN":
      return StockPosition.leader;
    case "VICE_CAPTAIN":
      return StockPosition.viceLeader;
    case "FLEX":
      return StockPosition.coLeader;
  }
  return StockPosition.none;
}
