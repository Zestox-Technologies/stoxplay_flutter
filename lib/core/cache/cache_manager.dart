import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  final StorageService _storageService = StorageService();

  /// Initialize cache manager - load cached data on app startup
  Future<void> initialize() async {
    // Pre-load critical cached data for faster app startup
    await _preloadCriticalCache();
  }

  /// Pre-load critical cached data
  Future<void> _preloadCriticalCache() async {
    // This method can be used to pre-load critical data
    // For now, we'll just ensure the storage service is ready
  }

  /// Clear all cache data
  Future<void> clearAllCache() async {
    await _storageService.clearAllCache();
  }

  /// Clear specific cache
  Future<void> clearCache(String cacheKey) async {
    await _storageService.invalidateCache(cacheKey);
  }

  /// Clear user-specific cache (called on logout)
  Future<void> clearUserCache() async {
    await _storageService.invalidateCache(DBKeys.profileCacheKey);
    await _storageService.invalidateCache(DBKeys.homeDataCacheKey);
    await _storageService.invalidateCache(DBKeys.statsCacheKey);
    await _storageService.invalidateCache(DBKeys.adsCacheKey);
    await _storageService.invalidateCache(DBKeys.mostPickedStockCacheKey);
    // Clear all learning cache variations
    await _storageService.clearAllCache(); // This will clear all learning cache keys
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    // This can be used for debugging cache performance
    return {
      'cacheKeys': [
        DBKeys.profileCacheKey,
        DBKeys.homeDataCacheKey,
        DBKeys.statsCacheKey,
        DBKeys.adsCacheKey,
        DBKeys.mostPickedStockCacheKey,
        DBKeys.learningDataCacheKey,
      ],
    };
  }

  /// Check if cache is valid for a given key
  bool isCacheValid(String cacheKey, {Duration maxAge = const Duration(minutes: 5)}) {
    return _storageService.getCachedData(cacheKey, maxAge: maxAge) != null;
  }

  /// Force refresh all data (clear cache and trigger fresh API calls)
  Future<void> forceRefreshAll() async {
    await clearUserCache();
  }
}
