import 'package:dartz/dartz.dart';
import 'package:stoxplay/core/network/app_error.dart';
import 'package:stoxplay/core/network/use_case.dart';
import 'package:stoxplay/features/home_page/data/models/sector_model.dart';
import 'package:stoxplay/features/home_page/domain/home_repo.dart';

class SectorListUseCase extends UseCase<List<SectorModel>, String> {
  final HomeRepo repo;

  SectorListUseCase({required this.repo});

  @override
  Future<Either<AppError, List<SectorModel>>> call(String params) async {
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
