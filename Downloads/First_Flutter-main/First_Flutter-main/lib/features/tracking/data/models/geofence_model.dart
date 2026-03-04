import '../../domain/entities/geofence.dart';

class GeofenceModel extends Geofence {
  const GeofenceModel({
    required super.id,
    required super.latitude,
    required super.longitude,
    required super.radius,
    required super.name,
    required super.isActive,
  });

  factory GeofenceModel.fromJson(Map<String, dynamic> json) {
    return GeofenceModel(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: (json['radius'] as num).toDouble(),
      name: json['name'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'name': name,
      'is_active': isActive,
    };
  }
}

