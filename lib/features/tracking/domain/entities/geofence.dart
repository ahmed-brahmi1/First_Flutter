import 'package:equatable/equatable.dart';

class Geofence extends Equatable {
  final String id;
  final double latitude;
  final double longitude;
  final double radius;
  final String name;
  final bool isActive;

  const Geofence({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.name,
    required this.isActive,
  });

  @override
  List<Object> get props => [id, latitude, longitude, radius, name, isActive];
}

