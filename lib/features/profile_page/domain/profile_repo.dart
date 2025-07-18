import 'package:stoxplay/features/profile_page/data/profile_model.dart';
import 'package:stoxplay/features/profile_page/data/profile_rds.dart';


abstract class ProfileRepo {
  Future<ProfileModel> getProfile();
}

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRds rds;
  ProfileRepoImpl(this.rds);

  @override
  Future<ProfileModel> getProfile() => rds.getProfile();
} 