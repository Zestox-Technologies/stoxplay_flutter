import 'package:dartz/dartz.dart';
import 'package:stoxplay/core/network/app_error.dart';
import 'package:stoxplay/features/home_page/data/home_rds.dart';
import 'package:stoxplay/features/home_page/data/models/contest_model.dart';
import 'package:stoxplay/features/home_page/data/models/sector_model.dart';

abstract class HomeRepo {
  Future<Either<AppError, List<SectorModel>>> getSectorList();

  Future<Either<AppError, List<ContestModel>>> getContestList(String sectorId);

  Future<Either<AppError, bool>> getContestStatus();
}

class HomeRepoImpl extends HomeRepo {
  final HomeRds homeRds;

  HomeRepoImpl(this.homeRds);

  @override
  Future<Either<AppError, List<SectorModel>>> getSectorList() async {
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
}
