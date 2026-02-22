import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_temperature_history.dart';
import '../../domain/usecases/get_ai_predictions.dart';
import '../../../../core/usecases/usecase.dart';
import 'health_event.dart';
import 'health_state.dart';

class HealthBloc extends Bloc<HealthEvent, HealthState> {
  final GetTemperatureHistory getTemperatureHistory;
  final GetAIPredictions getAIPredictions;

  HealthBloc({
    required this.getTemperatureHistory,
    required this.getAIPredictions,
  }) : super(HealthInitial()) {
    on<LoadTemperatureHistory>(_onLoadTemperatureHistory);
    on<LoadAIPredictions>(_onLoadAIPredictions);
  }

  Future<void> _onLoadTemperatureHistory(
    LoadTemperatureHistory event,
    Emitter<HealthState> emit,
  ) async {
    emit(HealthLoading());
    final result = await getTemperatureHistory(
      GetTemperatureHistoryParams(start: event.start, end: event.end),
    );

    result.fold(
      (failure) => emit(HealthError(failure.message)),
      (history) {
        if (state is HealthLoaded) {
          final currentState = state as HealthLoaded;
          emit(HealthLoaded(
            temperatureHistory: history,
            aiPredictions: currentState.aiPredictions,
          ));
        } else {
          emit(HealthLoaded(temperatureHistory: history));
        }
      },
    );
  }

  Future<void> _onLoadAIPredictions(
    LoadAIPredictions event,
    Emitter<HealthState> emit,
  ) async {
    emit(HealthLoading());
    final result = await getAIPredictions(const NoParams());

    result.fold(
      (failure) => emit(HealthError(failure.message)),
      (predictions) {
        if (state is HealthLoaded) {
          final currentState = state as HealthLoaded;
          emit(HealthLoaded(
            temperatureHistory: currentState.temperatureHistory,
            aiPredictions: predictions,
          ));
        } else {
          emit(HealthLoaded(aiPredictions: predictions));
        }
      },
    );
  }
}

