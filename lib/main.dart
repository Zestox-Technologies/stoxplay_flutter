import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stoxplay/core/di/service_locator.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/utils/common/widgets/app_component_base.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

import 'application/application.dart';

GlobalKey<ScaffoldMessengerState> snackBarKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // try {
  //   await Firebase.initializeApp();
  //   print('Firebase initialized successfully');
  // } catch (e) {
  //   print('Firebase initialization failed: $e');
  // }
  
  // Initialize dependency injection
  await init();
  
  await AppComponentBase().init();
  await StorageService().init();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}
