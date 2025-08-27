import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/config/navigation/navigation_state.dart';
import 'package:stoxplay/features/profile_page/presentation/cubit/profile_cubit.dart';
import 'package:stoxplay/features/stats_page/presentation/cubit/stats_cubit.dart';
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
          BoxShadow(color: AppColors.primaryPurple.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5)),
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
  late ProfileCubit profileCubit;
  late StatsCubit statsCubit;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': AppAssets.homeIcon, 'label': 'Home'},
    {'icon': AppAssets.statsIcon, 'label': 'Stats'},
    {'icon': AppAssets.profileIcon, 'label': 'Profile'},
  ];

  @override
  void initState() {
    profileCubit = BlocProvider.of<ProfileCubit>(context);
    statsCubit = BlocProvider.of<StatsCubit>(context);
    super.initState();
  }

  void _onItemTapped(int index) {
    final currentIndex = NavigationState().currentIndex.value;

    if (currentIndex == index) return;
    NavigationState().updateIndex(index);

    if (index != 1) {
      profileCubit.fetchProfile();
    } else if (index == 1) {
      statsCubit.getMyContests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        height: 55.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.black6767, width: 0.5)),
        ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        item['icon'],
                        height: 22.h,
                        width: 22.w,
                        color: isSelected ? AppColors.primaryPurple : AppColors.black6767,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        item['label'],
                        style: TextStyle(fontSize: 12.sp, color: isSelected ? AppColors.primaryPurple : Colors.black),
                      ),
                    ],
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
