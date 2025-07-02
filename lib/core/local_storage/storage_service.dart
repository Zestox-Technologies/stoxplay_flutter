import 'package:get_storage/get_storage.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() => _instance;

  late final GetStorage _box;

  StorageService._internal();

  /// Call this during app initialization
  Future<void> init() async {
    await GetStorage.init();
    _box = GetStorage();
  }

  // ----------- Setters -----------
  Future<void> saveUserToken(String token) async {
    await write(DBKeys.userTokenKey, token);
  }

  Future<void> setLoggedIn(bool value) async {
    await write(DBKeys.isLoggedInKey, value);
  }

  // ----------- Getters -----------
  String? getUserToken() {
    return read<String>(DBKeys.userTokenKey);
  }

  bool isLoggedIn() {
    return read<bool>(DBKeys.isLoggedInKey) ?? false;
  }

  // ----------- Removers -----------
  Future<void> clearUserToken() async {
    await _box.remove(DBKeys.userTokenKey);
  }

  Future<void> clearAll() async {
    await _box.erase();
  }

  // ----------- Generic Methods -----------
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }
}
