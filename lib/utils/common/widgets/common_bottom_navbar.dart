import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/config/navigation/navigation_state.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class CommonBottomNavbar extends StatelessWidget {
  final Widget? child;

  const CommonBottomNavbar({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class CustomBottomNavbar extends StatefulWidget {
  const CustomBottomNavbar({super.key});

  @override
  _CustomBottomNavbarState createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  // Icon data for each menu item
  final List<Map<String, dynamic>> _menuItems = [
    {'icon': AppAssets.homeIcon, 'label': 'Home'},
    {'icon': AppAssets.statsIcon, 'label': 'Stats'},
    {'icon': AppAssets.profileIcon, 'label': 'Profile'},
  ];

  void _onItemTapped(int index) {
    NavigationState().updateIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryPurple.withOpacity(0.1),
            AppColors.primaryPurple.withOpacity(0.1),
            AppColors.primaryPurple.withOpacity(0.1),
            AppColors.primaryPurple.withOpacity(0.1),
            AppColors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(
          color: AppColors.primaryPurple.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ValueListenableBuilder(
            valueListenable: NavigationState().currentIndex,
            builder: (context, selectedIndex, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_menuItems.length, (index) {
                  final item = _menuItems[index];
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () => _onItemTapped(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      padding: EdgeInsets.symmetric(
                        horizontal: isSelected ? 16.w : 0,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppColors.primaryPurple.withOpacity(0.2)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppColors.primaryPurple
                                  : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(item['icon'], height: 22.h, width: 22.w),
                          if (isSelected) ...[
                            SizedBox(width: 8.w),
                            Text(
                              item['label'],
                              style: TextStyle(
                                color: AppColors.primaryPurple,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
