import 'package:equatable/equatable.dart';
import '../../domain/entities/geofence.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object> get props => [];
}

class LoadRealtimeLocation extends TrackingEvent {
  const LoadRealtimeLocation();
}

class SetGeofenceRequested extends TrackingEvent {
  final Geofence geofence;

  const SetGeofenceRequested(this.geofence);

  @override
  List<Object> get props => [geofence];
}

class LoadLocationHistory extends TrackingEvent {
  final DateTime start;
  final DateTime end;

  const LoadLocationHistory({required this.start, required this.end});

  @override
  List<Object> get props => [start, end];
}

