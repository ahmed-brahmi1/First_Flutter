import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/alert_model.dart';

abstract class AlertRemoteDataSource {
  Future<List<AlertModel>> getAlerts(String token);
  Future<void> markAlertRead(String token, String alertId);
  Future<void> subscribePushNotifications(String token, String deviceToken);
}

class AlertRemoteDataSourceImpl implements AlertRemoteDataSource {
  final http.Client client;

  AlertRemoteDataSourceImpl({required this.client});

  @override
  Future<List<AlertModel>> getAlerts(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/alerts'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        return jsonData
            .map((item) => AlertModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Failed to get alerts: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<void> markAlertRead(String token, String alertId) async {
    try {
      final response = await client.put(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/alerts/$alertId/read'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to mark alert as read: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<void> subscribePushNotifications(String token, String deviceToken) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/alerts/subscribe'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'device_token': deviceToken}),
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          'Failed to subscribe to push notifications: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}

