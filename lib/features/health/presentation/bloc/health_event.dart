import 'package:equatable/equatable.dart';

abstract class HealthEvent extends Equatable {
  const HealthEvent();

  @override
  List<Object> get props => [];
}

class LoadTemperatureHistory extends HealthEvent {
  final DateTime start;
  final DateTime end;

  const LoadTemperatureHistory({required this.start, required this.end});

  @override
  List<Object> get props => [start, end];
}

class LoadAIPredictions extends HealthEvent {
  const LoadAIPredictions();
}
class LoadLatestSensor extends HealthEvent {
  const LoadLatestSensor();
}

