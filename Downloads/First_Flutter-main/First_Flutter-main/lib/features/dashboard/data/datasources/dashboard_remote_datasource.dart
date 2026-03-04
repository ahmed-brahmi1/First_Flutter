import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/pet_status_model.dart';
import '../models/location_model.dart';
import '../models/health_data_model.dart';

abstract class DashboardRemoteDataSource {
  Future<PetStatusModel> getPetStatus(String token);
  Future<LocationModel> getLocation(String token);
  Future<HealthDataModel> getHealthData(String token);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final http.Client client;

  DashboardRemoteDataSourceImpl({required this.client});

  @override
  Future<PetStatusModel> getPetStatus(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/dashboard/status'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return PetStatusModel.fromJson(jsonData);
      } else {
        throw ServerException(
          'Failed to get pet status: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<LocationModel> getLocation(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/dashboard/location'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return LocationModel.fromJson(jsonData);
      } else {
        throw ServerException(
          'Failed to get location: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<HealthDataModel> getHealthData(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/dashboard/health'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return HealthDataModel.fromJson(jsonData);
      } else {
        throw ServerException(
          'Failed to get health data: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}

