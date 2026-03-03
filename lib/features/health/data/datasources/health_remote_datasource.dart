import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/health_log_model.dart';
import 'package:smartpet/features/data/models/sensor_model.dart';

abstract class HealthRemoteDataSource {
  Future<List<HealthLogModel>> getTemperatureHistory(DateTime start, DateTime end);
  Future<Map<String, dynamic>> getAIPredictions();
  Future<SensorModel> getLatestSensor({String? deviceId});
}

class HealthRemoteDataSourceImpl implements HealthRemoteDataSource {
  final ApiClient apiClient;

  HealthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<HealthLogModel>> getTemperatureHistory(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final response = await apiClient.get('/device-data');
      final list = apiClient.decodeJsonOrThrow<List<dynamic>>(response);
      final rows = list.map((e) => e as Map<String, dynamic>).toList();
      final logs = <HealthLogModel>[];
      for (final row in rows) {
        final ts = row['timestamp'] as String?;
        if (ts == null) continue;
        final dt = DateTime.parse(ts);
        if (dt.isBefore(start) || dt.isAfter(end)) continue;
        final id = row['id'] as String? ?? row['device_id'] as String? ?? '';
        final temp = (row['temperature'] as num?)?.toDouble() ?? 0.0;
        logs.add(HealthLogModel(
          id: id,
          temperature: temp,
          heartRate: 0,
          activityLevel: 0,
          timestamp: dt,
          notes: null,
        ));
      }
      logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return logs;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getAIPredictions() async {
    return <String, dynamic>{};
  }

  @override
  Future<SensorModel> getLatestSensor({String? deviceId}) async {
    try {
      final response = await apiClient.get('/device-data');
      final list = apiClient.decodeJsonOrThrow<List<dynamic>>(response);
      if (list.isEmpty) {
        throw ServerException('No device data available', 404);
      }
      final rows = list.map((e) => e as Map<String, dynamic>).toList();
      Map<String, dynamic> row;
      if (deviceId != null && deviceId.isNotEmpty) {
        final match = rows.where((r) => r['device_id'] == deviceId).toList();
        if (match.isEmpty) {
          throw ServerException('No device data for device $deviceId', 404);
        }
        row = match.first;
      } else {
        row = rows.first;
      }
      return _deviceDataRowToSensorModel(row);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  /// Maps NestJS DeviceData row to SensorModel.
  /// Backend: id, device_id, battery_level, temperature?, timestamp, ...
  /// Missing fields (heartRate, steps) default to 0; healthScore derived from battery_level.
  static SensorModel _deviceDataRowToSensorModel(Map<String, dynamic> row) {
    final id = row['id'];
    final idInt = id is int
        ? id
        : (id is String ? id.hashCode.abs() % 0x7FFFFFFF : 0);
    final temperature = (row['temperature'] as num?)?.toDouble() ?? 0.0;
    final batteryLevel = (row['battery_level'] as num?)?.toDouble() ?? 0.0;
    final healthScore = (batteryLevel * 100).round().clamp(0, 100);
    final timestamp = row['timestamp'] as String? ?? DateTime.now().toIso8601String();
    return SensorModel(
      id: idInt,
      temperature: temperature,
      heartRate: 0,
      steps: 0,
      healthScore: healthScore,
      createdAt: DateTime.parse(timestamp),
    );
  }
}
