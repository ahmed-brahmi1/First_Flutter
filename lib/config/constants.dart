class AppConstants {
  // Demo Mode - Set to false to use real NestJS API; true for mock data only
  static const bool useDemoMode = false;
  
  // API Endpoints (smart-pet-backend: no global prefix)
  static const String baseUrl = 'http://192.168.100.4:3000';
  static const String apiVersion = '';

  // Storage Keys
  // NOTE: Auth storage keys are centrally defined in
  // `AuthLocalDataSourceImpl` to avoid duplication.
  
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

