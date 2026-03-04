import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_feeding_logs.dart';
import '../../domain/usecases/trigger_manual_feed.dart';
import '../../domain/usecases/set_schedule.dart';
import '../../../../core/usecases/usecase.dart';
import 'feeding_event.dart';
import 'feeding_state.dart';

class FeedingBloc extends Bloc<FeedingEvent, FeedingState> {
  final GetFeedingLogs getFeedingLogs;
  final TriggerManualFeed triggerManualFeed;
  final SetSchedule setSchedule;

  FeedingBloc({
    required this.getFeedingLogs,
    required this.triggerManualFeed,
    required this.setSchedule,
  }) : super(FeedingInitial()) {
    on<LoadFeedingLogs>(_onLoadFeedingLogs);
    on<TriggerManualFeedRequested>(_onTriggerManualFeedRequested);
    on<SetScheduleRequested>(_onSetScheduleRequested);
  }

  Future<void> _onLoadFeedingLogs(
    LoadFeedingLogs event,
    Emitter<FeedingState> emit,
  ) async {
    emit(FeedingLoading());
    final result = await getFeedingLogs(const NoParams());

    result.fold(
      (failure) => emit(FeedingError(failure.message)),
      (schedules) => emit(FeedingLoaded(schedules)),
    );
  }

  Future<void> _onTriggerManualFeedRequested(
    TriggerManualFeedRequested event,
    Emitter<FeedingState> emit,
  ) async {
    emit(FeedingLoading());
    final result = await triggerManualFeed(const NoParams());

    result.fold(
      (failure) => emit(FeedingError(failure.message)),
      (_) => emit(const FeedingSuccess('Manual feed triggered successfully')),
    );
  }

  Future<void> _onSetScheduleRequested(
    SetScheduleRequested event,
    Emitter<FeedingState> emit,
  ) async {
    emit(FeedingLoading());
    final result = await setSchedule(SetScheduleParams(schedule: event.schedule));

    result.fold(
      (failure) => emit(FeedingError(failure.message)),
      (_) => emit(const FeedingSuccess('Schedule set successfully')),
    );
  }
}

