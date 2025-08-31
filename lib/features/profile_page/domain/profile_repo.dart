import 'package:stoxplay/features/profile_page/data/models/profile_model.dart';
import 'package:stoxplay/features/profile_page/data/models/playing_history_model.dart';
import 'package:stoxplay/features/profile_page/data/profile_rds.dart';

abstract class ProfileRepo {
  Future<ProfileModel> getProfile();

  Future<ProfileModel> updateProfile(Map<String, dynamic> data);

  Future<String> fileUpload(Map<String, dynamic> data);

  Future<PlayingHistoryModel> getPlayingHistory(Map<String, dynamic> params);
}

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRds rds;

  ProfileRepoImpl(this.rds);

  @override
  Future<ProfileModel> getProfile() => rds.getProfile();

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> data) => rds.updateProfile(data);

  @override
  Future<String> fileUpload(Map<String, dynamic> data) async {
    return rds.fileUpload(data);
  }

  @override
  Future<PlayingHistoryModel> getPlayingHistory(Map<String, dynamic> params) {
    return rds.getPlayingHistory(params);
  }
}
