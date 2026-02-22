import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double? accuracy;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
  });

  @override
  List<Object?> get props => [latitude, longitude, timestamp, accuracy];
}

