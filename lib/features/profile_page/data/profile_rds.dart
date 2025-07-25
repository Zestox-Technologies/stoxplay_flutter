import 'package:stoxplay/core/network/api_service.dart';
import 'package:stoxplay/core/network/api_urls.dart';
import 'profile_model.dart';

abstract class ProfileRds {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(Map<String, dynamic> data);
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
} 