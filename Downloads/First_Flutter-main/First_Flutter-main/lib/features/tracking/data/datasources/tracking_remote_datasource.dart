import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/geofence_model.dart';
import '../../../dashboard/data/models/location_model.dart';

abstract class TrackingRemoteDataSource {
  Future<LocationModel> getRealtimeLocation(String token);
  Future<GeofenceModel> setGeofence(String token, GeofenceModel geofence);
  Future<List<LocationModel>> getLocationHistory(String token, DateTime start, DateTime end);
}

class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final http.Client client;

  TrackingRemoteDataSourceImpl({required this.client});

  @override
  Future<LocationModel> getRealtimeLocation(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/tracking/realtime'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return LocationModel.fromJson(jsonData);
      } else {
        throw ServerException(
          'Failed to get realtime location: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<GeofenceModel> setGeofence(String token, GeofenceModel geofence) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/tracking/geofence'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(geofence.toJson()),
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return GeofenceModel.fromJson(jsonData);
      } else {
        throw ServerException(
          'Failed to set geofence: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<List<LocationModel>> getLocationHistory(
    String token,
    DateTime start,
    DateTime end,
  ) async {
    try {
      final response = await client.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.apiVersion}/tracking/history?'
          'start=${start.toIso8601String()}&end=${end.toIso8601String()}',
        ),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        return jsonData
            .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Failed to get location history: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}

