class AppConstants {
  // Demo Mode - Set to true to use mock data instead of real API
  static const bool useDemoMode = true; // Activer le mock pour tout le reste (dashboard, etc.)
  static const bool useRealAuth = true; // Forcer l'API réelle UNIQUEMENT pour Auth
  
  // API Endpoints
  static const String baseUrl = 'http://10.0.2.2:8081';
  static const String apiVersion = '/api';
  
  // MQTT Configuration
  static const String mqttBroker = 'mqtt.smartpet.com';
  static const int mqttPort = 1883;
  static const String mqttClientId = 'smartpet_mobile';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String refreshTokenKey = 'refresh_token';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Location
  static const double defaultLatitude = 0.0;
  static const double defaultLongitude = 0.0;
  static const double geofenceDefaultRadius = 100.0; // meters
}
