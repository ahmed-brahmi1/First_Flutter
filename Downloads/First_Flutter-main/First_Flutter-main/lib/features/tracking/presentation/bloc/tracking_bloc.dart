import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_realtime_location.dart';
import '../../domain/usecases/set_geofence.dart';
import '../../domain/usecases/get_location_history.dart';
import '../../../../core/usecases/usecase.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final GetRealtimeLocation getRealtimeLocation;
  final SetGeofence setGeofence;
  final GetLocationHistory getLocationHistory;

  TrackingBloc({
    required this.getRealtimeLocation,
    required this.setGeofence,
    required this.getLocationHistory,
  }) : super(TrackingInitial()) {
    on<LoadRealtimeLocation>(_onLoadRealtimeLocation);
    on<SetGeofenceRequested>(_onSetGeofenceRequested);
    on<LoadLocationHistory>(_onLoadLocationHistory);
  }

  Future<void> _onLoadRealtimeLocation(
    LoadRealtimeLocation event,
    Emitter<TrackingState> emit,
  ) async {
    emit(TrackingLoading());
    final result = await getRealtimeLocation(const NoParams());

    result.fold(
      (failure) => emit(TrackingError(failure.message)),
      (location) => emit(TrackingLoaded(currentLocation: location)),
    );
  }

  Future<void> _onSetGeofenceRequested(
    SetGeofenceRequested event,
    Emitter<TrackingState> emit,
  ) async {
    emit(TrackingLoading());
    final result = await setGeofence(SetGeofenceParams(geofence: event.geofence));

    result.fold(
      (failure) => emit(TrackingError(failure.message)),
      (geofence) {
        if (state is TrackingLoaded) {
          final currentState = state as TrackingLoaded;
          final updatedGeofences = [
            ...?currentState.geofences,
            geofence,
          ];
          emit(TrackingLoaded(
            currentLocation: currentState.currentLocation,
            locationHistory: currentState.locationHistory,
            geofences: updatedGeofences,
          ));
        }
      },
    );
  }

  Future<void> _onLoadLocationHistory(
    LoadLocationHistory event,
    Emitter<TrackingState> emit,
  ) async {
    emit(TrackingLoading());
    final result = await getLocationHistory(
      GetLocationHistoryParams(start: event.start, end: event.end),
    );

    result.fold(
      (failure) => emit(TrackingError(failure.message)),
      (locations) {
        if (state is TrackingLoaded) {
          final currentState = state as TrackingLoaded;
          emit(TrackingLoaded(
            currentLocation: currentState.currentLocation,
            locationHistory: locations,
            geofences: currentState.geofences,
          ));
        }
      },
    );
  }
}

