import 'package:equatable/equatable.dart';

class HealthData extends Equatable {
  final String id;
  final double temperature;
  final int heartRate;
  final int activityLevel;
  final DateTime timestamp;

  const HealthData({
    required this.id,
    required this.temperature,
    required this.heartRate,
    required this.activityLevel,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, temperature, heartRate, activityLevel, timestamp];
}

