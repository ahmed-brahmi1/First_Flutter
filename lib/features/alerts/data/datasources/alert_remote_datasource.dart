import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/alert_model.dart';

abstract class AlertRemoteDataSource {
  Future<List<AlertModel>> getAlerts();
  Future<void> markAlertRead(String alertId);
  Future<void> subscribePushNotifications(String deviceToken);
}

class AlertRemoteDataSourceImpl implements AlertRemoteDataSource {
  final ApiClient apiClient;

  AlertRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<AlertModel>> getAlerts() async {
    try {
      final response = await apiClient.get('/alerts');
      final list = apiClient.decodeJsonOrThrow<List<dynamic>>(response);
      return list
          .map((e) => AlertModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<void> markAlertRead(String alertId) async {
    try {
      await apiClient.put('/alerts/$alertId/read');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<void> subscribePushNotifications(String deviceToken) async {
    try {
      await apiClient.post(
        '/alerts/subscribe',
        body: json.encode({'device_token': deviceToken}),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}
