import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stoxplay/config/navigation/navigation_state.dart';
import 'package:stoxplay/features/home_page/pages/home_page.dart';
import 'package:stoxplay/features/profile_page/presentation/pages/profile_page.dart';
import 'package:stoxplay/features/stats_page/presentation/pages/stats_page.dart';
import 'package:stoxplay/utils/common/widgets/common_bottom_navbar.dart';

class MainNavigationPage extends StatelessWidget {
  MainNavigationPage({super.key});

  DateTime? lastBackPressed;

  Future<bool> _onWillPop(BuildContext context) async {
    final now = DateTime.now();

    if (lastBackPressed == null || now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
      lastBackPressed = now;
      Fluttertoast.showToast(msg: "Press again to exit");
      return false; // Don't exit yet
    }

    return true; // Exit app
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (NavigationState().currentIndex.value != 0) {
          NavigationState().currentIndex.value = 0;
        } else {
          final shouldExit = await _onWillPop(context);
          if (shouldExit) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: NavigationState().currentIndex,
          builder: (context, selectedIndex, _) {
            return IndexedStack(index: selectedIndex, children: [HomePage(), StatsPage(), ProfilePage()]);
          },
        ),
        bottomNavigationBar: const CustomBottomNavbar(),
      ),
    );
  }
}
