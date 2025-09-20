import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/config/route_list.dart';
import 'package:stoxplay/core/di/service_locator.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/features/profile_page/presentation/cubit/profile_cubit.dart';
import 'package:stoxplay/features/stats_page/presentation/cubit/stats_cubit.dart';
import 'package:stoxplay/utils/common/cubits/multi_timer_cubit.dart';
import 'package:stoxplay/utils/common/cubits/timer_cubit.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double shortestSide = constraints.biggest.shortestSide;
        final bool isTabletOrFoldable = shortestSide >= 600; // breakpoint
        final Size designSize =
            isTabletOrFoldable
                ? const Size(834, 1194) // tablet/foldable baseline (portrait)
                : const Size(375, 812); // phone baseline

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          useInheritedMediaQuery: true,
          builder: (_, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => TimerCubit()),
                BlocProvider.value(value: MultiTimerCubit.instance),
                BlocProvider(create: (context) => ProfileCubit(sl(), sl(), sl(), sl(),sl())),
                BlocProvider(create: (context) => StatsCubit(getMyContestUseCase: sl())),
                BlocProvider(
                  create:
                      (context) => HomeCubit(
                        sectorListUseCase: sl(),
                        getContestListUseCase: sl(),
                        learningListUseCase: sl(),
                        contestStatusUseCase: sl(),
                        getAdsUseCase: sl(),
                        contestLeaderboardUseCase: sl(),
                        contestDetailsUseCase: sl(),
                        getMostPickedStockUseCase: sl(),
                        registerTokenUseCase: sl(),
                        withdrawRequestPendingApprovalUseCase: sl(),
                        approveRejectWithdrawRequestUseCase: sl(),
                      ),
                ),
              ],
              child: MaterialApp(
                title: Strings.stoxplay,
                debugShowCheckedModeBanner: false,
                routes: RouteList.routes,
                useInheritedMediaQuery: true,
                builder: (context, widget) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: widget!,
                  );
                },
                theme: ThemeData(
                  useMaterial3: true,
                  primaryColor: AppColors.colorPrimary,
                  scaffoldBackgroundColor: AppColors.colorPrimary,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: AppColors.colorPrimary,
                    primary: AppColors.colorPrimary,
                    secondary: AppColors.colorPrimary,
                  ),
                  fontFamily: 'Sofia Sans',
                  appBarTheme: AppBarTheme(
                    backgroundColor: AppColors.colorPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: AppColors.colorPrimary,
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.light,
                    ),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: AppColors.black,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColors.colorPrimary),
                ),
                initialRoute: StorageService().isLoggedIn() ? AppRoutes.mainPage : AppRoutes.booksListScreen,
              ),
            );
          },
        );
      },
    );
  }
}
