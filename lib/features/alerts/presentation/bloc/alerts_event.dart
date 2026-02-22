import 'package:equatable/equatable.dart';

abstract class AlertsEvent extends Equatable {
  const AlertsEvent();

  @override
  List<Object> get props => [];
}

class LoadAlerts extends AlertsEvent {
  const LoadAlerts();
}

class MarkAlertReadRequested extends AlertsEvent {
  final String alertId;

  const MarkAlertReadRequested(this.alertId);

  @override
  List<Object> get props => [alertId];
}

