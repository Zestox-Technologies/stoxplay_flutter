import 'package:dartz/dartz.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/core/network/app_error.dart';
import 'package:stoxplay/core/network/use_case.dart';
import 'package:stoxplay/features/home_page/data/models/contest_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_params_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_response_model.dart';
import 'package:stoxplay/features/home_page/data/models/sector_model.dart';
import 'package:stoxplay/features/home_page/data/models/stock_data_model.dart';
import 'package:stoxplay/features/home_page/domain/home_repo.dart';

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
