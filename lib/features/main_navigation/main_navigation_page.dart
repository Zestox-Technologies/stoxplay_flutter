import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stoxplay/config/navigation/navigation_state.dart';
import 'package:stoxplay/features/home_page/pages/home_page.dart';
import 'package:stoxplay/features/leaderboard_page/pages/leaderboard_page.dart';
import 'package:stoxplay/features/profile_page/pages/profile_page.dart';
import 'package:stoxplay/features/stats_page/pages/contest_winner_screen.dart';
import 'package:stoxplay/features/stats_page/pages/stats_page.dart';
import 'package:stoxplay/utils/common/widgets/common_bottom_navbar.dart';

class MainNavigationPage extends StatelessWidget {
  MainNavigationPage({super.key});

  DateTime? lastBackPressed;

  Future<bool> onWillPop() {
    final now = DateTime.now();
    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
      lastBackPressed = now;
      Fluttertoast.showToast(msg: "Press again to exit");
      return Future.value(false); // don't exit
    }
    return Future.value(true); // exit
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        if (NavigationState().currentIndex.value != 0) {
          NavigationState().currentIndex.value = 0;
        } else {
          onWillPop();
        }
      },
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: NavigationState().currentIndex,
          builder: (context, selectedIndex, _) {
            return IndexedStack(
              index: selectedIndex,
              children: [
                HomePage(),
                StatsPage(),
                LeaderboardPage(),
                ProfilePage(),
              ],
            );
          },
        ),
        bottomNavigationBar: const CustomBottomNavbar(),
      ),
    );
  }
}
