import '../../../../core/errors/exceptions.dart';
import '../models/alert_model.dart';

abstract class AlertLocalDataSource {
  Future<void> cacheAlerts(List<AlertModel> alerts);
  Future<List<AlertModel>> getCachedAlerts();
}

class AlertLocalDataSourceImpl implements AlertLocalDataSource {
  // TODO: Implement with SharedPreferences or similar
  List<AlertModel> _cachedAlerts = [];

  @override
  Future<void> cacheAlerts(List<AlertModel> alerts) async {
    try {
      _cachedAlerts = alerts;
    } catch (e) {
      throw CacheException('Failed to cache alerts: $e');
    }
  }

  @override
  Future<List<AlertModel>> getCachedAlerts() async {
    try {
      return _cachedAlerts;
    } catch (e) {
      throw CacheException('Failed to get cached alerts: $e');
    }
  }
}

