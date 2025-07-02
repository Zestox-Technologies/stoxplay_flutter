import 'package:dio/dio.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/core/network/api_service.dart';
import 'package:stoxplay/core/network/api_urls.dart';
import 'package:stoxplay/core/network/app_error.dart';

import 'models/sector_model.dart';

abstract class HomeRds {
  Future<List<SectorModel>> getSectorList();

  Future<bool> getContestStatus();
}

class HomeRdsImpl extends HomeRds {
  final ApiService client;

  HomeRdsImpl(this.client);

  @override
  Future<List<SectorModel>> getSectorList() async {
    try {
      final response = await client.get(ApiUrls.getSectorList);

      final List<dynamic> jsonList = response.data['data']['data'];
      final sectorList = jsonList.map((json) => SectorModel.fromJson(json)).toList();

      return sectorList;
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
}
