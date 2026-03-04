import 'package:equatable/equatable.dart';
import '../../domain/entities/feeding_schedule.dart';

abstract class FeedingEvent extends Equatable {
  const FeedingEvent();

  @override
  List<Object> get props => [];
}

class LoadFeedingLogs extends FeedingEvent {
  const LoadFeedingLogs();
}

class TriggerManualFeedRequested extends FeedingEvent {
  const TriggerManualFeedRequested();
}

class SetScheduleRequested extends FeedingEvent {
  final FeedingSchedule schedule;

  const SetScheduleRequested(this.schedule);

  @override
  List<Object> get props => [schedule];
}

