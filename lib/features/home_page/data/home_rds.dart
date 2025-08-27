import 'package:dio/dio.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/core/network/api_service.dart';
import 'package:stoxplay/core/network/api_urls.dart';
import 'package:stoxplay/core/network/app_error.dart';
import 'package:stoxplay/features/home_page/data/models/ads_model.dart';
import 'package:stoxplay/features/home_page/data/models/contest_detail_model.dart';
import 'package:stoxplay/features/home_page/data/models/contest_leaderboard_model.dart';
import 'package:stoxplay/features/home_page/data/models/contest_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_params_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_response_model.dart';
import 'package:stoxplay/features/home_page/data/models/learning_model.dart';
import 'package:stoxplay/features/home_page/data/models/stock_data_model.dart';
import 'package:stoxplay/features/stats_page/data/stats_model.dart';
import 'package:stoxplay/utils/models/QueryParams.dart';

import 'models/client_teams_response_model.dart';
import 'models/sector_model.dart';

abstract class HomeRds {
  Future<SectorListResponse> getSectorList();

  Future<List<ContestModel>> getContestList(String sectorId);

  Future<bool> getContestStatus();

  Future<StockResponseModel> getStockList(String contestId);

  Future<JoinContestResponseModel> joinContest(JoinContestParamsModel params);

  Future<StatsModel> getMyContests();

  Future<String> updateTeam(JoinContestParamsModel params);

  Future<List<LearningModel>> getLearningList(String params);

  Future<List<AdsModel>> getAds();

  Future<ClientTeamsResponseModel> teamsClient(JoinContestParamsModel params);

  Future<ContestDetailModel> contestDetails(String params);

  Future<ContestLeaderboardModel> contestLeaderboard(String params);
}

class HomeRdsImpl extends HomeRds {
  final ApiService client;

  HomeRdsImpl(this.client);

  QueryParams queryParams = QueryParams(10, 1);

  @override
  Future<SectorListResponse> getSectorList() async {
    try {
      final response = await client.get(ApiUrls.getSectorList, queryParameters: queryParams.toMap());
      return SectorListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: 'An unexpected error occurred: $e');
    }
  }

  @override
  Future<bool> getContestStatus() async {
    try {
      final response = await client.get(ApiUrls.getContestStatus);

      final bool isContestEnabled = response.data['data']['isContestEnabled'];

      return isContestEnabled;
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: 'An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ContestModel>> getContestList(String sectorId) async {
    try {
      final response = await client.get(ApiUrls.getContestList(sectorId), queryParameters: queryParams.toMap());

      final List<dynamic> jsonList = response.data['data']['data'];
      final sectorList = jsonList.map((json) => ContestModel.fromJson(json)).toList();

      return sectorList;
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: 'An unexpected error occurred: $e');
    }
  }

  @override
  Future<StockResponseModel> getStockList(String contestId) async {
    try {
      final response = await client.get(ApiUrls.getStocksList(contestId), queryParameters: queryParams.toMap());
      final stockResponse = StockResponseModel.fromJson(response.data);
      return stockResponse;
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: 'An unexpected error occurred: $e');
    }
  }

  @override
  Future<JoinContestResponseModel> joinContest(JoinContestParamsModel params) async {
    try {
      final response = await client.post(ApiUrls.joinContest(params.contestId), data: params.toJson());
      final apiResponse = ApiResponse.fromJson(response.data, (json) => null);

      if (!apiResponse.isSuccess) {
        throw UnknownError(message: apiResponse.message ?? "Something went wrong");
      }

      // Parse the data from the response
      final responseData = response.data['data'];
      return JoinContestResponseModel.fromJson(responseData);
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: e.toString());
    }
  }

  @override
  Future<StatsModel> getMyContests() async {
    try {
      final response = await client.get(ApiUrls.getMyContests);
      final responseData = response.data['data'];
      return StatsModel.fromJson(responseData);
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: e.toString());
    }
  }

  @override
  Future<String> updateTeam(JoinContestParamsModel params) async {
    try {
      final response = await client.post(ApiUrls.updateTeam(params.teamId.toString()), data: params.toJson());
      final responseData = response.data['data'];
      return responseData;
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: e.toString());
    }
  }

  @override
  Future<List<LearningModel>> getLearningList(String params) async {
    try {
      final response = await client.get(ApiUrls.learningContent, queryParameters: {'type': params});

      final List<dynamic> jsonList = response.data['data']['data'];
      final learningList = jsonList.map((json) => LearningModel.fromJson(json)).toList();

      return learningList;
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: e.toString());
    }
  }

  @override
  Future<List<AdsModel>> getAds() async {
    try {
      final response = await client.get(ApiUrls.getAds);

      final List<dynamic> jsonList = response.data['data'];
      final adsList = jsonList.map((json) => AdsModel.fromJson(json)).toList();

      return adsList;
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: e.toString());
    }
  }

  @override
  Future<ClientTeamsResponseModel> teamsClient(JoinContestParamsModel params) async {
    try {
      final response =
          params.isPostApi == true
              ? client.post(ApiUrls.clientTeams(params.teamId ?? ''), data: params.toJson())
              : client.get(ApiUrls.clientTeams(params.teamId ?? ''));

      final responseData = (await response).data['data'];
      final result = ClientTeamsResponseModel.fromJson(responseData);
      return result;
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: e.toString());
    }
  }

  @override
  Future<ContestDetailModel> contestDetails(String params) async {
    try {
      final response = await client.get(ApiUrls.clientContestDetails(params));
      final data = response.data['data'];
      return ContestDetailModel.fromJson(data);
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: e.toString());
    }
  }

  @override
  Future<ContestLeaderboardModel> contestLeaderboard(String params) async {
    try {
      final response = await client.get(ApiUrls.clientContestLeaderboard(params));
      final data = response.data['data'];
      return ContestLeaderboardModel.fromJson(data);
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: e.toString());
    }
  }
}
