import '../data/profile_model.dart';
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
