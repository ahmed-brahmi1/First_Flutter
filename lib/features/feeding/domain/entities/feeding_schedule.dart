import 'package:equatable/equatable.dart';

class FeedingSchedule extends Equatable {
  final String id;
  final DateTime time;
  final double amount;
  final bool isActive;
  final List<int> daysOfWeek; // 0 = Sunday, 6 = Saturday

  const FeedingSchedule({
    required this.id,
    required this.time,
    required this.amount,
    required this.isActive,
    required this.daysOfWeek,
  });

  @override
  List<Object> get props => [id, time, amount, isActive, daysOfWeek];
}

