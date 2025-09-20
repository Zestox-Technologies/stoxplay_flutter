import 'package:dartz/dartz.dart';
import 'package:stoxplay/core/network/app_error.dart';
import 'package:stoxplay/core/network/use_case.dart';
import 'package:stoxplay/features/home_page/data/models/ads_model.dart';
import 'package:stoxplay/features/home_page/data/models/approve_reject_withdraw_request_params.dart';
import 'package:stoxplay/features/home_page/data/models/client_teams_response_model.dart';
import 'package:stoxplay/features/home_page/data/models/contest_detail_model.dart';
import 'package:stoxplay/features/home_page/data/models/contest_leaderboard_model.dart';
import 'package:stoxplay/features/home_page/data/models/contest_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_params_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_response_model.dart';
import 'package:stoxplay/features/home_page/data/models/learning_model.dart';
import 'package:stoxplay/features/home_page/data/models/most_picked_stock_model.dart';
import 'package:stoxplay/features/home_page/data/models/sector_model.dart';
import 'package:stoxplay/features/home_page/data/models/stock_data_model.dart';
import 'package:stoxplay/features/home_page/data/models/withdraw_request_model.dart';
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

class ClientTeamsUseCase extends UseCase<ClientTeamsResponseModel, JoinContestParamsModel> {
  final HomeRepo repo;

  ClientTeamsUseCase({required this.repo});

  @override
  Future<Either<AppError, ClientTeamsResponseModel>> call(JoinContestParamsModel params) async {
    return await repo.clientTeams(params);
  }
}

class ContestDetailsUseCase extends UseCase<ContestDetailModel, String> {
  final HomeRepo repo;

  ContestDetailsUseCase({required this.repo});

  @override
  Future<Either<AppError, ContestDetailModel>> call(String params) async {
    return await repo.clientContestDetails(params);
  }
}

class ContestLeaderboardUseCase extends UseCase<ContestLeaderboardModel, String> {
  final HomeRepo repo;

  ContestLeaderboardUseCase({required this.repo});

  @override
  Future<Either<AppError, ContestLeaderboardModel>> call(String params) async {
    return await repo.clientContestLeaderboard(params);
  }
}

class GetMostPickedStockUseCase extends UseCase<List<MostPickedStock>, String> {
  final HomeRepo repo;

  GetMostPickedStockUseCase({required this.repo});

  @override
  Future<Either<AppError, List<MostPickedStock>>> call(String params) async {
    return await repo.getMostPickedStock();
  }
}

class RegisterTokenUseCase extends UseCase<String, String> {
  final HomeRepo repo;

  RegisterTokenUseCase({required this.repo});

  @override
  Future<Either<AppError, String>> call(String params) async {
    return await repo.registerToken(params);
  }
}

class WithdrawRequestPendingApprovalUseCase extends UseCase<List<WithdrawRequestModel>, String> {
  final HomeRepo repo;

  WithdrawRequestPendingApprovalUseCase({required this.repo});

  @override
  Future<Either<AppError, List<WithdrawRequestModel>>> call(String params) async {
    return await repo.withdrawalRequestPendingApproval();
  }
}

class ApproveRejectWithdrawRequestUseCase extends UseCase<String, ApproveRejectWithdrawRequestParams> {
  final HomeRepo repo;
  ApproveRejectWithdrawRequestUseCase({required this.repo});
  @override
  Future<Either<AppError, String>> call(ApproveRejectWithdrawRequestParams params) async {
    return await repo.approveRejectWithdrawRequest(params);
  }
}