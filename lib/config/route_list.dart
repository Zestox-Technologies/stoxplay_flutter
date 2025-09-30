import 'package:flutter/cupertino.dart';
import 'package:stoxplay/features/auth/presentation/pages/login_page.dart';
import 'package:stoxplay/features/auth/presentation/pages/singup_page.dart';
import 'package:stoxplay/features/home_page/pages/battleground_page/pages/battleground_page.dart';
import 'package:stoxplay/features/home_page/pages/contest_details_page/contest_data_screen.dart';
import 'package:stoxplay/features/home_page/pages/contest_details_page/contest_details_page.dart';
import 'package:stoxplay/features/home_page/pages/home_page.dart';
import 'package:stoxplay/features/home_page/pages/notification_page.dart';
import 'package:stoxplay/features/home_page/pages/stock_selection_page/stock_selection_screen.dart';
import 'package:stoxplay/features/leaderboard_page/pages/leaderboard_page.dart';
import 'package:stoxplay/features/main_navigation/main_navigation_page.dart';
import 'package:stoxplay/features/on_boarding_page/on_boarding_page.dart';
import 'package:stoxplay/features/pdf_view/pages/books_list_screen.dart';
import 'package:stoxplay/features/profile_page/presentation/pages/how_to_play_webview.dart';
import 'package:stoxplay/features/profile_page/presentation/pages/personal_info_page.dart';
import 'package:stoxplay/features/profile_page/presentation/pages/playing_history_page.dart';
import 'package:stoxplay/features/profile_page/presentation/pages/privacy_policy.dart';
import 'package:stoxplay/features/profile_page/presentation/pages/profile_page.dart';
import 'package:stoxplay/features/stats_page/presentation/pages/comepleted_details_screen.dart';
import 'package:stoxplay/features/stats_page/presentation/pages/contest_winner_screen.dart';
import 'package:stoxplay/features/stats_page/presentation/pages/stats_page.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';

class RouteList {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.onBoardingPage: (context) => const OnBoardingPage(),
    AppRoutes.booksListScreen: (context) => const BooksListScreen(),
    AppRoutes.loginPage: (context) => LoginPage(),
    AppRoutes.signUpPage: (context) => SignUpPage(),
    AppRoutes.homePage: (context) => HomePage(),
    AppRoutes.mainPage: (context) => MainNavigationPage(),
    AppRoutes.contestDetailsPage: (context) => ContestDetailsPage(),
    AppRoutes.stockSelectionScreen: (context) => StockSelectionScreen(),
    AppRoutes.statsPage: (context) => StatsPage(),
    AppRoutes.leaderboardPage: (context) => LeaderboardPage(),
    AppRoutes.profilePage: (context) => ProfilePage(),
    AppRoutes.battleGroundScreen: (context) => BattlegroundPage(),
    AppRoutes.contestWinnerPage: (context) => ContestWinnerPage(),
    AppRoutes.contestDataScreen: (context) => ContestDataScreen(),
    AppRoutes.personalInfoPage: (context) => PersonalInfoPage(),
    AppRoutes.playingHistoryPage: (context) => PlayingHistoryPage(),
    AppRoutes.completedDetailsScreen: (context) => CompletedDetailsScreen(),
    AppRoutes.howToPlayWebView: (context) => HowToPlayWebView(),
    AppRoutes.privacyPolicyScreen: (context) => PrivacyPolicyScreen(),
    AppRoutes.notificationPage: (context) => NotificationPage(),
  };
}
