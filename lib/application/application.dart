import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this for SystemUiOverlayStyle
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/config/route_list.dart';
import 'package:stoxplay/core/di/service_locator.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/features/home_page/cubits/home_cubit.dart';
import 'package:stoxplay/features/profile_page/presentation/profile_cubit.dart';
import 'package:stoxplay/utils/common/cubits/timer_cubit.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => TimerCubit()),
            BlocProvider(create: (context) => ProfileCubit(sl())),
            BlocProvider(
              create:
                  (context) =>
                      HomeCubit(sectorListUseCase: sl(), getContestListUseCase: sl(), contestStatusUseCase: sl()),
            ),
          ],
          child: MaterialApp(
            title: Strings.stoxplay,
            debugShowCheckedModeBanner: false,
            routes: RouteList.routes,
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
                  statusBarIconBrightness: Brightness.dark, // Dark icons
                  statusBarBrightness: Brightness.light, // For iOS
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple661F,
                  foregroundColor: AppColors.black,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColors.colorPrimary),
            ),
            initialRoute: StorageService().isLoggedIn() ? AppRoutes.mainPage : AppRoutes.onBoardingPage,
          ),
        );
      },
    );
  }
}
