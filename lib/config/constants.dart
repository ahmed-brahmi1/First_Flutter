class AppConstants {
  // Demo Mode - Set to true to use mock data instead of real API
  static const bool useDemoMode = true;
  
  // API Endpoints
  static const String baseUrl = 'https://api.smartpet.com';
  static const String apiVersion = '/v1';
  
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

