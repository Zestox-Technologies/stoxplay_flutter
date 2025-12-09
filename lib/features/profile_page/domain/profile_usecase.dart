import '../data/models/playing_history_model.dart';
import '../data/models/profile_model.dart';
import 'profile_repo.dart';

class GetProfileUseCase {
  final ProfileRepo repo;

  GetProfileUseCase(this.repo);

  Future<ProfileModel> call() async {
    return await repo.getProfile();
  }
}

class UpdateProfileUseCase {
  final ProfileRepo repo;

  UpdateProfileUseCase(this.repo);

  Future<ProfileModel> call(Map<String, dynamic> data) async {
    return await repo.updateProfile(data);
  }
}

class FileUploadUseCase {
  final ProfileRepo repo;

  FileUploadUseCase(this.repo);

  Future<String> call(Map<String, dynamic> data) async {
    return await repo.fileUpload(data);
  }
}

class GetPlayingHistoryUseCase {
  final ProfileRepo repo;

  GetPlayingHistoryUseCase(this.repo);

  Future<PlayingHistoryModel> call(Map<String, dynamic> params) async {
    return await repo.getPlayingHistory(params);
  }
}
