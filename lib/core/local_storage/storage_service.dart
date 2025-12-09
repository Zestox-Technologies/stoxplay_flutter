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

  // Cache management methods
  bool _isCacheValid(String cacheKey, {Duration maxAge = const Duration(minutes: 5)}) {
    final timestampKey = '${cacheKey}_timestamp';
    final timestamp = _box.read<int>(timestampKey);
    if (timestamp == null) return false;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(cacheTime) < maxAge;
  }

  void _setCacheTimestamp(String cacheKey) {
    final timestampKey = '${cacheKey}_timestamp';
    _box.write(timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  T? getCachedData<T>(String key, {Duration maxAge = const Duration(minutes: 5)}) {
    if (_isCacheValid(key, maxAge: maxAge)) {
      return _box.read<T>(key);
    }
    return null;
  }

  Future<void> setCachedData<T>(String key, T data) async {
    await _box.write(key, data);
    _setCacheTimestamp(key);
  }

  Future<void> invalidateCache(String key) async {
    await _box.remove(key);
    await _box.remove('${key}_timestamp');
  }

  Future<void> clearAllCache() async {
    final keys = _box.getKeys();
    for (final key in keys) {
      if (key.endsWith('_timestamp') || 
          key.contains('_cache_') ||
          key == DBKeys.user) {
        await _box.remove(key);
      }
    }
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
