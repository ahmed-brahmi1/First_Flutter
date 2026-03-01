import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class OsmPlace {
  const OsmPlace({
    required this.latitude,
    required this.longitude,
    required this.displayName,
  });

  final double latitude;
  final double longitude;
  final String displayName;
}

class OsmNominatimService {
  OsmNominatimService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _headers = <String, String>{
    'User-Agent': 'SmartPet/1.0.0 (https://github.com/example/smartpet)',
    'Accept-Language': 'en-US,en;q=0.5',
  };

  /// Builds a URI that works on both native (direct) and web (via CORS proxy).
  Uri _buildUri(String path, Map<String, String> params) {
    const host = 'nominatim.openstreetmap.org';
    if (kIsWeb) {
      // On Flutter Web, Nominatim blocks xhr due to CORS.
      // Route through corsproxy.io.
      final encoded = Uri.https(host, path, params).toString();
      return Uri.parse('https://corsproxy.io/?${Uri.encodeComponent(encoded)}');
    }
    return Uri.https(host, path, params);
  }

  /// Reverse geocode coordinates to a human-readable place name.
  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final uri = _buildUri('/reverse', {
      'format': 'jsonv2',
      'lat': latitude.toString(),
      'lon': longitude.toString(),
      'zoom': '18',
      'addressdetails': '1',
    });

    try {
      final response = await _client.get(uri, headers: _headers);
      if (response.statusCode != 200) return null;
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      return data['display_name'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Forward geocode a place name (e.g. "Berlin") to coordinates.
  Future<OsmPlace?> searchPlace(String query) async {
    if (query.trim().isEmpty) return null;

    final uri = _buildUri('/search', {
      'q': query,
      'format': 'jsonv2',
      'limit': '1',
    });

    try {
      final response = await _client.get(uri, headers: _headers);
      if (response.statusCode != 200) return null;

      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      if (data.isEmpty) return null;

      final Map<String, dynamic> first = data.first as Map<String, dynamic>;
      final lat = double.tryParse(first['lat'] as String? ?? '');
      final lon = double.tryParse(first['lon'] as String? ?? '');
      if (lat == null || lon == null) return null;

      return OsmPlace(
        latitude: lat,
        longitude: lon,
        displayName: first['display_name'] as String? ?? query,
      );
    } catch (_) {
      return null;
    }
  }
}
