import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/health_data_model.dart';
import '../models/location_model.dart';
import '../models/pet_status_model.dart';

/// Dashboard data is derived from backend GET /device-data (list ordered by timestamp desc).
abstract class DashboardRemoteDataSource {
  Future<PetStatusModel> getPetStatus();
  Future<LocationModel> getLocation();
  Future<HealthDataModel> getHealthData();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSourceImpl({required this.apiClient});

  Future<List<Map<String, dynamic>>> _fetchDeviceData() async {
    final response = await apiClient.get('/device-data');
    final list = apiClient.decodeJsonOrThrow<List<dynamic>>(response);
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  @override
  Future<PetStatusModel> getPetStatus() async {
    try {
      final rows = await _fetchDeviceData();
      if (rows.isEmpty) {
        throw ServerException('No device data', 404);
      }
      final row = rows.first;
      final deviceId = row['device_id'] as String? ?? row['id'] as String? ?? '';
      final batteryLevel = (row['battery_level'] as num?)?.toDouble() ?? 0.0;
      final timestamp = row['timestamp'] as String? ?? DateTime.now().toIso8601String();
      return PetStatusModel(
        id: deviceId,
        isActive: true,
        batteryLevel: batteryLevel,
        lastUpdate: DateTime.parse(timestamp),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<LocationModel> getLocation() async {
    try {
      final rows = await _fetchDeviceData();
      final withGps = rows.where((r) {
        final lat = r['gps_lat'];
        final lng = r['gps_lng'];
        return lat != null && lng != null;
      }).toList();
      if (withGps.isEmpty) {
        throw ServerException('No location data', 404);
      }
      final row = withGps.first;
      final lat = (row['gps_lat'] as num).toDouble();
      final lng = (row['gps_lng'] as num).toDouble();
      final timestamp = row['timestamp'] as String? ?? DateTime.now().toIso8601String();
      return LocationModel(
        latitude: lat,
        longitude: lng,
        timestamp: DateTime.parse(timestamp),
        accuracy: 10.0,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<HealthDataModel> getHealthData() async {
    try {
      final rows = await _fetchDeviceData();
      if (rows.isEmpty) {
        throw ServerException('No device data', 404);
      }
      final row = rows.first;
      final id = row['id'] as String? ?? row['device_id'] as String? ?? '';
      final temperature = (row['temperature'] as num?)?.toDouble() ?? 0.0;
      final timestamp = row['timestamp'] as String? ?? DateTime.now().toIso8601String();
      return HealthDataModel(
        id: id,
        temperature: temperature,
        heartRate: 0,
        activityLevel: 0,
        timestamp: DateTime.parse(timestamp),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}
