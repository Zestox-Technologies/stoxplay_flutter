import 'package:dio/dio.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/core/network/api_service.dart';
import 'package:stoxplay/core/network/api_urls.dart';
import 'package:stoxplay/core/network/app_error.dart';
import 'package:stoxplay/features/home_page/data/models/contest_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_params_model.dart';
import 'package:stoxplay/features/home_page/data/models/join_contest_response_model.dart';
import 'package:stoxplay/features/home_page/data/models/stock_data_model.dart';
import 'package:stoxplay/utils/models/QueryParams.dart';

import 'models/sector_model.dart';

abstract class HomeRds {
  Future<SectorListResponse> getSectorList();

  Future<List<ContestModel>> getContestList(String sectorId);

  Future<bool> getContestStatus();

  Future<StockResponseModel> getStockList(String contestId);

  Future<JoinContestResponseModel> joinContest(JoinContestParamsModel contestId);
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
}
