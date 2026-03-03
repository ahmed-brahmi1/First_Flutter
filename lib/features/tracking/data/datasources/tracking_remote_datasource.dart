import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../dashboard/data/models/location_model.dart';
import '../models/geofence_model.dart';

/// Location data from backend GET /device-data (backend has no /tracking).
abstract class TrackingRemoteDataSource {
  Future<LocationModel> getRealtimeLocation();
  Future<GeofenceModel> setGeofence(GeofenceModel geofence);
  Future<List<LocationModel>> getLocationHistory(DateTime start, DateTime end);
}

class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final ApiClient apiClient;

  TrackingRemoteDataSourceImpl({required this.apiClient});

  Future<List<Map<String, dynamic>>> _fetchDeviceData() async {
    final response = await apiClient.get('/device-data');
    final list = apiClient.decodeJsonOrThrow<List<dynamic>>(response);
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  static LocationModel _rowToLocation(Map<String, dynamic> row) {
    final lat = (row['gps_lat'] as num).toDouble();
    final lng = (row['gps_lng'] as num).toDouble();
    final timestamp = row['timestamp'] as String? ?? DateTime.now().toIso8601String();
    return LocationModel(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.parse(timestamp),
      accuracy: 10.0,
    );
  }

  @override
  Future<LocationModel> getRealtimeLocation() async {
    try {
      final rows = await _fetchDeviceData();
      final withGps = rows.where((r) =>
          r['gps_lat'] != null && r['gps_lng'] != null).toList();
      if (withGps.isEmpty) {
        throw ServerException('No location data', 404);
      }
      return _rowToLocation(withGps.first);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<GeofenceModel> setGeofence(GeofenceModel geofence) async {
    throw ServerException('Geofence not supported by backend', 501);
  }

  @override
  Future<List<LocationModel>> getLocationHistory(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final rows = await _fetchDeviceData();
      final withGps = rows.where((r) =>
          r['gps_lat'] != null && r['gps_lng'] != null).toList();
      final list = <LocationModel>[];
      for (final row in withGps) {
        final ts = row['timestamp'] as String?;
        if (ts == null) continue;
        final dt = DateTime.parse(ts);
        if (!dt.isBefore(start) && !dt.isAfter(end)) {
          list.add(_rowToLocation(row));
        }
      }
      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}
