import 'package:dio/dio.dart';
import 'package:stoxplay/core/network/api_service.dart';
import 'package:stoxplay/core/network/api_urls.dart';
import 'package:stoxplay/features/profile_page/data/models/playing_history_model.dart';

import 'models/profile_model.dart';

abstract class ProfileRds {
  Future<ProfileModel> getProfile();

  Future<ProfileModel> updateProfile(Map<String, dynamic> data);

  Future<String> fileUpload(Map<String, dynamic> data);

  Future<PlayingHistoryModel> getPlayingHistory(Map<String, dynamic> params);
}

class ProfileRdsImpl implements ProfileRds {
  final ApiService apiService;

  ProfileRdsImpl({required this.apiService});

  @override
  Future<ProfileModel> getProfile() async {
    final response = await apiService.get(ApiUrls.getProfile);
    final data = response.data['data'];
    return ProfileModel.fromJson(data);
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
    final response = await apiService.put(ApiUrls.getProfile, data: data);
    final updatedData = response.data['data'];
    return ProfileModel.fromJson(updatedData);
  }

  @override
  Future<String> fileUpload(Map<String, dynamic> data) async {
    final file = await MultipartFile.fromFile(data["file"], contentType: DioMediaType("image", "jpeg"));
    data.addAll({"file": file});
    final response = await apiService.postFormData(ApiUrls.fileUpload, formFields: data);
    final url = response.data['data']['url'];
    return url;
  }

  @override
  Future<PlayingHistoryModel> getPlayingHistory(Map<String, dynamic> params) async {
    // Ensure page and limit are forwarded as query parameters for pagination
    final int page = params['page'] ?? 1;
    final int limit = params['limit'] ?? 10;

    final response = await apiService.get(
      ApiUrls.getPlayingHistory,
      queryParameters: {
        ...params,
        'page': page,
        'limit': limit,
      },
    );
    final data = response.data['data'];
    return PlayingHistoryModel.fromJson(data);
  }
}
