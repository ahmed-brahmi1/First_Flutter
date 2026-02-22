import 'package:equatable/equatable.dart';
import '../../domain/entities/health_log.dart';

abstract class HealthState extends Equatable {
  const HealthState();

  @override
  List<Object?> get props => [];
}

class HealthInitial extends HealthState {}

class HealthLoading extends HealthState {}

class HealthLoaded extends HealthState {
  final List<HealthLog>? temperatureHistory;
  final Map<String, dynamic>? aiPredictions;

  const HealthLoaded({
    this.temperatureHistory,
    this.aiPredictions,
  });

  @override
  List<Object?> get props => [temperatureHistory, aiPredictions];
}

class HealthError extends HealthState {
  final String message;

  const HealthError(this.message);

  @override
  List<Object?> get props => [message];
}

