import 'package:stoxplay/core/network/api_service.dart';
import 'package:stoxplay/core/network/api_urls.dart';
import 'profile_model.dart';

abstract class ProfileRds {
  Future<ProfileModel> getProfile();
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
} 