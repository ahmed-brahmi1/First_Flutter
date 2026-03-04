import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/health_log_model.dart';
import 'package:smartpet/features/data/models/sensor_model.dart';

abstract class HealthRemoteDataSource {
  Future<List<HealthLogModel>> getTemperatureHistory(String token, DateTime start, DateTime end);
  Future<Map<String, dynamic>> getAIPredictions(String token);
  Future<SensorModel> getLatestSensor();
}

class HealthRemoteDataSourceImpl implements HealthRemoteDataSource {
  final http.Client client;

  HealthRemoteDataSourceImpl({required this.client});

  @override
  Future<List<HealthLogModel>> getTemperatureHistory(
    String token,
    DateTime start,
    DateTime end,
  ) async {
    try {
      final response = await client.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.apiVersion}/health/temperature?'
          'start=${start.toIso8601String()}&end=${end.toIso8601String()}',
        ),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        return jsonData
            .map((item) => HealthLogModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Failed to get temperature history: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getAIPredictions(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/health/ai-predictions'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ServerException(
          'Failed to get AI predictions: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
   @override
    Future<SensorModel> getLatestSensor() async {  // ← AJOUTEZ CETTE MÉTHODE
      try {
        final response = await client.get(
          Uri.parse('http://10.0.2.2:8081/api/sensor/latest'),
        ).timeout(AppConstants.connectionTimeout);

        if (response.statusCode == 200) {
          return SensorModel.fromJson(json.decode(response.body));
        } else {
          throw ServerException(
            'Failed to load latest sensor: ${response.body}',
            response.statusCode,
          );
        }
      } catch (e) {
        if (e is ServerException) rethrow;
        throw NetworkException('Network error: $e');
      }
    }

}

