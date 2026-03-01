import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_alerts.dart';
import '../../domain/usecases/mark_alert_read.dart';
import '../../domain/entities/alert.dart';
import '../../../../core/usecases/usecase.dart';
import 'alerts_event.dart';
import 'alerts_state.dart';

class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  final GetAlerts getAlerts;
  final MarkAlertRead markAlertRead;

  AlertsBloc({
    required this.getAlerts,
    required this.markAlertRead,
  }) : super(AlertsInitial()) {
    on<LoadAlerts>(_onLoadAlerts);
    on<MarkAlertReadRequested>(_onMarkAlertReadRequested);
  }

  Future<void> _onLoadAlerts(
    LoadAlerts event,
    Emitter<AlertsState> emit,
  ) async {
    emit(AlertsLoading());
    final result = await getAlerts(const NoParams());

    result.fold(
      (failure) => emit(AlertsError(failure.message)),
      (alerts) => emit(AlertsLoaded(alerts)),
    );
  }

  Future<void> _onMarkAlertReadRequested(
    MarkAlertReadRequested event,
    Emitter<AlertsState> emit,
  ) async {
    final result = await markAlertRead(MarkAlertReadParams(alertId: event.alertId));

    result.fold(
      (failure) {
        // Don't emit error, just log it
      },
      (_) {
        if (state is AlertsLoaded) {
          final currentState = state as AlertsLoaded;
          final updatedAlerts = currentState.alerts.map((alert) {
            if (alert.id == event.alertId) {
              return Alert(
                id: alert.id,
                title: alert.title,
                message: alert.message,
                type: alert.type,
                timestamp: alert.timestamp,
                isRead: true,
              );
            }
            return alert;
          }).toList();
          emit(AlertsLoaded(updatedAlerts));
        }
      },
    );
  }
}

