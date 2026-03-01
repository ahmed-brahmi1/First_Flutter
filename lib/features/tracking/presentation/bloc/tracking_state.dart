import 'package:equatable/equatable.dart';
import '../../../dashboard/domain/entities/location.dart';
import '../../domain/entities/geofence.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {}

class TrackingLoading extends TrackingState {}

class TrackingLoaded extends TrackingState {
  final Location currentLocation;
  final List<Location>? locationHistory;
  final List<Geofence>? geofences;

  const TrackingLoaded({
    required this.currentLocation,
    this.locationHistory,
    this.geofences,
  });

  @override
  List<Object?> get props => [currentLocation, locationHistory, geofences];
}

class TrackingError extends TrackingState {
  final String message;

  const TrackingError(this.message);

  @override
  List<Object?> get props => [message];
}

