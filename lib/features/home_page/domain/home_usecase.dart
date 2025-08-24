import 'package:dartz/dartz.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/core/network/app_error.dart';
import 'package:stoxplay/core/network/use_case.dart';
import 'package:stoxplay/features/home_page/data/models/ads_model.dart';
import 'package:stoxplay/features/home_page/data/models/contest_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_params_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_response_model.dart';
import 'package:stoxplay/features/home_page/data/models/learning_model.dart';
import 'package:stoxplay/features/home_page/data/models/sector_model.dart';
import 'package:stoxplay/features/home_page/data/models/stock_data_model.dart';
import 'package:stoxplay/features/home_page/domain/home_repo.dart';
import 'package:stoxplay/features/stats_page/data/stats_model.dart';

class SectorListUseCase extends UseCase<SectorListResponse, String> {
  final HomeRepo repo;

  SectorListUseCase({required this.repo});

  @override
  Future<Either<AppError, SectorListResponse>> call(String params) async {
    return await repo.getSectorList();
  }
}

class ContestStatusUseCase extends UseCase<bool, String> {
  final HomeRepo repo;

  ContestStatusUseCase({required this.repo});

  @override
  Future<Either<AppError, bool>> call(String params) async {
    return await repo.getContestStatus();
  }
}

class GetContestListUseCase extends UseCase<List<ContestModel>, String> {
  final HomeRepo repo;

  GetContestListUseCase({required this.repo});

  @override
  Future<Either<AppError, List<ContestModel>>> call(String params) async {
    return await repo.getContestList(params);
  }
}

class GetStockListUseCase extends UseCase<StockResponseModel, String> {
  final HomeRepo repo;

  GetStockListUseCase({required this.repo});

  @override
  Future<Either<AppError, StockResponseModel>> call(String params) async {
    return await repo.getStockList(params);
  }
}

class JoinContestUseCase extends UseCase<JoinContestResponseModel, JoinContestParamsModel> {
  final HomeRepo repo;

  JoinContestUseCase({required this.repo});

  @override
  Future<Either<AppError, JoinContestResponseModel>> call(JoinContestParamsModel params) async {
    return await repo.joinContest(params);
  }
}

class GetMyContestUseCase extends UseCase<StatsModel, String> {
  final HomeRepo repo;

  GetMyContestUseCase({required this.repo});

  @override
  Future<Either<AppError, StatsModel>> call(String params) async {
    return await repo.getMyContests();
  }
}

class UpdateTeamUseCase extends UseCase<String, JoinContestParamsModel> {
  final HomeRepo repo;

  UpdateTeamUseCase({required this.repo});

  @override
  Future<Either<AppError, String>> call(JoinContestParamsModel params) async {
    return await repo.updateTeam(params);
  }
}
class LearningListUseCase extends UseCase<List<LearningModel>, String> {
  final HomeRepo repo;

  LearningListUseCase({required this.repo});

  @override
  Future<Either<AppError, List<LearningModel>>> call(String params) async {
    return await repo.getLearningList(params);
  }
}

class GetAdsUseCase extends UseCase<List<AdsModel>, String> {
  final HomeRepo repo;

  GetAdsUseCase({required this.repo});

  @override
  Future<Either<AppError, List<AdsModel>>> call(String params) async {
    return await repo.getAds();
  }
}
