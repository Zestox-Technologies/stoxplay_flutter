import 'package:dartz/dartz.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/core/network/app_error.dart';
import 'package:stoxplay/features/home_page/data/home_rds.dart';
import 'package:stoxplay/features/home_page/data/models/contest_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_params_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_response_model.dart';
import 'package:stoxplay/features/home_page/data/models/sector_model.dart';
import 'package:stoxplay/features/home_page/data/models/stock_data_model.dart';

abstract class HomeRepo {
  Future<Either<AppError, SectorListResponse>> getSectorList();

  Future<Either<AppError, List<ContestModel>>> getContestList(String sectorId);

  Future<Either<AppError, bool>> getContestStatus();

  Future<Either<AppError,StockResponseModel>> getStockList(String contestId);

  Future<Either<AppError, JoinContestResponseModel>> joinContest(JoinContestParamsModel params);
}

class HomeRepoImpl extends HomeRepo {
  final HomeRds homeRds;

  HomeRepoImpl(this.homeRds);

  @override
  Future<Either<AppError, SectorListResponse>> getSectorList() async {
    try {
      final result = await homeRds.getSectorList();
      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Either<AppError, bool>> getContestStatus() async {
    try {
      final result = await homeRds.getContestStatus();
      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Either<AppError, List<ContestModel>>> getContestList(String sectorId) async {
    try {
      final result = await homeRds.getContestList(sectorId);
      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Either<AppError,StockResponseModel>> getStockList(String contestId) async {
    try {
      final result = await homeRds.getStockList(contestId);
      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<Either<AppError, JoinContestResponseModel>> joinContest(JoinContestParamsModel params) async {
    try {
      final result = await homeRds.joinContest(params);
      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }
}
