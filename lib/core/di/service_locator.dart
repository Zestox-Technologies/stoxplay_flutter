import 'package:get_it/get_it.dart';
import 'package:stoxplay/core/network/api_service.dart';
import 'package:stoxplay/features/auth/data/auth_rds.dart';
import 'package:stoxplay/features/auth/domain/auth_repo.dart';
import 'package:stoxplay/features/auth/domain/auth_usecase.dart';
import 'package:stoxplay/features/home_page/data/home_rds.dart';
import 'package:stoxplay/features/home_page/domain/home_repo.dart';
import 'package:stoxplay/features/home_page/domain/home_usecase.dart';
import 'package:stoxplay/features/profile_page/data/profile_rds.dart';
import 'package:stoxplay/features/profile_page/domain/profile_repo.dart';
import 'package:stoxplay/features/profile_page/domain/profile_usecase.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // Remote Data Sources
  sl.registerLazySingleton<AuthRds>(() => AuthRdsImpl(client: sl()));
  sl.registerLazySingleton<HomeRds>(() => HomeRdsImpl(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(authRds: sl()));
  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => CheckPhoneNumberUseCase(repository: sl())); // Use cases
  sl.registerLazySingleton(() => SectorListUseCase(repo: sl()));
  sl.registerLazySingleton(() => ContestStatusUseCase(repo: sl()));
  sl.registerLazySingleton(() => GetContestListUseCase(repo: sl()));
  sl.registerLazySingleton(() => GetStockListUseCase(repo: sl()));
  sl.registerLazySingleton(() => JoinContestUseCase(repo: sl()));

  // Profile Feature
  sl.registerLazySingleton<ProfileRds>(() => ProfileRdsImpl(apiService: sl()));
  sl.registerLazySingleton<ProfileRepo>(() => ProfileRepoImpl(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
}
