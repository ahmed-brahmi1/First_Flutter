import '../../../../core/errors/exceptions.dart';
import '../models/pet_status_model.dart';
import '../models/location_model.dart';
import '../models/health_data_model.dart';

abstract class DashboardLocalDataSource {
  Future<void> cachePetStatus(PetStatusModel status);
  Future<PetStatusModel?> getCachedPetStatus();
  Future<void> cacheLocation(LocationModel location);
  Future<LocationModel?> getCachedLocation();
  Future<void> cacheHealthData(HealthDataModel healthData);
  Future<HealthDataModel?> getCachedHealthData();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  // TODO: Implement with SharedPreferences or similar
  PetStatusModel? _cachedStatus;
  LocationModel? _cachedLocation;
  HealthDataModel? _cachedHealthData;

  @override
  Future<void> cachePetStatus(PetStatusModel status) async {
    try {
      _cachedStatus = status;
    } catch (e) {
      throw CacheException('Failed to cache pet status: $e');
    }
  }

  @override
  Future<PetStatusModel?> getCachedPetStatus() async {
    try {
      return _cachedStatus;
    } catch (e) {
      throw CacheException('Failed to get cached pet status: $e');
    }
  }

  @override
  Future<void> cacheLocation(LocationModel location) async {
    try {
      _cachedLocation = location;
    } catch (e) {
      throw CacheException('Failed to cache location: $e');
    }
  }

  @override
  Future<LocationModel?> getCachedLocation() async {
    try {
      return _cachedLocation;
    } catch (e) {
      throw CacheException('Failed to get cached location: $e');
    }
  }

  @override
  Future<void> cacheHealthData(HealthDataModel healthData) async {
    try {
      _cachedHealthData = healthData;
    } catch (e) {
      throw CacheException('Failed to cache health data: $e');
    }
  }

  @override
  Future<HealthDataModel?> getCachedHealthData() async {
    try {
      return _cachedHealthData;
    } catch (e) {
      throw CacheException('Failed to get cached health data: $e');
    }
  }
}

