import '../data/profile_model.dart';
import 'profile_repo.dart';

class GetProfileUseCase {
  final ProfileRepo repo;
  GetProfileUseCase(this.repo);

  Future<ProfileModel> call() async {
    return await repo.getProfile();
  }
} 