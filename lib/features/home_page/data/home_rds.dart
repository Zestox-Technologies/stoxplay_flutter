import 'package:dio/dio.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/core/network/api_service.dart';
import 'package:stoxplay/core/network/api_urls.dart';
import 'package:stoxplay/core/network/app_error.dart';
import 'package:stoxplay/features/home_page/data/models/contest_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_params_model.dart';
import 'package:stoxplay/features/home_page/data/models/stock_data_model.dart';
import 'package:stoxplay/utils/models/QueryParams.dart';

import 'models/sector_model.dart';

abstract class HomeRds {
  Future<SectorListResponse> getSectorList();

  Future<List<ContestModel>> getContestList(String sectorId);

  Future<bool> getContestStatus();

  Future<List<StockDataModel>> getStockList(String contestId);

  Future<ApiResponse> joinContest(JoinContestParamsModel contestId);
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
  Future<List<StockDataModel>> getStockList(String contestId) async {
    try {
      final response = await client.get(ApiUrls.getStocksList(contestId), queryParameters: queryParams.toMap());

      final List<dynamic> jsonList = response.data['data'];
      final stockList = jsonList.map((json) => StockDataModel.fromJson(json)).toList();

      return stockList;
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: 'An unexpected error occurred: $e');
    }
  }

  @override
  Future<ApiResponse> joinContest(JoinContestParamsModel params) async {
    try {
      final response = await client.post(ApiUrls.joinContest(params.contestId), data: params.toJson());
      final apiResponse = ApiResponse.fromJson(response.data, (json) => null);

      if (!apiResponse.isSuccess) {
        throw UnknownError(message: apiResponse.message ?? "Something went wrong");
      }

      return apiResponse;
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    } catch (e) {
      throw UnknownError(message: e.toString());
    }
  }
}
