import 'package:equatable/equatable.dart';

class HealthLog extends Equatable {
  final String id;
  final double temperature;
  final int heartRate;
  final int activityLevel;
  final DateTime timestamp;
  final String? notes;

  const HealthLog({
    required this.id,
    required this.temperature,
    required this.heartRate,
    required this.activityLevel,
    required this.timestamp,
    this.notes,
  });

  @override
  List<Object?> get props => [id, temperature, heartRate, activityLevel, timestamp, notes];
}

