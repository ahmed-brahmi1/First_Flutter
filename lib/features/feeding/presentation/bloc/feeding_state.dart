import 'package:equatable/equatable.dart';
import '../../domain/entities/feeding_schedule.dart';

abstract class FeedingState extends Equatable {
  const FeedingState();

  @override
  List<Object?> get props => [];
}

class FeedingInitial extends FeedingState {}

class FeedingLoading extends FeedingState {}

class FeedingLoaded extends FeedingState {
  final List<FeedingSchedule> schedules;

  const FeedingLoaded(this.schedules);

  @override
  List<Object?> get props => [schedules];
}

class FeedingError extends FeedingState {
  final String message;

  const FeedingError(this.message);

  @override
  List<Object?> get props => [message];
}

class FeedingSuccess extends FeedingState {
  final String message;

  const FeedingSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

