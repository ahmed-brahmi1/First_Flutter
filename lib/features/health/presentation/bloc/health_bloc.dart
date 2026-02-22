import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

import '../../domain/usecases/get_temperature_history.dart';
import '../../domain/usecases/get_ai_predictions.dart';
import '../../domain/usecases/get_latest_sensor.dart';

import 'health_event.dart';
import 'health_state.dart';

class HealthBloc extends Bloc<HealthEvent, HealthState> {
  final GetTemperatureHistory getTemperatureHistory;
  final GetAIPredictions getAIPredictions;
  final GetLatestSensor getLatestSensor;

  HealthBloc({
    required this.getTemperatureHistory,
    required this.getAIPredictions,
    required this.getLatestSensor,
  }) : super(HealthInitial()) {

    /// 🔥 LOAD LATEST SENSOR (ne retourne PAS Either)
    on<LoadLatestSensor>((event, emit) async {
      try {
        final sensor = await getLatestSensor();

        if (state is HealthLoaded) {
          emit((state as HealthLoaded).copyWith(
            latestSensor: sensor,
          ));
        } else {
          emit(HealthLoaded(latestSensor: sensor));
        }

      } catch (e) {
        emit(HealthError(e.toString()));
      }
    });

    /// 🔥 LOAD TEMPERATURE HISTORY (retourne Either)
    on<LoadTemperatureHistory>((event, emit) async {

      final result = await getTemperatureHistory(
        GetTemperatureHistoryParams(
          start: event.start,
          end: event.end,
        ),
      );

      result.fold(
        (failure) => emit(HealthError(_mapFailureToMessage(failure))),
        (history) {
          if (state is HealthLoaded) {
            emit((state as HealthLoaded).copyWith(
              temperatureHistory: history,
            ));
          } else {
            emit(HealthLoaded(temperatureHistory: history));
          }
        },
      );
    });

    /// 🔥 LOAD AI PREDICTIONS (retourne Either)
    on<LoadAIPredictions>((event, emit) async {

      final result = await getAIPredictions(NoParams());

      result.fold(
        (failure) => emit(HealthError(_mapFailureToMessage(failure))),
        (predictions) {
          if (state is HealthLoaded) {
            emit((state as HealthLoaded).copyWith(
              aiPredictions: predictions,
            ));
          } else {
            emit(HealthLoaded(aiPredictions: predictions));
          }
        },
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.toString();
  }
}