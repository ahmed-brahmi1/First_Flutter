import 'package:equatable/equatable.dart';
import '../../domain/entities/health_log.dart';
import 'package:smartpet/features/data/models/sensor_model.dart';

abstract class HealthState extends Equatable {
  const HealthState();

  @override
  List<Object?> get props => [];
}

class HealthInitial extends HealthState {}

class HealthLoading extends HealthState {}

class HealthLoaded extends HealthState {
  final SensorModel? latestSensor;
  final List<HealthLog>? temperatureHistory;
  final Map<String, dynamic>? aiPredictions;

  const HealthLoaded({
    this.latestSensor,
    this.temperatureHistory,
    this.aiPredictions,
  });

  HealthLoaded copyWith({
    SensorModel? latestSensor,
    List<HealthLog>? temperatureHistory,
    Map<String, dynamic>? aiPredictions,
  }) {
    return HealthLoaded(
      latestSensor: latestSensor ?? this.latestSensor,
      temperatureHistory: temperatureHistory ?? this.temperatureHistory,
      aiPredictions: aiPredictions ?? this.aiPredictions,
    );
  }

  @override
  List<Object?> get props => [latestSensor, temperatureHistory, aiPredictions];
}

class HealthError extends HealthState {
  final String message;

  const HealthError(this.message);

  @override
  List<Object?> get props => [message];
}